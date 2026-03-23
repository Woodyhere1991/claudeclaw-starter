# First-Shot UI Perfection -- Rules for Building Beautiful Web Apps

Compiled 2026-03-24 from research across Stripe, Linear, Material Design,
Apple HIG, Shift Nudge, Josh W Comeau, and dozens of design system sources.

---

## TABLE OF CONTENTS
1. The Stack Decision (what to use)
2. Color System
3. Typography
4. Spacing & Layout
5. Dark Theme
6. Shadows & Depth
7. Border Radius
8. Mobile-First
9. Component Patterns
10. The Pre-Ship Checklist
11. Visual QA Tools
12. Reference Design Systems

---

## 1. THE STACK DECISION

### For single-file HTML apps (Woody's typical use case):

**Best option: Tailwind CSS v4 via CDN + hand-picked component patterns**

```html
<script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
```

- One script tag, zero build tools, full utility class access
- Custom theme via `<style type="text/tailwindcss">` with `@theme` directive
- Dark mode via `dark:` variant (works automatically with prefers-color-scheme)
- Limitation: development/prototype use; for production use CLI/Vite build

**Alternatives ranked:**

| Framework    | Setup      | Dark Mode | Components | Best For                    |
|-------------|------------|-----------|------------|-----------------------------|
| Tailwind v4 | 1 CDN tag  | Built-in  | DIY        | Full control, polished apps |
| DaisyUI     | Needs build| 30+ themes| Pre-built  | Rapid prototyping           |
| Pico CSS    | 1 CDN tag  | Auto      | Classless  | Simple forms/docs           |
| Shoelace    | 1 CDN tag  | Built-in  | Web Comps  | Rich interactive components |
| Bulma v1    | 1 CDN tag  | Built-in  | Class-based| Traditional layouts         |

**Recommendation:** Tailwind v4 CDN for all apps. Supplement with Shoelace
web components via CDN when you need complex interactive elements (dialogs,
dropdowns, tabs) without writing JavaScript.

### Fonts via CDN:
```html
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
```

Inter is the default choice -- designed for screens, excellent at all sizes,
used by Linear, GitHub, and most modern SaaS apps.

---

## 2. COLOR SYSTEM

### The 60-30-10 Rule (non-negotiable)

- **60% -- Dominant/Background:** The canvas. Dark gray for dark themes, white for light.
- **30% -- Secondary/Surface:** Cards, sidebars, input fields. Slightly lighter than background in dark mode.
- **10% -- Accent:** CTAs, active states, key interactive elements. Your brand color.

### Dark Theme Palette (copy this exactly):

```
Background (60%):   #0a0a0a  or  #121212  (NEVER pure #000000)
Surface (30%):      #1a1a1a  (cards, panels)
Surface elevated:   #262626  (modals, dropdowns)
Surface hover:      #2a2a2a  (interactive surface states)
Border:             #333333  or rgba(255,255,255,0.1)
Text primary:       #f5f5f5  (NOT pure #ffffff -- too harsh)
Text secondary:     #a3a3a3
Text tertiary:      #737373
Accent:             Pick ONE saturated color, then desaturate 10-20%
Success:            #22c55e  (green-500 desaturated)
Warning:            #f59e0b  (amber-500)
Error:              #CF6679  (Material Design dark error -- NOT red-500)
```

### Rules:
1. **Desaturate** all colors for dark backgrounds -- saturated colors vibrate optically
2. **Minimum 4.5:1** contrast ratio for body text (WCAG AA)
3. **Minimum 3:1** for large text (24px+), icons, and UI components
4. Use tools: WebAIM Contrast Checker, Coolors Contrast Checker
5. Stripe's approach: use CIELAB/OKLCH color space for perceptual uniformity -- colors 5 steps apart are guaranteed accessible together

---

## 3. TYPOGRAPHY

### The System:

