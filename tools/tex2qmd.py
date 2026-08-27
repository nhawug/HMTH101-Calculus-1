#!/usr/bin/env python3
"""Regenerate chapters/*.qmd from HMTH101_Calculus_1_Full_Notes/HMTH101notes.tex.

The website is generated from the same LaTeX source as the printed PDFs, so
the two never drift. Edit the .tex, run this, then `quarto render`.

    python3 tools/tex2qmd.py && quarto render

Needs pandoc on PATH. Anything hand-written for the web -- index.qmd and the
appendix pages -- is not touched; only chapters/*.qmd is rewritten.
"""
import os
import re
import subprocess
import tempfile

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC  = os.path.join(REPO, "HMTH101_Calculus_1_Full_Notes", "HMTH101notes.tex")
WORK = tempfile.mkdtemp(prefix="hmth101-")

CHAPTERS = [
    ("01-basics",                     "The Basics",                     "sec-basics"),
    ("02-functions",                  "Functions",                      "sec-functions"),
    ("03-sequences",                  "Sequences",                      "sec-sequences"),
    ("04-limits-and-continuity",      "Limits and Continuity",          "sec-limits"),
    ("05-differentiation",            "Differentiation",                "sec-differentiation"),
    ("06-applications-of-the-derivative", "Applications of the Derivative", "sec-applications"),
    ("07-integration",                "Integration",                    "sec-integration"),
]

THM_ENVS = ["theorem", "definition", "corollary", "proposition", "example", "exercise"]
PREFIX = {"theorem": "thm", "definition": "def", "corollary": "cor",
          "proposition": "prp", "example": "exm", "exercise": "exr"}
CLASS  = {"theorem": "theorem", "definition": "definition", "corollary": "corollary",
          "proposition": "proposition", "example": "example", "exercise": "exercise"}

EPI = re.compile(r'\\begin\{center\}\s*\\small\{\\parbox\{[^}]*\}\{.*?\\end\{center\}', re.S)

# Native pixel widths, used to cap on-screen size so the scans stay crisp.
PXW = {}


def image_widths():
    d = os.path.join(REPO, "HMTH101_Calculus_1_Full_Notes")
    for f in os.listdir(d):
        if not f.endswith(".png"):
            continue
        try:
            out = subprocess.run(["sips", "-g", "pixelWidth", os.path.join(d, f)],
                                 capture_output=True, text=True).stdout
            PXW[f] = int(re.search(r'pixelWidth:\s*(\d+)', out).group(1))
        except Exception:
            PXW[f] = 600


# --- source-level structural repairs -------------------------------------
# The LaTeX leaves the "number systems" enumerate open for the rest of the
# section, so everything after item 4 renders as part of that item. On paper
# it only shows as an indent; on the web it swallows five subsections.
def matching_end(tex, start, env):
    """Index of the \\end{env} that closes the \\begin{env} at `start`."""
    depth, i = 0, start
    tok = re.compile(r'\\(begin|end)\{%s\}' % env)
    while True:
        mo = tok.search(tex, i)
        if mo is None:
            raise ValueError("unbalanced " + env)
        depth += 1 if mo.group(1) == "begin" else -1
        if depth == 0:
            return mo.start()
        i = mo.end()


def repair(n, tex):
    if n == 1:
        # The enumerate listing the four number systems is never closed, so the
        # rest of the section renders as part of item 4 -- an indent on paper,
        # five swallowed subsections on the web.
        beg = tex.index("\\begin{enumerate}")
        end = matching_end(tex, beg, "enumerate")
        cut = tex.index("\n", tex.index("\\frac{19}{6}=3.1\\dot{6}$."))
        tex = (tex[:cut] + "\n\\end{enumerate}\n" + tex[cut:end]
               + tex[end + len("\\end{enumerate}"):])
    return tex


