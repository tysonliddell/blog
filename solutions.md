---
title: Solutions
---

*A collection of solutions to various exercises/problems.*

{%
  assign solutions_collections = site.collections
  | where: 'is_solution_collection', true
%}
{% for collection in solutions_collections %}
{% assign collection_url = '/' | append: collection.label | relative_url %}
[{{collection.source}}]({{collection_url}}) by {{collection.source_author}}
{% endfor %}
