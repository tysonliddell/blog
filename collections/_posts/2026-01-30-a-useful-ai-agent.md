---
layout: post
author: tyson
title: "Creating a useful AI agent"

tags: AI
---

## Some problems with AI agent use
AI agents are making developers dumber. Two big reasons for this are 1. skill
atrophy and 2. too much hand holding.

1. Developers are moving further away from their tools and writing code. Soon
few devs will know how to work on the command line, write a quick bash/python
script or build their own project. The AI will do it all for them. This is not
good. Devs are going to lose their skills and how to think techically. If you
don't use it you lose it.

2. AI hand holding leads to developers not thinking deeply enough about the
codebase or the problem that they are solving. Speed is not necessarily better.
More LoC is not a good measure of productivity, as I'm sure we'll see in the
coming years. To be a strong developer you need to be able to think about
problems yourself rather than immediately giving in to the impulse to get a
quick answer from AI (or even stack overflow). Do this often enough and you
will never develop deep knowledge or self-sufficieny.

The GNU/Linux operating system is HUGELY powerful for developers that take the
time to learn how to wield it. We don't need a bunch of new tools. There is
already plenty of insanely productive tooling, much of it wwritten decades ago
by bright people.

## A useful AI agent
If an AI agent is to be of use for a developer who cares about their craft and
their intellect it should not be used to do everything for them or always be
there to "give them the answer". So what are the attributes of an AI agents
that will allow a developer to thrive technically over many years without their
brains being turned into mush?

### Agent requirements
The agent should following the following guidelines:
- Be a rubber duck. It's there to help me think through problems myself, not to
  give me immediate (and possibly incorrect/suboptimal) answers to all
  challenges I face.
- Do not be sycophant! It's ok to be adversarial at times. Challenge me and
  make me defend my own technical decisions. I expect that sometimes the agent
  and I just won't agree on things. That's a good thing! It shows that I can
  think for myself.
- Rather than giving me an answer, suggest authoritive sources where I can
  learn the answer on my own. Point me to docs.
- Encourage me to write code myself and think for myself.
- Understand that the overarching purpose of your existance (the agent) is to
  make me a stronger dev over many years. You don't do that by spoon feeding me
  solutions to everything.
- Understand that my technical skill atrophy is a big risk that I want you to
  make sure you do not compromise.
- I'm interested in low-level details of everything and love to learn. Provide
  the agent with examples of the kinds of projects I work on for hobbies, what
  my background is, what my interests are and where I want to get to.
- For any technical help you do provide you must provide all sources of the
  information.

### Getting started
I don't know much about working with AI agents yet, or how to put a good prompt
together to achieve the goals above. However, I might be able to bootstrap this
with an LLM. I could provide it with the context above and ask it to point me
in the right direction to make this a reality. Hopefully it can provide the
learning resources I need to write a good prompt, evaluate to effectiveness of
the agent (LLM-as-a-judge?) and possibly how best to implement some kind of
self-improvement process. For self-improvement, I'm thinking that we review all
previous transcripts between myself and the agent and have it determine if the
output is aligned with the overall goal. If it's not maybe it can suggest what
I need to learn to improve things.
