---
layout: post
author: tyson
title: "On the CDF of a linear function of a random variable"

tags: mathematics probability

usemathjax: true
---

## A linear function of a random variable is a random variable

Let $$X$$ be a random variable on $$(\Om, \mathcal{F}, \prob)$$. Then for $$a,b
\in \R$$, the function $$Y := aX + b$$ is a random variable. Indeed, if $$a >
0$$ then for any $$x \in \R$$ we have

$$
\{ Y \leq x \}
= \{ aX + b \leq x \}
= \{ \om \in \Om : aX(\om) + b \leq x \}
= \left\{ \om \in \Om : X(\om) \leq \frac{x-b}{a} \right\}.
$$

When $$a < 0$$ we have

$$
\begin{align*}
\{ Y \leq x \}
&= \left\{ \om \in \Om : X(\om) \geq \frac{x-b}{a} \right\} \\
&= \left\{ \om \in \Om : X(\om) \lt \frac{x-b}{a} \right\}^C \\
&= \left(\bigcup_{i\in\N} \left\{
    \om \in \Om : X(\om) \leq \frac{x-b}{a} - \frac{1}{n}
  \right\}\right)^C.
\end{align*}
$$

Finally, when $$a = 0$$

$$
\{ Y \leq x \}
= \left\{ \om \in \Om : b \leq x \right\}
\in \{ \Om, \emptyset \}.
$$

In all of the cases above, $$\{ Y \leq x \} \in \mathcal{F}$$, making $$Y$$ a
random variable.

## The CDF of $$Y$$ is inherited from $$X$$
If $$a > 0$$, then

$$
\begin{align*}
F_Y(y)
&= \prob(Y \leq y) \\
&= \prob\left(\left\{ \om \in \Om : X(\om) \leq \frac{y-b}{a} \right\}\right) \\
&= F_X\left(\frac{y-b}{a}\right),
\end{align*}
$$

and when $$a < 0$$ we have

$$
\begin{align}
F_Y(y)
&= \prob(Y \leq y) \\
&= \prob\left(
\left(\bigcup_{i\in\N} \left\{
  \om \in \Om : X(\om) \leq \frac{y-b}{a} - \frac{1}{n}
  \right\}\right)^C\right) \\
&= 1 - \prob\left(\bigcup_{i\in\N} \left\{
  \om \in \Om : X(\om) \leq \frac{y-b}{a} - \frac{1}{n}
  \right\}\right) \\
&= 1 - \lim_{n\to\infty} \prob\left( \left\{
  \om \in \Om : X(\om) \leq \frac{y-b}{a} - \frac{1}{n}
  \right\}\right) \tag{1}\label{continuity} \\
&= 1 - \lim_{n\to\infty} F_X\left(\frac{y-b}{a} - \frac{1}{n}\right)\\
&= 1 - \lim_{x \uparrow \frac{y-b}{a}} F_X(x).  \tag{2}\label{limit_exists}
\end{align}
$$

At $$(\ref{continuity})$$ we used the continuity property of $$\prob$$ and at
$$(\ref{limit_exists})$$ the fact that $$F_X$$ is monotonic implies that its
left and right sided limits exist at every point. Note that in the special case
where $$F_X$$ is continuous, the above simplifies to $$F_Y(y) = 1 -
F_X\left(\frac{y-b}{a}\right)$$.

Since $$Y$$ is a CDF, it must be right continuous. This is a
direct consequence of the continuity property of $$\prob$$:

$$
\lim_{h \to 0^{+}} F_Y(y + h)
= \lim_{h \to 0^{+}} \prob({Y \leq y + h})
= \lim_{n \to \infty} \prob({Y \leq y + 1/n})
= \prob({Y \leq y})
= F_Y(y),
$$

since $$\{Y \leq y + 1/n\}$$ is a decreasing sequence of events whose
intersection is equal to $$\{ Y \leq y\}$$. Even with this result, I didn't find
it obvious that the expression at $$(\ref{limit_exists})$$ should be right
continuous. However, recalling that $$a < 0$$, the continuity property of
$$\prob$$ implies that,

$$
\begin{align*}
\lim_{h \to 0^{+}} F_Y(y + h)
&= \lim_{h \to 0^{+}} \left[
    1 - \lim_{g \to 0^{-}} F_X\left(\frac{y + h - b}{a} + g\right)
    \right] \\
&= 1 - \lim_{h \to 0^{+}}
    \lim_{g \to 0^{-}} \prob\left(
      \left\{X \leq \frac{y + h - b}{a} + g\right\}
    \right) \\
&= 1 - \lim_{h \to 0^{+}}
    \prob\left(\left\{X \lt \frac{y + h - b}{a}\right\}\right) \\
&= 1 - \lim_{h \to 0^{-}}
    \prob\left(\left\{X \lt \frac{y - b}{a} + \frac{h}{|a|}\right\}\right) \\
&= 1 - \lim_{h \to 0^{-}}
    \prob\left(\left\{X \leq \frac{y - b}{a} + h\right\}\right) \\
&= 1 - \lim_{h \to 0^{-}}F_X\left(\frac{y - b}{a} + h\right) \\
&= F_Y(y)
\end{align*}
$$

which confirms, explicitly, that $$(\ref{limit_exists})$$ is right continuous.

## The left and right limits of a CDF and continuity
The choice of inequality in the definition $$F_X(x) = \prob(X \leq x)$$
determines the left/right continuity of cumulative distribution functions.
Indeed, if we define $$\widehat{F}_X(x) = \prob(X \lt x)$$, the continuity
property of $$\prob$$ guarantees that the left and right limits satisfy

$$
\lim_{y \to x^{-}}F_X(y)
= \prob(\{X < x\})
= \lim_{y \to x^{-}}\widehat{F}_X(y)
\quad\text{and}\quad
\lim_{y \to x^{+}}F_X(y)
= \prob(\{X \leq x\})
= \lim_{y \to x^{+}}\widehat{F}_X(y)
$$

Therefore, the fact that the CDF is left or right continuous is determined by
whether or not we choose to define it as $$F_X$$ or $$\widehat{F}_X$$. Since
$$F_X$$ was chosen, it is right continuous.
