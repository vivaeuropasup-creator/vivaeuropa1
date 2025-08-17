#!/bin/bash

echo "Финальная очистка email ссылок..."

for file in *.html; do
    # Убираем все мусорные атрибуты после закрывающей кавычки href
    perl -i -pe 's|(" target="_blank" rel="noopener")\s*target="_blank" rel="noopener"[^>]*mailto:[^>]*|$1|g' "$file"
    
    # Убираем дублированные body параметры
    perl -i -pe 's|"body=[^>]*body=[^>]*\s+class=|" class=|g' "$file"
    
    # Убираем все после закрывающей кавычки перед class
    perl -i -pe 's|("\s+)(?:target="_blank" rel="noopener")*[^>]*mailto:[^>]*(\s*class="cta-btn email")|$1target="_blank" rel="noopener"$2|g' "$file"
done

echo "Результат:"
grep -c "mailto:.*mailto:" *.html | grep -v ":0$" | wc -l
