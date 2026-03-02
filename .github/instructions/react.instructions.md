---
description: "React 18 with TypeScript and Vite conventions for the frontend application"
applyTo: 'frontend/**'
---

# React Conventions

This document defines the React 18 with TypeScript and Vite conventions for the frontend application.

## Conventions

| Area | Convention |
|------|-----------|
| Framework | React 18 + TypeScript strict mode |
| Build tool | Vite with `server.port: 3000` |
| Components | Functional components with hooks only |
| i18n | i18next with `en.json`/`fr.json`, `react-i18next`, `i18next-browser-languagedetector` |
| Design system | Ontario Design System CSS classes (`@ongov/ontario-design-system-global-styles`) |
| Accessibility | WCAG 2.2 Level AA |
| Routing | `react-router-dom` v6 |
| HTTP client | axios with centralized API client |
| Exports | Named exports (not default) |
| `lang` attribute | Set dynamically on `<html>` based on selected language |

## Ontario Design System CSS Classes

| Component | CSS Class |
|-----------|----------|
| Page container | `ontario-page__container` |
| Header | `ontario-header` |
| Footer | `ontario-footer` |
| Primary button | `ontario-button ontario-button--primary` |
| Secondary button | `ontario-button ontario-button--secondary` |
| Form input | `ontario-input` |
| Form label | `ontario-label` |
| Form group | `ontario-form-group` |
| Select dropdown | `ontario-select` |
| Textarea | `ontario-textarea` |
| Error message | `ontario-input__error` |
| Alert (info) | `ontario-alert ontario-alert--informational` |
| Alert (error) | `ontario-alert ontario-alert--error` |
| Alert (success) | `ontario-alert ontario-alert--success` |
| Table | `ontario-table` |

## i18next Configuration

```typescript
import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';
import LanguageDetector from 'i18next-browser-languagedetector';
import en from './locales/en.json';
import fr from './locales/fr.json';

i18n
  .use(LanguageDetector)
  .use(initReactI18next)
  .init({
    resources: {
      en: { translation: en },
      fr: { translation: fr }
    },
    fallbackLng: 'en',
    supportedLngs: ['en', 'fr'],
    interpolation: { escapeValue: false }
  });

export { i18n };
```

### Using Translations in Components

```typescript
import { useTranslation } from 'react-i18next';

export const ProgramList = () => {
  const { t } = useTranslation();
  
  return (
    <h1>{t('programs.title')}</h1>
  );
};
```

### Setting Language Dynamically

```typescript
import { useEffect } from 'react';
import { useTranslation } from 'react-i18next';

export const LanguageSwitcher = () => {
  const { i18n } = useTranslation();
  
  useEffect(() => {
    document.documentElement.lang = i18n.language;
  }, [i18n.language]);
  
  const toggleLanguage = () => {
    const newLang = i18n.language === 'en' ? 'fr' : 'en';
    i18n.changeLanguage(newLang);
  };
  
  return (
    <button onClick={toggleLanguage} className="ontario-button ontario-button--secondary">
      {i18n.language === 'en' ? 'Français' : 'English'}
    </button>
  );
};
```

## WCAG 2.2 Level AA Key Criteria

| Criterion | ID | Requirement |
|-----------|----|-------------|
| Non-text Content | 1.1.1 | All images have alt text |
| Info and Relationships | 1.3.1 | Form fields linked to labels with `htmlFor`/`id` |
| Contrast (Minimum) | 1.4.3 | 4.5:1 for normal text, 3:1 for large text |
| Keyboard | 2.1.1 | All functionality operable via keyboard |
| Focus Visible | 2.4.7 | Keyboard focus indicator visible |
| Focus Not Obscured | 2.4.11 | Focused element not hidden (new in 2.2) |
| Language of Page | 3.1.1 | `lang` attribute on `<html>` |
| Error Identification | 3.3.1 | Errors described in text (not just color) |

## Vite Configuration with API Proxy

```typescript
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  server: {
    port: 3000,
    proxy: {
      '/api': { target: 'http://localhost:8080', changeOrigin: true }
    }
  }
});
```

## Named Exports Pattern

**Correct:**

```typescript
// ProgramList.tsx
export const ProgramList = () => { ... };

// index.ts (barrel file)
export { ProgramList } from './ProgramList';
```

**Incorrect (avoid default exports):**

```typescript
// Avoid this pattern
export default function ProgramList() { ... }
```

## Pitfalls

### Hardcoded Strings Break i18next

**Incorrect:**

```typescript
<h1>Program List</h1>
<button>Submit</button>
```

**Correct:**

```typescript
<h1>{t('programs.title')}</h1>
<button>{t('common.submit')}</button>
```

Hardcoding English strings bypasses i18next and breaks French language support.

### div with onClick Breaks Keyboard Accessibility

**Incorrect:**

```typescript
<div onClick={handleClick} className="clickable-card">
  Click me
</div>
```

**Correct:**

```typescript
<button onClick={handleClick} className="ontario-button ontario-button--primary">
  Click me
</button>
```

Using `div` with `onClick` breaks keyboard accessibility (users cannot tab to or activate with Enter/Space).

### Ontario DS CSS Loading Order

Ontario Design System CSS may conflict with other CSS resets. Always load it **before** your application styles:

```typescript
// main.tsx - correct order
import '@ongov/ontario-design-system-global-styles/dist/styles/css/compiled/ontario-theme.min.css';
import './App.css'; // App styles after Ontario DS
```
