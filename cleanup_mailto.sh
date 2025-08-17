#!/bin/bash

echo "Убираем все дублированные mailto..."

for file in *.html; do
    # Убираем все дубли mailto: оставляя только первый
    perl -i -pe 's|(mailto:vivaeuropa.sup@gmail.com\?[^"]*?)mailto:vivaeuropa.sup@gmail.com[^"]*|$1|g' "$file"
done

echo "Проверка результата..."
grep -c "mailto:.*mailto:" *.html | grep -v ":0$"