def preprocess(tex, n):
    meta = {}
    m = re.match(r'\\chapter\{([^}]*)\}', tex)
    meta["title"] = m.group(1)
    tex = tex[m.end():]

    em = EPI.search(tex)
    if em:
        blk = em.group(0)
        q = re.search(r'\\textit\{(.*?)\}\s*\n?\s*\}', blk, re.S)
        a = re.search(r'\\hfill\{---(.*?)\}', blk, re.S)
        if q:
            quote = " ".join(q.group(1).split())
            quote = quote.replace("``", "\u201c").replace("''", "\u201d")
            meta["epigraph"] = quote
            meta["epigraph_by"] = " ".join(a.group(1).split()) if a else ""
        tex = tex[:em.start()] + tex[em.end():]

    tex = repair(n, tex)

    # display maths -> plain \[ \]; eqnarray -> aligned (MathJax-safe)
    tex = re.sub(r'\\begin\{equation\*?\}', r'\\[', tex)
    tex = re.sub(r'\\end\{equation\*?\}', r'\\]', tex)
    tex = re.sub(r'\\begin\{eqnarray\*?\}', r'\\[\\begin{aligned}', tex)
    tex = re.sub(r'\\end\{eqnarray\*?\}', r'\\end{aligned}\\]', tex)
    tex = re.sub(r'&\s*(=0|=|<|>|\\leq|\\geq|\\approx|\\Rightarrow|\\equiv|:)\s*&', r'&\1 ', tex)

    # \item[(A1)] -> \item (A1)
    tex = re.sub(r'\\item\[\(([^)\]]*)\)\]', r'\\item (\1) ', tex)
    tex = re.sub(r'\\item\[([^\]]*)\]', r'\\item \1 ', tex)

    envs = []

    def open_env(mo):
        env, opt = mo.group(1), mo.group(2)
        envs.append({"env": env, "title": opt or ""})
        return "\n\nQQOPEN%d\n\n" % (len(envs) - 1)

    tex = re.sub(r'\\begin\{(%s)\}(?:\[([^\]]*)\])?' % "|".join(THM_ENVS), open_env, tex)
    tex = re.sub(r'\\end\{(%s)\}' % "|".join(THM_ENVS), "\n\nQQCLOSE\n\n", tex)
    tex = re.sub(r'\\begin\{proof\}', "\n\nQQPROOF\n\n", tex)
    tex = re.sub(r'\\end\{proof\}', "\n\nQQCLOSE\n\n", tex)
    meta["envs"] = envs

    tex = re.sub(r'\\vspace\{[^}]*\}', "", tex)
    tex = re.sub(r'\\hspace\{[^}]*\}', " ", tex)
    tex = tex.replace(r'\noindent', "")
    tex = re.sub(r'\\\\\[[0-9.]+\s*[a-z]+\]', r'\\\\', tex)
    # stray line break inside inline maths
    tex = tex.replace(r'\dot{9},\\ \frac', r'\dot{9},\ \frac')
    return meta, tex



# pandoc escapes the parentheses when an item's text opens with "(i)", since
# bare "(i)" at the start of a block is itself a list marker.
LABEL_ITEM = re.compile(r'^(\s*)- \\?\((\w{1,3})\\?\) ')


def mark_labelled_lists(md):
    lines = md.split("\n")
    out, i = [], 0
    while i < len(lines):
        mo = LABEL_ITEM.match(lines[i])
        if not mo:
            out.append(lines[i])
            i += 1
            continue
        indent = mo.group(1)
        # take the whole run: item lines at this indent, their continuations,
        # and the blank lines between them
        j, items, ok = i, 0, True
        while j < len(lines):
            ln = lines[j]
            if not ln.strip():
                nxt = j + 1
                while nxt < len(lines) and not lines[nxt].strip():
                    nxt += 1
                if nxt < len(lines) and lines[nxt].startswith(indent + "- "):
                    j = nxt
                    continue
                break
            if ln.startswith(indent + "- "):
                if not LABEL_ITEM.match(ln):
                    ok = False
                    break
                items += 1
                j += 1
            elif ln.startswith(indent + "  ") or ln.startswith(indent + "\t"):
                j += 1
            else:
                break
        if ok and items >= 1:
            out.append(indent + "::: {.labelled}")
            out.append("")
            out.extend(lines[i:j])
            out.append("")
            out.append(indent + ":::")
            i = j
        else:
            out.append(lines[i])
            i += 1
    return "\n".join(out)


