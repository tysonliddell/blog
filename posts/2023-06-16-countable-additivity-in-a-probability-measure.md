---
layout: post
author: tyson
title: "Why do probability functions need to be countably additive?"

tags: mathematics probability

usemathjax: true
---

The Kolmogorov axioms of probability include the requirement for countable
additivity. That is, for disjoint sets $$A_1, A_2, \ldots \subset \Om$$, the
probability function $$\prob$$ must satisfy $$\prob(\cup_iAi) =
\sum_i\prob(A_i)$$.  Recently, I've been wondering why the choice was made to
include this axiom.

Let's start with some motivation{% cite grimmett_parp %} for the probability
axioms. Given an experiment with a set of possible outcomes $$\Om$$, a
$$\sigma$$-algebra $$\mathcal{F}$$ on $$\Om$$, and some event $$A \in
\mathcal{F}$$, let $$N(A)$$ denote the number of times $$A$$ is observed to
occur in $$N$$ trials. We know from experience that, if we repeat the experiment
many times, $$N(A)/N$$ tends to some constant $$p$$ as $$N \to \infty$$, which
we can call the *probability* of $$A$$ occurring. For clarity, we will refer to
this idea as the *relative frequency property* of probability. Observe that $$0
\leq p \leq 1$$ and $$p$$ represents the relative frequency with which $$A$$ is
expected to occur when running the experiment over and over. Suppose we want to
define a probability function $$\prob:\mathcal{F} \to [0,1]$$ capturing the
relative frequency property. Most of the probability axioms fall out naturally:

- Axiom 1, $$\prob(\emptyset) = 0$$, follows from the fact that $$N(\emptyset)/N
  = 0/N = 0$$ for all $$N$$. It is impossible for the experiment to have no
  outcome.

- Axiom 2, $$\prob(\Om) = 1$$, follows from the fact that $$N(\Om)/N = N/N = 1$$
  for all $$N$$. Some outcome will always occur.

- We could state axiom 3 as: for disjoint events $$A,B \in \mathcal{F}$$, the
  probability function must satisfy $$\prob(A \cup B) = \prob(A) + \prob(B)$$.
  Indeed, since $$\prob$$ is meant to capture the relative frequency property
  for all events, we require

  $$
  \begin{align*}
  \prob(A \cup B)
  &= \lim_{N\to\infty} \frac{N(A \cup B)}{N} && \text{(relative frequency property)} \\
  &= \lim_{N\to\infty} \frac{N(A) + N(B)}{N} \\
  &= \lim_{N\to\infty}\frac{N(A)}{N} + \lim_{n\to\infty}\frac{N(B)}{N} \\
  &= \prob(A) + \prob(B). && \text{(relative frequency property)}
  \end{align*}
  $$

  It follows by induction that for $$A_1, \ldots, A_n \in \mathcal{F}$$
  disjoint, $$\prob(A_1 \cup \ldots \cup A_n) = \prob(A_1) + \ldots +
  \prob(A_n)$$.

Why should we go any further than these three axioms above? Countable
additivity would require that for any countable collection of disjoint events
$$A_1, A_2, \ldots \in \mathcal{F}$$, the probability function satisfies
$$\prob(\cup_{i}A_i) = \sum_i\prob(A_i)$$, and this requirement is included in
most frameworks of probability theory, starting with Kolmogorov. However, we
don't always need this property when trying to reason about probabilities
involving a countable union of disjoint events.

## Working without countable additivity
Proceeding with the axioms above (without countable additivity), consider the
experiment of continually flipping a fair coin until it yields heads. Letting
$$\omega_i$$ denote the outcome that the $$i$$th flip is a head, the set of all
possible outcomes is given by $$\Om = \{\om_1,\om_2,\ldots\}$$. For any odd
$$n$$, let $$O_n = \{\om_1, \om_3, \om_5 \ldots, \om_n\}$$ denote the event that
a head occurs in the first $$n$$ tosses. Since the coin is fair, $$\prob(O_n) =
1/2 + 1/8 + 1/32 + \ldots + 1/2^n$$. The probability of a head occurring in the
first $$n$$ tosses is

