#!/bin/bash

echo "Агрессивная очистка mailto..."

for file in *.html; do
    # Убираем ВСЕ после первого mailto до закрывающей кавычки и заменяем на правильную ссылку
    perl -i -pe 's|href="mailto:vivaeuropa[^"]*"|href="mailto:vivaeuropa.sup@gmail.com?subject=Запрос%20по%20ВНЖ%20Испании\&body=Имя:%0AСпособ%20связи:%0AГород/страна:%0AКороткое%20описание:%0A"|g' "$file"
done

# Для английских страниц
for file in *_en.html; do
    perl -i -pe 's|subject=Запрос%20по%20ВНЖ%20Испании\&body=Имя:%0AСпособ%20связи:%0AГород/страна:%0AКороткое%20описание:%0A|subject=Residence%20permit%20inquiry\&body=Name:%0AContact%20method:%0ACity/Country:%0ABrief%20description:%0A|g' "$file"
done

echo "Финальная проверка..."
grep -c "mailto:.*mailto:" *.html | grep -v ":0$"