def postprocess(md, meta, slug, secid):
    stem = slug.split("-", 1)[1]

    # \section became h1; the chapter title is the page's only h1
    for lvl in (4, 3, 2, 1):
        md = re.sub(r'(?m)^%s (?=\S)' % ("#" * lvl), "#" * (lvl + 1) + " ", md)

    # numbered environments -> Quarto crossref divs
    seen = {}

    def opener(mo):
        e = meta["envs"][int(mo.group(1))]
        env, title = e["env"], e["title"]
        seen[env] = seen.get(env, 0) + 1
        e["ref"] = "%s-%s-%d" % (PREFIX[env], stem, seen[env])
        head = "::: {#%s}" % e["ref"]
        if title:
            head += "\n## " + title
        return head

    md = re.sub(r'(?m)^QQOPEN(\d+)$', opener, md)
    md = re.sub(r'(?m)^QQPROOF$', "::: {.proof}", md)
    md = re.sub(r'(?m)^QQCLOSE$', ":::", md)

    # images
    def img(mo):
        f = mo.group(1)
        w = min(PXW.get(f, 600), 620)
        return '![](../images/%s){fig-align="center" width=%dpx}' % (f, w)

    md = re.sub(r'!\[image\]\(([^)]+)\)\{width="[^"]*"\}\\?', img, md)
    md = re.sub(r'!\[image\]\(([^)]+)\)\\?', img, md)

    # a center div wrapping nothing but a figure is redundant once fig-align is set
    md = re.sub(r'(?m)^::: center\n\n?(!\[\][^\n]*)\n\n?:::$', r'\1', md)
    md = re.sub(r'(?m)^::: center$', "::: {.center}", md)

    # MathJax has no \hbox, and \fbox is a maths-mode command there, so a boxed
    # annotation has to be written the other way round: \boxed around the text.
    md = md.replace(r'\hbox{', r'\text{').replace(r'\mbox{', r'\text{')
    md = re.sub(r'\\text\{\\fbox\{(.*?)\}\}', r'\\boxed{\\text{\1}}', md)

    # eqnarray rows had three columns; align has two, so a row that carried no
    # alignment mark would fall into the first column and be right-aligned.
    def realign(mo):
        block = mo.group(0)
        rows = block.split("\n")
        if not any("&" in r for r in rows):
            return block
        out = []
        for r in rows:
            if (r.strip() and "&" not in r
                    and not r.lstrip().startswith(("\\begin{aligned}", "\\end{aligned}"))):
                r = "&" + r.lstrip()
            out.append(r)
        return "\n".join(out)

    md = re.sub(r'\\begin\{aligned\}.*?\\end\{aligned\}', realign, md, flags=re.S)

    md = md.replace("#tab:template", "#tbl-domain-range")
    md = re.sub(r'(?m)(?<!\\)\\[ \t]*$', "", md)    # stray hard line breaks
    md = re.sub(r'(?<=[.,;:$])\*(?=[A-Za-z])', " *", md)  # \quad eaten before emphasis
    md = re.sub(r'\n{3,}', "\n\n", md)

    # Lists whose items came from \item[(A1)] already carry their own label, so
    # the bullet beside it is a second marker for the same thing. Wrap those
    # lists so the stylesheet can drop the bullet and keep the label.
    md = mark_labelled_lists(md)

    # tutorial questions -> a boxed exercise set running to the next heading
    lines = md.split("\n")
    out, open_box = [], False
    for ln in lines:
        heading = ln.startswith("## ")
        if open_box and heading:
            out += [":::", ""]
            open_box = False
        if re.match(r'^## Tutorial [Qq]uestions\s*$', ln):
            out += ["## Tutorial questions {.unnumbered}", "", "::: {.tutorial}"]
            open_box = True
            continue
        out.append(ln)
    if open_box:
        out += ["", ":::"]
    md = "\n".join(out)

    return md.strip() + "\n"


def main():
    image_widths()
    os.makedirs(WORK, exist_ok=True)
    src = open(SRC).read()
    idx = [m.start() for m in re.finditer(r'\\chapter\{', src)]
    idx.append(src.index(r'\end{document}'))

    chdir = os.path.join(REPO, "chapters")
    os.makedirs(chdir, exist_ok=True)

    for i, (slug, title, secid) in enumerate(CHAPTERS):
        body = src[idx[i]:idx[i + 1]]
        meta, tex = preprocess(body, i + 1)
        pre = os.path.join(WORK, slug + ".tex")
        open(pre, "w").write(
            "\\documentclass{report}\n"
            "\\usepackage{amsmath,amssymb,amsfonts,graphicx}\n"
            "\\begin{document}\n" + tex + "\n\\end{document}\n")
        md = subprocess.run(
            ["pandoc", "-f", "latex", "-t", "markdown+tex_math_dollars-raw_tex",
             "--wrap=none", pre],
            capture_output=True, text=True, check=True).stdout
        md = postprocess(md, meta, slug, secid)

        head = "# %s {#%s}\n\n" % (title, secid)
        if meta.get("epigraph"):
            head += "::: {.epigraph}\n%s\n\n[— %s]{.epigraph-by}\n:::\n\n" % (
                meta["epigraph"], meta["epigraph_by"])
        open(os.path.join(chdir, slug + ".qmd"), "w").write(head + md)
        print("%-38s %5d lines  %2d environments" % (slug + ".qmd", md.count("\n"), len(meta["envs"])))


if __name__ == "__main__":
    main()
