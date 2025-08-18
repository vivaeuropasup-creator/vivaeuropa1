// VivaEuropa - CTA & Lead Management
// Конфигурация с актуальными данными
const WA_URL = "https://wa.me/79291735720?text=Здравствуйте,%20хочу%20получить%20ВНЖ%20в%20Испании";
const TG_URL = "https://t.me/vivaeurop";
const MAILTO_URL = "mailto:vivaeuropa.sup@gmail.com?subject=Запрос%20по%20ВНЖ%20Испании&body=Имя:%0AСпособ%20связи:%0AГород/страна:%0AКратко%20суть:%0A";
const GOOGLE_SHEETS_WEBHOOK_URL = 'https://script.google.com/macros/s/.../exec?key=SECRET';
const LEGAL_NOTE_RU = 'Статистика основана на реальных обращениях 2024–2025. Решение принимает орган по делам иностранцев Испании.';
const LEGAL_NOTE_EN = 'Statistics based on actual cases in 2024–2025. The final decision is made by the Spanish immigration authority.';

// Функция для получения UTM параметров из URL
function getUTMParams() {
    const urlParams = new URLSearchParams(window.location.search);
    return {
        utm_source: urlParams.get('utm_source') || 'direct',
        utm_medium: urlParams.get('utm_medium') || 'none',
        utm_campaign: urlParams.get('utm_campaign') || 'none',
        utm_content: urlParams.get('utm_content') || 'none',
        utm_term: urlParams.get('utm_term') || 'none'
    };
}

// Функция для определения текущего языка страницы
function getCurrentLanguage() {
    const html = document.documentElement;
    return html.lang || 'ru';
}

// Функция для получения названия текущей страницы
function getCurrentPage() {
    const path = window.location.pathname;
    const filename = path.split('/').pop() || 'index.html';
    return filename.replace('.html', '');
}

// Основная функция отправки лида
async function sendLead(cta, locale = null) {
    try {
        // Определяем язык
        const language = locale || getCurrentLanguage();
        
        // Собираем данные
        const utmParams = getUTMParams();
        const currentPage = getCurrentPage();
        const timestamp = new Date().toISOString();
        
        const payload = {
            timestamp: timestamp,
            cta: cta,
            page: currentPage,
            language: language,
            utm_source: utmParams.utm_source,
            utm_medium: utmParams.utm_medium,
            utm_campaign: utmParams.utm_campaign,
            utm_content: utmParams.utm_content,
            utm_term: utmParams.utm_term,
            user_agent: navigator.userAgent,
            referrer: document.referrer || 'direct'
        };

        // Отправляем данные через sendBeacon (приоритетный метод)
        if (navigator.sendBeacon && GOOGLE_SHEETS_WEBHOOK_URL !== 'https://script.google.com/macros/s/.../exec?key=SECRET') {
            const blob = new Blob([JSON.stringify(payload)], { type: 'text/plain' });
            navigator.sendBeacon(GOOGLE_SHEETS_WEBHOOK_URL, blob);
        } else if (GOOGLE_SHEETS_WEBHOOK_URL !== 'https://script.google.com/macros/s/.../exec?key=SECRET') {
            // Fallback к fetch
            try {
                await fetch(GOOGLE_SHEETS_WEBHOOK_URL, {
                    method: 'POST',
                    mode: 'no-cors',
                    headers: {
                        'Content-Type': 'text/plain'
                    },
                    body: JSON.stringify(payload)
                });
            } catch (error) {
                console.warn('Failed to send lead data:', error);
            }
        }
        
        console.log('Lead sent:', payload);
        return true;
    } catch (error) {
        console.error('Error sending lead:', error);
        return false;
    }
}

// ПРАВИЛЬНЫЙ обработчик кликов без preventDefault - только аналитика
function initializeCTAButtons() {
    document.addEventListener('click', (e) => {
        const a = e.target.closest('a[data-cta], .contact-actions a, .btn-wa, .btn-tg, .btn-mail, .cta-btn');
        if (!a) return;
        
        try {
            // Определяем тип CTA
            let ctaType = a.dataset.cta;
            if (!ctaType) {
                if (a.classList.contains('whatsapp') || a.href.includes('wa.me')) ctaType = 'whatsapp';
                else if (a.classList.contains('telegram') || a.href.includes('t.me')) ctaType = 'telegram';
                else if (a.classList.contains('email') || a.href.includes('mailto:')) ctaType = 'email';
            }
            
            // Отправляем аналитику
            const payload = {
                event: 'cta',
                cta: ctaType || a.className,
                href: a.href,
                ts: Date.now()
            };
            
            if (navigator.sendBeacon) {
                navigator.sendBeacon('/lead', new Blob([JSON.stringify(payload)], {type: 'application/json'}));
            }
            
            // Отправляем через нашу систему аналитики
            sendLead(ctaType || 'unknown_cta');
            
        } catch(_) {}
        
        // НЕ вызываем preventDefault, НЕ подменяем URL — браузер сам перейдёт по a.href
    }, true);
}

