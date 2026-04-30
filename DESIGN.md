# The Design System: Clinical Sophistication & Editorial Precision

## 1. Overview & Creative North Star: "The Clinical Curator"
This design system moves beyond the cold, sterile tropes of traditional medical software to embrace **The Clinical Curator**. This philosophy treats health data as a premium editorial experience—authoritative yet deeply empathetic. 

The "template" look is rejected in favor of **intentional asymmetry** and **tonal depth**. We achieve a "High-End Editorial" feel by using expansive white space, overlapping layout elements that break the 12-column grid, and a sophisticated layering system that mimics fine physical materials like vellum and frosted glass.

- Font : Plus Jakarta Sans
- Seed Color : #2C7A5C
- Color Pallete :
    - Primary : #2C7A5C
    - Secondary : #1D5FA8
    - Tertiary : #C4940A
    - Neutral : #111827

---

## 2. Color & Surface Philosophy
The palette balances the biological grounding of `primary` green with the rigorous authority of `secondary` blue. 

### The "No-Line" Rule
**Explicit Instruction:** Designers are prohibited from using 1px solid borders for sectioning or containment. Boundaries must be defined solely through:
- **Background Shifts:** Placing a `surface-container-low` section against the base `surface`.
- **Tonal Transitions:** Using soft gradients or subtle shifts in lightness to signal a change in context.

### Surface Hierarchy & Nesting
Treat the UI as a series of physical layers. Hierarchy is established by "stacking" surface tiers:
- **Level 0 (Base):** `surface` (#F9F9FF)
- **Level 1 (Sub-sectioning):** `surface-container-low` (#F1F3FF)
- **Level 2 (Active Cards):** `surface-container-lowest` (#FFFFFF) for maximum "pop" and clarity.
- **Level 3 (Interactive Overlays):** `surface-container-high` or `highest` to draw immediate focus.

### Signature Textures & The Glass Rule
To inject "soul" into the medical experience:
- **CTA Depth:** Main action buttons should use a subtle linear gradient from `primary` (#056145) to `primary-container` (#2C7A5C) at a 135° angle.
- **Glassmorphism:** Floating navigation bars and modal overlays must utilize `backdrop-blur` (12px–20px) combined with a semi-transparent `surface` color (80% opacity). This ensures the medical data feels integrated and fluid, never "pasted on."

---

## 3. Typography: The Editorial Voice
We utilize **Plus Jakarta Sans** not as a utility font, but as a branding tool.

- **Display & Headlines:** Use `display-lg` to `headline-sm` with a weight of **700**. These should be used with tight letter-spacing (-0.02em) to create an authoritative, "news-header" feel. 
- **The Title Layer:** `title-lg` (22px/600 weight) serves as the bridge between clinical data and the user. It should feel prominent and reassuring.
- **Body & Labels:** `body-md` (14px) is our workhorse. We prioritize legibility through generous line-heights (1.6) to ensure complex medical information is digestible.
- **Contrast as Hierarchy:** Pair a `display-md` metric (e.g., an allergen count) with a `label-sm` descriptor in `on-surface-variant` (#3F4943) to create high-end visual tension.

---

## 4. Elevation & Depth
Depth is a clinical tool used to indicate urgency and interaction.

- **Tonal Layering Principle:** Avoid shadows whenever possible. Achieve "lift" by placing a `surface-container-lowest` card on a `surface-dim` background. This creates a soft, natural distinction that is easier on the eyes in a medical context.
- **Ambient Shadows:** For floating elements (Modals, FABs), use extra-diffused shadows: `blur: 32px`, `y: 8px`, `color: rgba(20, 27, 43, 0.06)`. The shadow must never be pure black; it should be a tint of `on-surface`.
- **The "Ghost Border" Fallback:** If a boundary is strictly required for accessibility, use the `outline-variant` token at **15% opacity**. This creates a "suggestion" of a line rather than a hard clinical wall.

---

## 5. Components & Interaction

### Buttons
- **Primary:** Gradient fill (`primary` to `primary-container`), 24px (xl) radius, `label-md` uppercase text with 0.05em tracking.
- **Secondary:** `surface-container-high` background with `secondary` text. No border.
- **Tertiary:** `ghost` style. Only text and a Lucide icon (1.75px stroke).

### Input Fields
- Avoid boxes. Use a "Soft Underline" approach: a `surface-container-low` background with a slightly darker `outline-variant` bottom edge. Focus states should transition the entire background to `primary-fixed` (#A5F3CE) at 20% opacity.

### Cards & Risk Indicators
- **Strict Rule:** Forbid divider lines. Separate content using the **Spacing Scale** (e.g., a 24px gap between text blocks) or a background shift.
- **Risk Chips:** Use `tertiary` (Premium Gold) for moderate risks and `error` for high risks. These should be pills (9999px radius) with a low-opacity version of the color as the background and full-opacity as the text.

### Additional Signature Components
- **Risk Assessment Meter:** A custom gauge using a thick 8px stroke, utilizing the `primary` to `tertiary` to `error` color scale.
- **Contextual Insight Trays:** Bottom sheets that use Glassmorphism to slide over the UI, providing "at-a-glance" allergy triggers without losing the main dashboard's context.

---

## 6. Do’s and Don’ts

### Do:
*   **Embrace Asymmetry:** Align a header to the left while placing a supporting metric slightly offset to the right. 
*   **Use Tonal Shifts:** Define content areas using `surface-container-low` vs. `surface`.
*   **Optical Breathing Room:** Use `64px (3xl)` spacing between major clinical sections to reduce cognitive load.

### Don’t:
*   **No Hard Outlines:** Never use a 100% opaque border to wrap a card or input.
*   **No Standard Drop Shadows:** Avoid the "floating on a cloud" look; keep shadows grounded and ambient.
*   **No Crowding:** Never sacrifice white space for the sake of fitting more data on one screen. If the data is dense, use a paginated editorial layout.