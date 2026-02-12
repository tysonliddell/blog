TEMPLATE=./templates/template
MD_TO_HTML=../../md-to-html/md-to-html

# Grab title and strip "# " prefix.
title=$(cat $1 | grep -o '^# .*$' | head -n1)
title=${title#\# }

cat $TEMPLATE | sed "s/{{ title }}/$title/" | awk "/{{ content }}/ {system(\"cat $1 | $MD_TO_HTML\") ;next} {print}"
