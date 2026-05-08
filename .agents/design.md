---
name: Modern Gentleman
colors:
  surface: '#141313'
  surface-dim: '#141313'
  surface-bright: '#3a3939'
  surface-container-lowest: '#0e0e0e'
  surface-container-low: '#1c1b1b'
  surface-container: '#201f1f'
  surface-container-high: '#2b2a2a'
  surface-container-highest: '#353434'
  on-surface: '#e5e2e1'
  on-surface-variant: '#c4c7c7'
  inverse-surface: '#e5e2e1'
  inverse-on-surface: '#313030'
  outline: '#8e9192'
  outline-variant: '#444748'
  surface-tint: '#c8c6c5'
  primary: '#c8c6c5'
  on-primary: '#313030'
  primary-container: '#1a1a1a'
  on-primary-container: '#848282'
  inverse-primary: '#5f5e5e'
  secondary: '#c6c6c7'
  on-secondary: '#2f3131'
  secondary-container: '#454747'
  on-secondary-container: '#b4b5b5'
  tertiary: '#cac6c4'
  on-tertiary: '#31302f'
  tertiary-container: '#1b1a19'
  on-tertiary-container: '#858281'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#e5e2e1'
  primary-fixed-dim: '#c8c6c5'
  on-primary-fixed: '#1c1b1b'
  on-primary-fixed-variant: '#474746'
  secondary-fixed: '#e2e2e2'
  secondary-fixed-dim: '#c6c6c7'
  on-secondary-fixed: '#1a1c1c'
  on-secondary-fixed-variant: '#454747'
  tertiary-fixed: '#e6e2df'
  tertiary-fixed-dim: '#cac6c4'
  on-tertiary-fixed: '#1c1b1a'
  on-tertiary-fixed-variant: '#484645'
  background: '#141313'
  on-background: '#e5e2e1'
  surface-variant: '#353434'
typography:
  display-lg:
    fontFamily: Noto Serif
    fontSize: 48px
    fontWeight: '700'
    lineHeight: '1.2'
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Noto Serif
    fontSize: 32px
    fontWeight: '600'
    lineHeight: '1.3'
    letterSpacing: -0.01em
  title-sm:
    fontFamily: Manrope
    fontSize: 20px
    fontWeight: '600'
    lineHeight: '1.5'
    letterSpacing: 0.02em
  body-md:
    fontFamily: Manrope
    fontSize: 16px
    fontWeight: '400'
    lineHeight: '1.6'
    letterSpacing: 0.01em
  label-caps:
    fontFamily: Manrope
    fontSize: 12px
    fontWeight: '700'
    lineHeight: '1.0'
    letterSpacing: 0.1em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  unit: 8px
  container-margin: 24px
  gutter: 16px
  section-gap: 48px
---

## Brand & Style

The visual identity of this design system centers on the "Modern Gentleman"—an aesthetic that balances rugged masculinity with high-end editorial refinement. The goal is to evoke the atmosphere of an exclusive, members-only lounge.

This design system utilizes a **Minimalist** approach with subtle **Tactile** influences. It prioritizes expansive negative space to suggest luxury, while using thin borders and gold accents to provide architectural structure. The interface should feel quiet, confident, and meticulously groomed, avoiding flashy animations in favor of purposeful, weighted transitions.

## Colors

The palette is anchored in deep, nocturnal tones to create a sense of intimacy and prestige. 

- **Matte Black (#121212):** Used for the primary canvas to reduce eye strain and emphasize the premium nature of the content.
- **Deep Charcoal (#1A1A1A):** Utilized for secondary surfaces and cards, providing a subtle tonal lift from the background.
- **Elegant Gold (#D4AF37):** Reserved strictly for primary calls to action, active states, and high-value branding elements.
- **Crisp White (#FFFFFF):** Used for primary typography and essential icons to ensure maximum legibility against the dark backdrop.

## Typography

The typography strategy employs a classic serif for headlines to communicate heritage and craftsmanship, paired with a modern sans-serif for functional text to ensure a contemporary feel.

Headlines should utilize **Noto Serif** with tighter tracking to create a "logo-like" appearance for section titles. For all body copy, labels, and interactive elements, **Manrope** provides a balanced, masculine geometric structure. Use uppercase styling for labels and small buttons to enhance the architectural, "tailored" look of the UI.

## Layout & Spacing

This design system adheres to a **Fixed Grid** philosophy for content containers, set within a generous fluid margin. A strict 8px baseline grid governs all vertical rhythm.

Layouts must prioritize "breathing room." Section headers should be separated by large vertical gaps (48px+) to prevent the interface from feeling cluttered. Content is centered with a maximum width of 1200px on desktop, while mobile views should maintain a 24px safety margin on both edges to preserve the spacious, high-end feel.

## Elevation & Depth

Depth is achieved through **Tonal Layering** rather than heavy shadows. Since the background is Matte Black, elevation is signaled by moving up the grayscale:

1.  **Level 0 (Background):** Matte Black (#121212).
2.  **Level 1 (Cards/Surfaces):** Deep Charcoal (#1A1A1A).
3.  **Level 2 (Active Elements):** Subtle border stroke (#2C2C2C).

Where shadows are required (e.g., floating action buttons or modal overlays), use a "Gold-Tinted Dark Shadow"—a very soft, 20% opacity black shadow with a 1px Gold-tinted inner glow to suggest the object is catching light from the accent color.

## Shapes

The shape language combines the stability of rectangles with the approachability of rounded corners. 

Standard UI components like buttons and inputs use a **0.5rem (8px)** radius. Larger structural containers, specifically service and barber cards, must use a **1rem (16px)** radius as requested. This creates a distinct visual hierarchy where content "containers" feel softer and more premium than the interactive "tools" within them. Borders should remain thin (1px) and use low-contrast charcoal colors.

## Components

- **Primary Buttons:** Solid Gold (#D4AF37) with black text. Use 12px uppercase Manrope Bold for the label. High-gloss finish is discouraged; keep the gold matte.
- **Secondary Buttons:** Transparent background with a thin (1px) Gold or White border. 
- **Cards:** Deep Charcoal (#1A1A1A) background, 16px corner radius, and a subtle 1px border (#2C2C2C). Content inside cards should have at least 24px of internal padding.
- **Input Fields:** Bottom-border only or very thin-outlined boxes. Focus states should transition the border color to Gold.
- **Iconography:** Use 2pt stroke weight icons. Avoid filled icons unless in an active state. Icons should be White or Gold.
- **Barber Profiles:** Use circular or 16px rounded-square apertures for photography. High-contrast, black-and-white photography is recommended to maintain the brand tone.
- **Booking Slotted List:** Use a "Time-Block" component—thin rectangular chips that turn solid Gold when selected.