#!/bin/bash

echo "=== ФИНАЛЬНАЯ ПРОВЕРКА САЙТА ==="
echo ""

echo "1. Email ссылки:"
echo "------------------------"
BROKEN_EMAILS=$(grep -c "mailto:.*mailto:" *.html | grep -v ":0$" | wc -l)
echo "Сломанных email ссылок: $BROKEN_EMAILS"

echo ""
echo "2. Дублированные атрибуты:"
echo "------------------------"
DUPL_ATTRS=$(grep -c 'target="_blank".*target="_blank"' *.html | grep -v ":0$" | wc -l)
echo "Дублированных атрибутов: $DUPL_ATTRS"

echo ""
echo "3. Статистика на страницах О нас:"
echo "------------------------"
grep -c "Статистика основана" about_*.html

echo ""
echo "4. Даты в статистике:"
echo "------------------------"
echo "2020-2025:"
grep -c "2020–2025\|2020-2025" index_*.html
echo "2024-2025 (должно быть 0):"
grep -c "2024–2025\|2024-2025" *.html | grep -v ":0$" | wc -l

echo ""
echo "5. Путь в Европу:"
echo "------------------------"
echo "Правильно (Европа):"
grep -c "путь в Европу\|path to Europe" index_*.html
echo "Неправильно (Испания):"
grep -c "путь в Испанию\|path to Spain" index_*.html

echo ""
echo "6. Форматирование цен:"
echo "------------------------"
grep "Средняя зарплата" cities_ru.html | head -1

echo ""
echo "=== РЕЗУЛЬТАТ: ==="
if [ $BROKEN_EMAILS -eq 0 ] && [ $DUPL_ATTRS -eq 0 ]; then
    echo "✅ ВСЕ ОСНОВНЫЕ ОШИБКИ ИСПРАВЛЕНЫ!"
else
    echo "⚠️  Еще есть проблемы"
fi
