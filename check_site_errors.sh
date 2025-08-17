#!/bin/bash

echo "=== ПРОВЕРКА ПРОТИВОРЕЧИЙ И ОШИБОК НА САЙТЕ ==="
echo ""

# 1. Проверяем даты
echo "1. ПРОВЕРКА ДАТ И ПЕРИОДОВ:"
echo "------------------------"
echo "Поиск 2024-2025:"
grep -r "2024" *.html | grep -v "2024 VivaEuropa" | head -10

echo ""
echo "Поиск 2020-2025:"
grep -r "2020" *.html | head -10

# 2. Проверяем статистику
echo ""
echo "2. ПРОВЕРКА СТАТИСТИКИ:"
echo "------------------------"
grep -r "Статистика основана" *.html
grep -r "Statistics based" *.html

# 3. Проверяем проценты
echo ""
echo "3. ПРОВЕРКА ПРОЦЕНТОВ:"
echo "------------------------"
grep -r "100%" *.html | head -20

# 4. Проверяем противоречивые фразы
echo ""
echo "4. ПРОВЕРКА ПРОТИВОРЕЧИВЫХ ФРАЗ:"
echo "------------------------"
echo "Испания vs Европа:"
grep -r "путь в Испанию" *.html
grep -r "path to Spain" *.html

# 5. Проверяем незаконченные предложения
echo ""
echo "5. ПРОВЕРКА НЕЗАКОНЧЕННЫХ ПРЕДЛОЖЕНИЙ:"
echo "------------------------"
grep -r "\. \." *.html
grep -r ", ," *.html
grep -r "и другими вопросами адаптации\." *.html
grep -r "and other post-approval matters\." *.html

# 6. Проверяем форматирование зарплат
echo ""
echo "6. ПРОВЕРКА ФОРМАТИРОВАНИЯ ЗАРПЛАТ:"
echo "------------------------"
grep -r "€[0-9]" *.html | grep -v "€[0-9][0-9][0-9]" | head -10
grep -r "[0-9] €" *.html | head -10

# 7. Проверяем дубли атрибутов
echo ""
echo "7. ПРОВЕРКА ДУБЛЕЙ АТРИБУТОВ:"
echo "------------------------"
grep -r 'target="_blank".*target="_blank"' *.html
grep -r 'rel="noopener".*rel="noopener"' *.html

# 8. Проверяем сломанные ссылки
echo ""
echo "8. ПРОВЕРКА СЛОМАННЫХ EMAIL ССЫЛОК:"
echo "------------------------"
grep -r 'mailto:.*href=' *.html
grep -r 'mailto:.*"body=' *.html

echo ""
echo "=== КОНЕЦ ПРОВЕРКИ ==="