```
Font family:    Inter (or system-ui as fallback)
Base size:      16px (1rem) -- never smaller for body text
Scale ratio:    1.25 (Major Third) for mobile, 1.333 (Perfect Fourth) for desktop

Sizes:
  xs:     12px / 0.75rem   -- captions, labels
  sm:     14px / 0.875rem  -- secondary text, metadata
  base:   16px / 1rem      -- body text
  lg:     18px / 1.125rem  -- lead paragraphs
  xl:     20px / 1.25rem   -- h4
  2xl:    24px / 1.5rem    -- h3
  3xl:    30px / 1.875rem  -- h2
  4xl:    36px / 2.25rem   -- h1
  5xl:    48px / 3rem      -- hero headings

Line heights:
  Headings:  1.1 - 1.2
  Body:      1.5 - 1.6
  UI labels: 1.25

Font weights:
  400: Body text
  500: Medium emphasis (subheadings, labels, nav items)
  600: Semibold (section titles, buttons)
  700: Bold (page titles, hero headings only)

Letter spacing:
  Headings > 30px: -0.02em (tighten)
  Body text:       0 (default)
  ALL-CAPS labels: 0.05em (widen)
```

### Font Pairing Rules:
- **Safest: Use one font family** with weight variation (Inter 400/500/600/700)
- If pairing: geometric sans (Inter) + humanist serif (Playfair Display)
- Never use more than 2 font families
- Inter + Manrope for fintech/productivity UIs
- Inter + Atkinson Hyperlegible for accessibility-focused apps

---

## 4. SPACING & LAYOUT

### The 8px Grid (non-negotiable)

ALL spacing values must be multiples of 4px (tight) or 8px (standard):

```
4px   -- tight: between related inline elements (icon + label)
8px   -- small: inner padding of compact elements, gap between chips
12px  -- between list items, form field gap
16px  -- standard padding for cards, sections
24px  -- between groups of related elements
32px  -- between major sections
48px  -- page-level vertical rhythm
64px  -- hero section padding
```

### Layout Rules:
1. **Max content width: 1280px** (max-w-7xl) -- wider loses readability
2. **Max text width: 65-75 characters** (max-w-prose / ~640px)
3. **Consistent gutter:** 16px mobile, 24px tablet, 32px desktop
4. **Section padding:** 48px+ vertical on mobile, 96px+ on desktop
5. **Card padding:** 16px mobile, 24px desktop
6. **Always align to the grid** -- if something looks "off", it's not on the grid

### Responsive Breakpoints (Tailwind defaults):
```
sm:   640px   (large phones landscape)
md:   768px   (tablets)
lg:   1024px  (laptops)
xl:   1280px  (desktops)
2xl:  1536px  (large monitors)
```

---

## 5. DARK THEME -- DEEP DIVE

### Core Principle: Elevation = Lightness (NOT shadows)

In dark themes, **higher surfaces are LIGHTER**, not darker. Shadows are
barely visible on dark backgrounds, so depth is communicated via surface color.

```
Layer 0 (base):      #0a0a0a   -- page background
Layer 1 (card):      #141414   -- primary content cards
Layer 2 (raised):    #1e1e1e   -- popovers, dropdowns
Layer 3 (overlay):   #282828   -- modals, dialogs
Layer 4 (highest):   #333333   -- tooltips
```

Each layer adds roughly 6-8% lightness.

### Critical Dark Theme Rules:
1. **NEVER invert your light theme** -- build dark palette from scratch
2. **Use #121212 or darker** as base -- Material Design standard
3. **Desaturate all colors** -- saturated colors vibrate on dark backgrounds
4. **Reduce image brightness** to 80-90% -- `filter: brightness(0.85)`
5. **Error red becomes #CF6679** -- standard red (#B00020) fails contrast on dark
6. **White overlays for states** -- hover = 8% white overlay, pressed = 12%
7. **Border-based separation** preferred over shadows (rgba(255,255,255,0.06-0.12))
8. **Test in actual dark environments** -- not in a bright office

### Text on Dark:
- Primary text: rgba(255,255,255,0.87) -- NOT pure white
- Secondary text: rgba(255,255,255,0.60)
- Disabled text: rgba(255,255,255,0.38)

---

## 6. SHADOWS & DEPTH

### Josh W Comeau's Layered Shadow System:

**Principle: Use multiple shadow layers, not one heavy shadow.**

```css
/* Small elevation -- cards, buttons */
--shadow-sm:
  0 1px 2px hsl(var(--shadow-color) / 0.3),
  0 1px 3px hsl(var(--shadow-color) / 0.15);

/* Medium elevation -- dropdowns, popovers */
--shadow-md:
  0 1px 2px hsl(var(--shadow-color) / 0.2),
  0 2px 4px hsl(var(--shadow-color) / 0.2),
  0 4px 8px hsl(var(--shadow-color) / 0.2);

/* Large elevation -- modals, dialogs */
--shadow-lg:
  0 1px 2px hsl(var(--shadow-color) / 0.15),
  0 2px 4px hsl(var(--shadow-color) / 0.15),
  0 4px 8px hsl(var(--shadow-color) / 0.15),
  0 8px 16px hsl(var(--shadow-color) / 0.15),
  0 16px 32px hsl(var(--shadow-color) / 0.15);
```

