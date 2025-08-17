#!/bin/bash

echo "Финальная очистка email ссылок..."

# Исправляем все сломанные email ссылки с множественными mailto
for file in *.html; do
    # Заменяем сломанные ссылки на правильные
    sed -i '' 's|href="mailto:vivaeuropa.sup@gmail.com?subject=[^"]*"|href="mailto:vivaeuropa.sup@gmail.com?subject=Запрос%20по%20ВНЖ%20Испании\&body=Имя:%0AСпособ%20связи:%0AГород/страна:%0AКороткое%20описание:%0A" target="_blank" rel="noopener"|g' "$file"
    
    # Убираем лишние атрибуты после class
    sed -i '' 's|class="cta-btn email"[^>]*data-cta="email"|class="cta-btn email" data-cta="email"|g' "$file"
done

# Для английских страниц меняем subject и body
for file in *_en.html; do
    sed -i '' 's|subject=Запрос%20по%20ВНЖ%20Испании\&body=Имя:%0AСпособ%20связи:%0AГород/страна:%0AКороткое%20описание:%0A|subject=Residence%20permit%20inquiry\&body=Name:%0AContact%20method:%0ACity/Country:%0ABrief%20description:%0A|g' "$file"
done

echo "Проверка..."
grep -c "mailto:.*mailto:" *.html | grep -v ":0$" | wc -l
