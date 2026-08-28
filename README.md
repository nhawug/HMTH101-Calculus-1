# HMTH101 Calculus 1 - Study Notes

![Course](https://img.shields.io/badge/Course-HMTH101-blue)
![LaTeX](https://img.shields.io/badge/Typeset_in-LaTeX-008080?logo=latex)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)

Welcome to my repository for **HMTH101 Calculus of Single Variables**! 

This repository contains my digitized study notes based on the lectures by G. NHAWU at the University of Zimbabwe. I have typeset these notes in LaTeX for clean mathematical formatting and compiled them into easy-to-read PDFs.

## 🌐 Read them online

The notes are also published as a website, built with [Quarto](https://quarto.org) from the same LaTeX source as the PDFs. The mathematics is rendered live by MathJax, so it reflows on a phone and can be copied; definitions and theorems are numbered and linkable.

Author: **G. Nhawu**. Web edition: **Donald Zvadah** (contributor).

To build and read it locally:

```
python3 tools/tex2qmd.py   # regenerate chapters/ from HMTH101notes.tex
quarto preview             # or: quarto render
```

`tools/tex2qmd.py` needs `pandoc`; the render needs `quarto`. Only `chapters/` is generated — `index.qmd`, `appendix/` and `style.css` are written by hand. To publish: `quarto publish quarto-pub`.

## 📕 Complete Course PDF

If you prefer to download the entire course in a single document, you can grab the full compiled PDF here:

*   **[Download the Complete HMTH101 Notes](./HMTH101_Calculus_1_Full_Notes/HMTH101notes.pdf)**

## 📖 Table of Contents

Below are the direct links to the compiled PDFs and LaTeX source code for each chapter. 

*   **[Chapter 1: The Basics](./Chapter_1_The-Basics/Chapter1.pdf)**
    *   Includes Number Systems, Intervals, Solving Inequalities, The Absolute Value, and The Principle of Mathematical Induction.
*   **[Chapter 2: Functions](./Chapter_2_Functions/Chapter2.pdf)** 
    *   Includes Elementary Functions, Bounded Functions, and Operations on Functions.
*   **[Chapter 3: Sequences](./Chapter_3_Sequences/Chapter3.pdf)** 
    *   Includes Limits of Sequences, Squeeze Theorem, and Monotonic Sequences.
*   **[Chapter 4: Limits and Continuity](./Chapter_4_Limits_and_Continuity/Chapter4.pdf)**
    *  Includes Limits of a function, Theorems on Limits, Limits at Infinity, Continuity and Theorems on Continuity.
*   **[Chapter 5: Differentiation](./Chapter_5_Differentiation/Chapter5.pdf)**
    *  Includes Differentiation Techniques, The Chain Rule, High Order Derivatives, Logarithmic Differentiation and Implicit Differentiation.
*   **[Chapter 6: Applications of the Derivative](./Chapter_6_Applications_of_the_Derivative/Chapter6.pdf)**
     * Includes Approximations by Differentials, The Mean Value Theorem, Indeterminate Forms, Extrema of Functions and Graphing and the First Derivative.
*   **[Chapter 7: Integration](./Chapter_7_Integration/Chapter7.pdf)**
    * Includes Anti-Derivatives, Indenfinite Integrals, Area Under a Graph, Riemann Sums, The Fundamental Theorem of Calculus and Techniques of Integration.
      
    ## 📝 Past Exam Papers

Practice makes perfect! I have included previous years' exam papers to help with revision and exam preparation. 

* **[2013 Final Exam Question Paper](./Past_Exams/decem2013.pdf)**
* **[2017 Final Exam Question Paper](./Past_Exams/wintCalculus17.pdf)**

* **Next Course:** Finished with Calculus 1? Check out my notes for [HMTHCS111 Calculus 2: Calculus of Several Variables](https://github.com/nhawug/HMTHCS111-Calculus-2).

## 🛠️ How to Use This Repository

*   **To read the notes:** Simply click on the chapter links above and open the `.pdf` files directly in your browser.
*   **To view the code:** You can view the `.tex` files to see how I formatted the equations.
  

### LaTeX Example
Calculus requires heavy mathematical notation, which is why these notes are built in LaTeX. For example, the formal definition of a derivative is formatted as:
$$f^{\prime}(x_{0}) =\displaystyle \lim_{h \to 0}\frac{f(x_{0}+h)-f(x_{0})}{h}$$

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.

*Note: This is a personal study portfolio and is not an official university publication.*