### Shadow Rules:
1. **Consistent light source** -- always top-left (x offset slightly less than y)
2. **Color-match shadows** to the background hue -- never pure black rgba(0,0,0,x)
3. **Higher = softer + wider + less opaque**
4. **Dark themes: minimize shadows** -- use surface color elevation instead
5. **Dark theme subtle glow:** `0 0 0 1px rgba(255,255,255,0.05)` as border-like ring
6. Keep shadow opacity between 8-20% per layer for natural look

---

## 7. BORDER RADIUS

### Consistent Radius Scale:

```
--radius-sm:   4px    -- chips, badges, small tags
--radius-md:   8px    -- buttons, inputs, cards (DEFAULT for most elements)
--radius-lg:   12px   -- modals, large cards, panels
--radius-xl:   16px   -- dialogs, full sections
--radius-full: 9999px -- pills, avatars, circular buttons
```

### Rules:
1. **Pick ONE base radius** (8px recommended) and derive the rest
2. **Nested radius formula:** inner = outer - padding
   - Card with 12px radius and 16px padding -> inner element radius = max(0, 12-16) = 0 or a smaller value
   - Card with 16px radius and 8px padding -> inner element radius = 8px
3. **Buttons and inputs: same radius** (they often sit side by side)
4. **Never mix rounded and square** on the same hierarchy level
5. 4-8px = professional/business, 12-20px = friendly/consumer, full = playful

---

## 8. MOBILE-FIRST RULES

### Touch Targets (non-negotiable):
- **Minimum 44x44px** (Apple) or **48x48px** (Material Design) for ALL interactive elements
- **8px minimum gap** between touch targets
- Padding counts -- a 24px icon in a 48px padded container = valid touch target

### Thumb Zone Design:
```
Top of screen:       Hard to reach -- put rarely-used items here (settings, profile)
Middle of screen:    Comfortable -- content lives here
Bottom of screen:    Easiest reach -- put PRIMARY ACTIONS here

Bottom navigation:   3-5 items max, with labels + icons
FAB position:        Bottom-right corner, 16px from edges
```

### Mobile-First Checklist:
1. **Start with 320px width** -- design for the smallest screen first
2. **Single column layout** by default, multi-column only above 768px
3. **Bottom navigation > hamburger menu** -- always visible > hidden
4. **16px body text minimum** -- never smaller on mobile
5. **Generous vertical spacing** -- thumbs need room between sections
6. **No hover-only interactions** -- every hover state needs a tap equivalent
7. **Sticky headers: max 56px tall** -- don't steal screen real estate
8. **Full-width buttons on mobile** -- easier to tap, clearer hierarchy
9. **Input fields: min 48px height** with 16px+ font (prevents iOS zoom)
10. **Swipe gestures as enhancement only** -- never the only way to do something

### Key Patterns:
- **Bottom sheet** > modal dialog on mobile (keeps thumb access)
- **Pull to refresh** for list views
- **Skeleton screens** > spinners for loading states
- **Toast notifications** at bottom (within thumb zone)

---

## 9. COMPONENT PATTERNS THAT ALWAYS WORK

### Cards:
- One subject per card, max 3 lines of text
- Visual hierarchy: image/icon -> title -> description -> action
- Consistent padding (16px mobile, 24px desktop)
- Single primary CTA per card
- Full-width on mobile, grid on desktop

### Navigation:
- **Bottom tab bar** for mobile (3-5 items with icon + label)
- **Sidebar** for desktop (collapsible on tablet)
- Active state: filled icon + accent color + label
- Inactive: outline icon + secondary text color

### Lists:
- Consistent row height (56-72px for single-line, 72-88px for two-line)
- Left: avatar/icon, Center: title + subtitle, Right: metadata/action
- Dividers: full-bleed or inset from left edge
- Swipe actions as enhancement (delete, archive)

