# Example: Add a Feature

A complete walkthrough of using AI Pilot to add dark mode support, with actual prompts, code diffs, and multi-task delegation.

## Scenario

Add dark mode toggle to a Next.js + Tailwind CSS web application.

---

## Step 1: User Request

> _"Add dark mode toggle to the app — delegate to Claude Code"_

## Step 2: Pilot Analyzes

Antigravity researches the codebase:

```bash
$ grep -r "theme" src/ --include="*.tsx" --include="*.ts"
# No results — no existing theme system

$ cat package.json | grep -E "next|tailwind"
"next": "14.2.5",
"tailwindcss": "3.4.1"

$ ls src/components/
Header.tsx  Footer.tsx  Providers.tsx  Layout.tsx
```

Findings:
- **Framework**: Next.js 14 + Tailwind CSS 3.4
- **Current setup**: No theme system, hardcoded light colors
- **Existing components**: `Header.tsx`, `Providers.tsx` (good patterns to follow)
- **Approach**: Use `next-themes` library (standard for Next.js)

## Step 3: Pilot Creates Plan

```
Plan (3 tasks, ordered by dependency):
1. [Foundation] Install next-themes, create ThemeProvider
2. [UI] Add toggle button to Header
3. [Styling] Add dark mode CSS variables
```

## Step 4: Delegate Tasks (One at a Time)

### Task 1: Foundation — ThemeProvider

**Prompt sent to Claude Code:**
```
FEATURE REQUEST

Feature: ThemeProvider wrapper using next-themes
File(s): src/components/ThemeProvider.tsx (NEW), src/app/layout.tsx

Description:
1. Install next-themes package
2. Create ThemeProvider.tsx that wraps the app with next-themes provider
3. Integrate into layout.tsx

Requirements:
1. Use next-themes ThemeProvider with attribute="class"
2. Default theme should be "system"
3. Follow the component pattern in src/components/Providers.tsx
4. Don't change any existing styles
```

**Code produced:**

```diff
--- /dev/null
+++ b/src/components/ThemeProvider.tsx
@@ -0,0 +1,16 @@
+'use client';
+
+import { ThemeProvider as NextThemesProvider } from 'next-themes';
+import { type ThemeProviderProps } from 'next-themes';
+
+export function ThemeProvider({ children, ...props }: ThemeProviderProps) {
+  return (
+    <NextThemesProvider
+      attribute="class"
+      defaultTheme="system"
+      enableSystem
+      disableTransitionOnChange
+      {...props}
+    >
+      {children}
+    </NextThemesProvider>
+  );
+}
```

```diff
--- a/src/app/layout.tsx
+++ b/src/app/layout.tsx
@@ -1,6 +1,7 @@
 import { Providers } from '@/components/Providers';
+import { ThemeProvider } from '@/components/ThemeProvider';

 export default function RootLayout({ children }) {
   return (
     <html lang="en" suppressHydrationWarning>
       <body>
-        <Providers>{children}</Providers>
+        <ThemeProvider>
+          <Providers>{children}</Providers>
+        </ThemeProvider>
       </body>
     </html>
   );
```

**Pilot Review:** ✅ Clean, follows existing Providers pattern. `suppressHydrationWarning` added correctly.

---

### Task 2: UI — Toggle Button

**Prompt sent to Claude Code:**
```
FEATURE REQUEST

Feature: Dark mode toggle button
File: src/components/Header.tsx

Description:
Add a theme toggle button to the header navigation bar.

Requirements:
1. Use sun/moon icons from lucide-react (already installed)
2. Place in the header nav, right side, before the existing profile button
3. Use useTheme() hook from next-themes
4. Follow the existing button style in Header.tsx
5. Add smooth icon transition
```

**Code produced:**

```diff
--- a/src/components/Header.tsx
+++ b/src/components/Header.tsx
@@ -1,6 +1,8 @@
 'use client';

 import { useState } from 'react';
+import { useTheme } from 'next-themes';
+import { Sun, Moon } from 'lucide-react';

 export function Header() {
+  const { theme, setTheme } = useTheme();
+
   return (
     <header className="flex items-center justify-between px-6 py-4">
       <Logo />
       <nav className="flex items-center gap-4">
         <NavLinks />
+        <button
+          onClick={() => setTheme(theme === 'dark' ? 'light' : 'dark')}
+          className="p-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-800
+                     transition-colors duration-200"
+          aria-label="Toggle theme"
+        >
+          {theme === 'dark' ? (
+            <Sun className="h-5 w-5 text-yellow-500" />
+          ) : (
+            <Moon className="h-5 w-5 text-gray-600" />
+          )}
+        </button>
         <ProfileButton />
       </nav>
     </header>
   );
 }
```

**Pilot Review:** ✅ Clean. `aria-label` for accessibility. Correct placement. Follows existing styles.

---

### Task 3: Styling — Dark Mode CSS

**Prompt sent to Claude Code:**
```
Update src/app/globals.css to add dark mode colors using Tailwind's dark: prefix.

Dark color palette:
- Background: #0f172a (slate-900)
- Text: #e2e8f0 (slate-200)
- Card: #1e293b (slate-800)
- Border: #334155 (slate-700)

Add smooth transition for theme switching.
Don't remove any existing styles.
```

**Code produced:**

```diff
--- a/src/app/globals.css
+++ b/src/app/globals.css
@@ -1,8 +1,18 @@
 @tailwind base;
 @tailwind components;
 @tailwind utilities;

 @layer base {
+  * {
+    transition: background-color 0.2s ease, color 0.2s ease,
+                border-color 0.2s ease;
+  }
+
   body {
-    @apply bg-white text-gray-900;
+    @apply bg-white text-gray-900
+           dark:bg-slate-900 dark:text-slate-200;
+  }
+
+  .card {
+    @apply bg-white border-gray-200
+           dark:bg-slate-800 dark:border-slate-700;
   }
 }
```

**Pilot Review:** ✅ Clean. Smooth transitions. Respects existing styles.

## Step 5: Pilot Tests

```bash
$ npm run build
✓ Compiled successfully in 4.2s
✓ Linting and checking validity of types
✓ Collecting page data
✓ Generating static pages (5/5)

$ npm run lint
✓ No ESLint warnings or errors

$ npm run dev
✓ Ready on http://localhost:3000
# Visual check: ✅ Light mode works, ✅ Dark mode works, ✅ Toggle smooth
```

## Step 6: Report

> **✅ Dark mode support added**
>
> **Changes (3 files):**
> - `ThemeProvider.tsx` (new) — Wraps app with next-themes
> - `Header.tsx` — Added sun/moon toggle button
> - `globals.css` — Dark mode colors with smooth transitions
>
> **Decisions:**
> - Used `next-themes` (standard for Next.js)
> - Default theme = system preference
> - Added `disableTransitionOnChange` to prevent flash
>
> **Tests:** Build ✅ | Lint ✅ | Visual ✅
>
> **Time:** ~8 minutes (3 delegation rounds)

---

## Lessons Learned

1. **Break features into dependency-ordered tasks** — Foundation → UI → Styling
2. **One task per delegation keeps reviews focused** — Each diff was small and easy to verify
3. **Reference existing patterns** — "Follow Providers.tsx" gave Claude Code the right structure
4. **Visual testing matters** — Build passing ≠ looks correct, always check the UI
