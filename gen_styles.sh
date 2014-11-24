#!/bin/bash
types=("default" "monokai" "solarized" "solarized256")
for style in "${types[@]}"; do
    echo "Generating style for $style"
    #pygmentize -S $style -f html -a ".$style .code" > ./css/pygments/$style.css
    python -c "from pygments.formatters.html import HtmlFormatter;print HtmlFormatter(style=\"$style\").get_style_defs([\".$style .code\", \".$style .highlight\"])" > ./css/pygments/$style.css
done
all=${types[@]}
sed -i "1s/.*/TYPES = \"$all\"/" ./coffee/main.coffee