### Modals/Dialogs:
- Max width: 480px (small), 640px (medium), 960px (large)
- Always closeable via X button, Escape key, and backdrop click
- Bottom sheet on mobile instead of centered modal
- Focus trap: tab key cycles within modal only
- Backdrop: rgba(0,0,0,0.5) for light theme, rgba(0,0,0,0.7) for dark

### Stats/Metrics Display:
- Grid of 2-4 stat cards
- Large number (2xl-3xl font) + small label (xs-sm font)
- Optional: trend indicator (arrow + percentage, green up / red down)
- Optional: sparkline chart

### Forms:
- Label above input (not placeholder-only -- accessibility fail)
- One column layout for forms (two-column only for short related fields like city/state)
- Group related fields with subtle dividers
- Inline validation (show errors as user types, after first blur)
- Primary submit button: full-width on mobile, right-aligned on desktop
- Disabled state: 0.5 opacity, cursor-not-allowed

### Empty States:
- Illustration or icon (centered, muted)
- Short heading explaining the state
- Brief description with next-step CTA
- Never leave a blank white/dark rectangle

### Loading States:
- Skeleton screens (animated gradient shimmer) for content areas
- Spinner only for actions (button clicks, form submits)
- Progress bar for deterministic operations
- Skeleton matches the approximate shape of the real content

---

## 10. THE PRE-SHIP CHECKLIST

Run through this EVERY TIME before showing any UI to Woody:

### Visual Polish (the "squint test"):
- [ ] Squint at the screen -- does the layout have clear visual hierarchy?
- [ ] Does the 60-30-10 color ratio hold?
- [ ] Is spacing consistent? (Check for rogue 5px or 13px values)
- [ ] Are all interactive elements at least 44px touch targets?
- [ ] Do all text elements meet contrast ratio (4.5:1 body, 3:1 large/icons)?

### Typography:
- [ ] Only 1-2 font families used
- [ ] Font sizes from the defined scale (no arbitrary sizes)
- [ ] Headings have tighter line-height (1.1-1.2)
- [ ] Body text line-height is 1.5-1.6
- [ ] Max line length ~65-75 characters
- [ ] No orphaned single words on their own line (for headings)

### Layout:
- [ ] All spacing values are multiples of 4px or 8px
- [ ] Content has max-width container (not stretching to full viewport)
- [ ] Consistent padding within same-level containers
- [ ] Elements are aligned on the grid (left edges line up)

