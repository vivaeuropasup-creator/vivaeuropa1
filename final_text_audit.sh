#!/bin/bash

echo "=== ФИНАЛЬНАЯ ПРОВЕРКА ВСЕГО ТЕКСТА ==="
echo ""

# 1. Проверяем орфографические ошибки и опечатки
echo "1. ВОЗМОЖНЫЕ ОПЕЧАТКИ:"
echo "------------------------"
grep -rn "получние\|адптация\|адаптцаия\|получени\|помщь\|поддрежка" *.html

# 2. Проверяем неправильные окончания
echo ""
echo "2. НЕПРАВИЛЬНЫЕ ОКОНЧАНИЯ:"
echo "------------------------"
grep -rn "получение.*адаптация\|получение.*поддержка" *.html | grep -v "помощь\|с "

# 3. Проверяем лишние пробелы и знаки
echo ""
echo "3. ЛИШНИЕ ПРОБЕЛЫ И ЗНАКИ:"
echo "------------------------"
grep -rn "  \|,\.\|\. ,\|,,\|;;" *.html | head -10

# 4. Проверяем неправильную пунктуацию
echo ""
echo "4. НЕПРАВИЛЬНАЯ ПУНКТУАЦИЯ:"
echo "------------------------"
grep -rn "\.,\|\.\.\|\?\.\|\!\." *.html

# 5. Проверяем английские ошибки
echo ""
echo "5. АНГЛИЙСКИЕ ОШИБКИ:"
echo "------------------------"
grep -rn "recieve\|seperate\|occured\|teh \|adn \|taht " *.html

# 6. Проверяем смешение языков
echo ""
echo "6. СМЕШЕНИЕ ЯЗЫКОВ:"
echo "------------------------"
# Ищем русские слова в английских файлах и наоборот
for file in *_en.html; do
    if grep -q "[а-яё]" "$file"; then
        echo "Русские буквы в $file:"
        grep -n "[а-яё]" "$file" | head -3
    fi
done

for file in *_ru.html; do
    if grep -q -E "\b[A-Za-z]{3,}\b" "$file" | grep -v -E "(HTML|CSS|JavaScript|email|target|class|href|src|alt|width|height|loading|viewBox|xmlns|aria-hidden|rel|lang|charset|viewport|content|property|hreflang|preload|WhatsApp|Telegram|Email|Send|Message)"; then
        echo "Английские слова в $file (кроме технических):"
        grep -n -E "\b[A-Za-z]{3,}\b" "$file" | grep -v -E "(HTML|CSS|JavaScript|email|target|class|href|src|alt|width|height|loading|viewBox|xmlns|aria-hidden|rel|lang|charset|viewport|content|property|hreflang|preload|WhatsApp|Telegram|Email|Send|Message)" | head -3
    fi
done

echo ""
echo "7. ПРОВЕРКА КОНКРЕТНЫХ ПРОБЛЕМНЫХ ФРАЗ:"
echo "------------------------"
grep -rn "получение.*и.*[а-я]*ей\|получение.*и.*[а-я]*ом\|получение.*и.*[а-я]*ами" *.html

echo ""
echo "=== РЕЗУЛЬТАТ ПРОВЕРКИ ==="