// Функция для отслеживания скроллинга (опциональная аналитика)
function trackScrollDepth() {
    let maxScroll = 0;
    let scrollTimer = null;
    
    window.addEventListener('scroll', () => {
        const scrollPercent = Math.round((window.scrollY / (document.body.scrollHeight - window.innerHeight)) * 100);
        
        if (scrollPercent > maxScroll) {
            maxScroll = scrollPercent;
            
            // Отправляем событие скролла с задержкой
            clearTimeout(scrollTimer);
            scrollTimer = setTimeout(() => {
                if (maxScroll >= 25 && maxScroll % 25 === 0) {
                    sendLead(`scroll_${maxScroll}%`);
                }
            }, 1000);
        }
    });
}

// Функция для инициализации мобильного меню
function initializeMobileMenu() {
    const mobileMenuToggle = document.querySelector('.mobile-menu-toggle');
    const navMenu = document.querySelector('.nav-menu');
    
    if (mobileMenuToggle && navMenu) {
        mobileMenuToggle.addEventListener('click', () => {
            navMenu.classList.toggle('active');
            mobileMenuToggle.classList.toggle('active');
        });
        
        // Закрытие меню при клике на ссылку
        const navLinks = navMenu.querySelectorAll('.nav-link');
        navLinks.forEach(link => {
            link.addEventListener('click', () => {
                navMenu.classList.remove('active');
                mobileMenuToggle.classList.remove('active');
            });
        });
    }
}

// Функция для плавного скроллинга к якорям
function initializeSmoothScroll() {
    const anchorLinks = document.querySelectorAll('a[href^="#"]');
    
    anchorLinks.forEach(link => {
        link.addEventListener('click', (e) => {
            const href = link.getAttribute('href');
            if (href === '#') return;
            
            const target = document.querySelector(href);
            if (target) {
                e.preventDefault();
                const headerHeight = document.querySelector('.header')?.offsetHeight || 80;
                const targetPosition = target.offsetTop - headerHeight;
                
                window.scrollTo({
                    top: targetPosition,
                    behavior: 'smooth'
                });
            }
        });
    });
}

// Инициализация при загрузке страницы
document.addEventListener('DOMContentLoaded', () => {
    console.log('VivaEuropa app initialized');
    
    // Инициализируем все функции
    initializeCTAButtons();
    initializeMobileMenu();
    initializeSmoothScroll();
    
    // Опционально включаем отслеживание скролла
    // trackScrollDepth();

    // Reveal on scroll animations
    try {
        const observer = new IntersectionObserver((entries) => {
            entries.forEach((entry) => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('reveal-visible');
                    observer.unobserve(entry.target);
                }
            });
        }, { rootMargin: '0px 0px -10% 0px', threshold: 0.1 });

        document.querySelectorAll('.section, .card, .pricing-card').forEach((el) => {
            el.classList.add('reveal');
            observer.observe(el);
        });
    } catch (_) {}
    
    // Отправляем событие просмотра страницы
    setTimeout(() => {
        sendLead('page_view');
    }, 1000);
});

// Email copy to clipboard functionality
document.addEventListener('click', function(e) {
    const el = e.target.closest('.cta-email');
    if (!el) return;
    
    const value = el.getAttribute('data-copy') || 'vivaeuropa.sup@gmail.com';
    
    if (navigator.clipboard && navigator.clipboard.writeText) {
        navigator.clipboard.writeText(value).then(() => {
            const originalHTML = el.innerHTML;
            el.innerHTML = `<svg class="icon" viewBox="0 0 24 24"><path fill="currentColor" d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41L9 16.17z"/></svg>Скопировано!`;
            setTimeout(() => { 
                el.innerHTML = originalHTML;
            }, 1500);
        }).catch(err => {
            // Fallback for older browsers
            const textArea = document.createElement('textarea');
            textArea.value = value;
            document.body.appendChild(textArea);
            textArea.select();
            document.execCommand('copy');
            document.body.removeChild(textArea);
            
            const originalHTML = el.innerHTML;
            el.innerHTML = `<svg class="icon" viewBox="0 0 24 24"><path fill="currentColor" d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41L9 16.17z"/></svg>Скопировано!`;
            setTimeout(() => { el.innerHTML = originalHTML; }, 1500);
        });
    }
});

// Экспорт функций для использования в HTML
window.VivaEuropa = {
    sendLead,
    getUTMParams,
    getCurrentLanguage,
    getCurrentPage,
    WA_URL,
    TG_URL,
    MAILTO_URL
};