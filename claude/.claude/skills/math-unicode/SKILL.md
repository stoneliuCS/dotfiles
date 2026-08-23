---
name: math-unicode
description: Render math notation using Unicode characters instead of LaTeX/Typst markup. Trigger whenever the user writes math in LaTeX ($...$, $$...$$, \frac, \partial, \nabla, \Delta, etc.) or Typst (frac, gradient, partial, sum, vec, etc.), OR whenever the assistant would naturally produce mathematical notation in a response (equations, derivatives, vectors, sums, Greek letters, subscripts/superscripts). Goal is readable plain-text math in the Claude Code terminal, which does not render LaTeX.
---

# Math rendering in plain Unicode

Claude Code's terminal renders Markdown but **does not** render LaTeX or Typst math. So `$\Delta C$` shows up as the literal four characters, not a typeset Δ.

When math appears (in the user's input or in your own response), produce it using Unicode characters that display natively in the terminal. Do **not** wrap math in `$...$`, `$$...$$`, `\(...\)`, or Typst `$ ... $` blocks.

## Symbol conversions

**Greek letters:**
`\alpha`→α `\beta`→β `\gamma`→γ `\delta`→δ `\epsilon`→ε `\zeta`→ζ `\eta`→η `\theta`→θ `\iota`→ι `\kappa`→κ `\lambda`→λ `\mu`→μ `\nu`→ν `\xi`→ξ `\pi`→π `\rho`→ρ `\sigma`→σ `\tau`→τ `\phi`→φ `\chi`→χ `\psi`→ψ `\omega`→ω
`\Gamma`→Γ `\Delta`→Δ `\Theta`→Θ `\Lambda`→Λ `\Xi`→Ξ `\Pi`→Π `\Sigma`→Σ `\Phi`→Φ `\Psi`→Ψ `\Omega`→Ω

**Calculus / operators:**
`\partial`→∂ `\nabla`→∇ (gradient) `\infty`→∞ `\sum`→∑ `\prod`→∏ `\int`→∫ `\oint`→∮ `\sqrt`→√ (or use ⁿ√ for nth root)
`\pm`→± `\mp`→∓ `\times`→× `\cdot`→· `\div`→÷ `\circ`→∘ `\ast`→∗

**Relations:**
`\approx`→≈ `\neq`→≠ `\leq`→≤ `\geq`→≥ `\equiv`→≡ `\sim`→∼ `\propto`→∝ `\in`→∈ `\notin`→∉ `\subset`→⊂ `\supset`→⊃ `\cup`→∪ `\cap`→∩ `\emptyset`→∅ `\forall`→∀ `\exists`→∃

**Arrows:**
`\to`/`\rightarrow`→→ `\leftarrow`→← `\leftrightarrow`→↔ `\Rightarrow`→⇒ `\Leftarrow`→⇐ `\Leftrightarrow`→⇔ `\mapsto`→↦

**Subscripts** (use Unicode subscript chars when single digit/letter):
`_0`→₀ `_1`→₁ `_2`→₂ `_3`→₃ `_4`→₄ `_5`→₅ `_6`→₆ `_7`→₇ `_8`→₈ `_9`→₉
`_i`→ᵢ `_j`→ⱼ `_n`→ₙ `_x`→ₓ `_a`→ₐ `_e`→ₑ `_o`→ₒ `_r`→ᵣ `_u`→ᵤ `_v`→ᵥ
For longer/uncovered subscripts (e.g. `_text`), fall back to `v_text` with a literal underscore.

**Superscripts:**
`^0`→⁰ `^1`→¹ `^2`→² `^3`→³ `^4`→⁴ `^5`→⁵ `^6`→⁶ `^7`→⁷ `^8`→⁸ `^9`→⁹
`^n`→ⁿ `^i`→ⁱ `^T`→ᵀ (transpose) `^{-1}`→⁻¹
For uncovered superscripts, fall back to `x^expr` literal.

**Fractions:**
- Simple inline: write as `a/b` or `(a+b)/(c+d)` with parens for grouping.
- Partial derivatives: `∂C/∂v₁` (not a stacked frac — keep it inline).
- Common Unicode fractions are fine when natural: ½ ⅓ ¼ ⅔ ¾.

**Vectors / matrices:**
- Vectors: use bold-style by convention, e.g. `**v**` in markdown, or arrow notation `v⃗` (combining arrow U+20D7).
- For component lists, use parentheses: `∇C = (∂C/∂v₁, ∂C/∂v₂)`.
- For matrices, draw with ASCII brackets across multiple lines when needed:
  ```
  [ a  b ]
  [ c  d ]
  ```

**Common composite forms:**
- Gradient: `∇C` or `∇f(x,y)`
- Partial derivative: `∂C/∂v` (inline, no frac stack)
- Delta / change: `ΔC ≈ ∇C · Δv`
- Dot product: `**a** · **b**` or `a · b`
- Limit: `lim_{x→0} f(x)` — keep `x→0` inline rather than stacked
- Integral: `∫₀^∞ f(x) dx` (subscript/superscript on the ∫)
- Summation: `∑ᵢ xᵢ` or `∑_{i=1}^n xᵢ`

## Style notes

- Keep equations on one line when possible.
- For display equations that need emphasis, indent with four spaces or put on their own line — don't use `$$...$$`.
- When a formula is genuinely too complex for inline Unicode (nested fractions, large matrices, integrals with intricate bounds), it's OK to fall back to a fenced code block with a readable ASCII-math layout. Don't force Unicode if it harms readability.
- If the user explicitly asks for LaTeX or Typst source (e.g. "give me the LaTeX for ..."), produce the markup as requested — this skill is about display, not stripping the user's ability to get raw source.

## Examples

User writes: `$\Delta C \approx \frac{\partial C}{\partial v_1} \Delta v_1 + \frac{\partial C}{\partial v_2} \Delta v_2$`
Render as: `ΔC ≈ (∂C/∂v₁)·Δv₁ + (∂C/∂v₂)·Δv₂`

User writes: `gradient C(v_1, v_2) = vec(frac(partial C, partial v_1), frac(partial C, partial v_2))`
Render as: `∇C(v₁, v₂) = (∂C/∂v₁, ∂C/∂v₂)`

User writes: `\sum_{i=1}^n x_i^2`
Render as: `∑ᵢ₌₁ⁿ xᵢ²` (or `∑_{i=1}^n xᵢ²` if subscript stack is awkward)