### Color:
- [ ] Dark theme uses #121212 or darker, NOT pure black
- [ ] Accent color used sparingly (only for primary actions and active states)
- [ ] Error states use desaturated red (#CF6679 for dark)
- [ ] No saturated colors directly on dark backgrounds
- [ ] Status colors (success/warning/error) are distinct and accessible

### Interactive States (EVERY interactive element needs ALL of these):
- [ ] Default state
- [ ] Hover state (desktop) -- subtle background change or underline
- [ ] Active/pressed state
- [ ] Focus state -- visible focus ring (outline, ring) for keyboard users
- [ ] Disabled state -- reduced opacity (0.5), cursor-not-allowed
- [ ] Loading state where applicable

### Responsive:
- [ ] Works at 320px width (small phones)
- [ ] Works at 768px (tablets)
- [ ] Works at 1280px (desktop)
- [ ] No horizontal scrolling at any size
- [ ] Text is readable without zooming on mobile
- [ ] Touch targets are 44px+ on mobile

### Dark Theme Specific:
- [ ] Background hierarchy: darker = further back, lighter = closer
- [ ] Borders/dividers use rgba(255,255,255,0.06-0.12), not gray hex values
- [ ] Images dimmed slightly (brightness 85-90%)
- [ ] No pure white text (#f5f5f5 instead)
- [ ] Shadows replaced by surface color elevation

### Content:
- [ ] Empty states handled (no blank screens)
- [ ] Loading states handled (skeletons or spinners)
- [ ] Error states handled (clear message + recovery action)
- [ ] Long text truncated gracefully (ellipsis or "show more")
- [ ] Edge cases: 0 items, 1 item, 100+ items

### Animations (if any):
- [ ] Duration: 150-300ms for micro-interactions, 300-500ms for transitions
- [ ] Easing: ease-out for entrances, ease-in for exits, ease-in-out for state changes
- [ ] Respect prefers-reduced-motion
- [ ] No animation on page load that blocks content visibility

---

## 11. VISUAL QA TOOLS

### Automated Visual Regression:
- **Percy** (BrowserStack) -- AI-powered, highlights meaningful changes, ignores anti-aliasing noise. The 2025 Visual Review Agent is best-in-class.
- **BackstopJS** -- open source, pixel-comparison, good for CI/CD, prone to false positives from anti-aliasing
- **Chromatic** -- built for Storybook, catches component-level visual regressions
- **Playwright screenshots** -- already in use; combine with image diffing for basic regression

### Design Consistency:
- **Stylelint** -- lint CSS for consistent values (catches rogue colors, non-token spacing)
- **Design token validation** -- use CSS custom properties as tokens, lint for raw values
- **Browser DevTools** -- Grid/Flexbox overlay to verify alignment

### Manual QA Tools:
- **VisBug** (Chrome extension) -- inspect spacing, alignment, accessibility in-browser
- **What Font** (extension) -- verify font rendering
- **WAVE** (extension) -- automated accessibility audit
- **Lighthouse** -- performance + accessibility scoring

---

## 12. REFERENCE DESIGN SYSTEMS (steal from these)

### For Dark-Themed Mobile-First Apps:

1. **Linear** -- The gold standard for dark SaaS UI
   - Neutral grays, minimal chrome, Inter font
   - Information density without clutter
   - Subtle glassmorphism effects
   - https://linear.app

2. **Vercel/Geist** -- Clean, developer-focused dark UI
   - Geist font + monospace for code
   - Extreme minimalism, high contrast
   - https://vercel.com/geist/introduction

3. **Shadcn/ui** -- Copy-paste components built on Radix + Tailwind
   - Best component patterns for React
   - Full dark mode support
   - https://ui.shadcn.com

4. **Material Design 3** -- Google's comprehensive system
   - Most documented, with specific dark theme guidance
   - Dynamic color, elevation system, component specs
   - https://m3.material.io

5. **Apple Human Interface Guidelines** -- Premium polish reference
   - Vibrancy, depth, materials system
   - SF Symbols icon system
   - https://developer.apple.com/design

6. **Radix UI** -- Unstyled accessible primitives
   - Use as foundation, style with Tailwind
   - Handles keyboard nav, focus management, ARIA
   - https://www.radix-ui.com

7. **Stripe** -- King of polish and attention to detail
   - Accessible color system using CIELAB/OKLCH
   - Gradient mastery, micro-animations
   - https://stripe.com

---

## QUICK REFERENCE -- THE 10 RULES

When in doubt, follow these 10 rules and the UI will look professional:

1. **8px grid** -- every spacing value is a multiple of 4 or 8
2. **60-30-10** -- background 60%, surface 30%, accent 10%
3. **One font, four weights** -- Inter 400/500/600/700
4. **4.5:1 contrast** -- test every text/background combination
5. **44px touch targets** -- minimum for every interactive element
6. **#121212 not #000000** -- never pure black backgrounds
7. **8px border radius** -- consistent across buttons, inputs, cards
8. **Bottom nav on mobile** -- primary actions in the thumb zone
9. **Every state covered** -- default, hover, active, focus, disabled, loading, empty, error
10. **Consistent is better than clever** -- uniformity beats novelty every time

---

## TAILWIND DARK THEME STARTER

Copy-paste this into any single-file HTML app as a starting point:

```html
<!DOCTYPE html>
<html lang="en" class="dark">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>App</title>
  <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
  <style type="text/tailwindcss">
    @theme {
      --font-sans: 'Inter', system-ui, sans-serif;
      --color-bg: #0a0a0a;
      --color-surface: #141414;
      --color-surface-raised: #1e1e1e;
      --color-surface-overlay: #282828;
      --color-border: rgba(255, 255, 255, 0.08);
      --color-text-primary: #f5f5f5;
      --color-text-secondary: #a3a3a3;
      --color-text-tertiary: #737373;
      --color-accent: #3b82f6;
      --color-accent-hover: #2563eb;
      --color-success: #22c55e;
      --color-warning: #f59e0b;
      --color-error: #CF6679;
      --radius-sm: 4px;
      --radius-md: 8px;
      --radius-lg: 12px;
      --radius-xl: 16px;
    }
  </style>
</head>
<body class="bg-bg text-text-primary font-sans min-h-screen">
  <!-- App content here -->
</body>
</html>
```

---

*This document is the single source of truth for UI quality standards.
Read it before building any UI. Follow the 10 rules. Run the checklist.*