$$
\begin{align*}
\prob(O_n)
&= \prob(\{\om_1, \om_3, \om_5 \ldots, \om_n\}) \\
&= 1/2 + 1/8 + 1/32 + \ldots + 1/2^n \\
&= \frac{1}{2}\left(1 + 1/4 + 1/16 + \ldots + 1/2^{n-1}\right) \\
&= \frac{1}{2}\left(1 + \frac{1}{4} + \left(\frac{1}{4}\right)^2 + \ldots + \left(\frac{1}{4}\right)^{(n-1)/2}\right).
\end{align*}
$$

Let $$O$$ denote the event that an odd number of flips occur before revealing a
head. That is

$$
O
= \{\om_1, \om_3, \om_5, \ldots\}
= \bigcup_{\text{$i$ odd}}O_i
= \bigcup_{\text{$i$ odd}}\{\om_i\}.
$$

Since we can't use countable additivity and we don't know if $$\prob$$ is
continuous, we can't observe the geometric progression above and immediately
conclude that

$$\prob(O) = \frac{1}{2} \cdot \frac{1}{1-1/4} = \frac{2}{3}.$$

However, this solution can be arrived at with a different approach: squeezing
the set $$O$$ between two other sets and applying properties of sequences.
Indeed, since $$O_n \subset O$$ implies that

$$\prob(O) = \prob(O_n \cup (O \setminus O_n)) = \prob(O_n) + \prob(O \setminus
O_n) \geq \prob(O_n),$$

and $$\prob(O_n) \to 2/3$$ as $$n\to\infty$$, it follows that $$\prob(O) \geq
2/3$$. Now, for any even $$n$$, let $$\widehat{O}_n = \Om \setminus \{\om_2,
\om_4, \ldots, \om_n\}$$. Noting that $$O \subset \widehat{O}_n$$, similar logic
to above can be used to show that $$\prob(O) \leq \prob(\widehat{O}_n) \implies
\prob(O) \leq 2/3$$. Therefore, it follows that $$\prob(O) = 2/3$$.

## Why include countable additivity
This previous result falls out easier with the requirement for countable
additivity. With this property we can write
$$
\prob(O)
= \prob(\cup_{\text{$i$ odd}}\{\om_i\})
= \sum_{\text{$i$ odd}}\prob(\om_i)
= 1/2 + 1/8 + 1/32 + \ldots + 1/2^n \\
= 2/3
$$.
But I find it interesting that it's not necessary here. It turns out consensus
hasn't been reached amongst mathematicians and philosophers as to whether or not
countable additivity should be included in the probability axioms. See the links
below:

- https://hsm.stackexchange.com/questions/14198/why-did-borel-reject-countable-additivity-of-probability
- https://math.stackexchange.com/questions/564718/why-do-we-want-probabilities-to-be-countably-additive#comment1197370_564718
- https://joelvelasco.net/teaching/5311/easwaran14-whyCountable.pdf
- https://www.jstor.org/stable/40072238
- https://openlearninglibrary.mit.edu/courses/course-v1:MITx+24.118x+2T2020/courseware/b81fa7fa0e614b019f1302218309fa9d/c3c96a46545e413db2a606c4bb225347/?activate_block_id=block-v1%3AMITx%2B24.118x%2B2T2020%2Btype%40sequential%2Bblock%40c3c96a46545e413db2a606c4bb225347

It seems countable additivity is a useful property that allows us to prove
important results. As Kolmogorov himself said:

> "We limit ourselves arbitrarily to only those models that satisfy Axiom VI
[the axiom leading to countable additivity]. This limitation has been found
expedient in researches of most diverse sort".
