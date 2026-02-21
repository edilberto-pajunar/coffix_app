# Cart Items With Modifiers

## Goal

Allow a user to:

1. Select a product
2. Optionally customize it by selecting modifiers
3. Choose quantity
4. Add the customized product to the cart

This document defines the recommended client-side models and the add-to-cart process.

---

# Key Concepts

## 1) Cart stores a _snapshot of the user selection_

A cart item must include:

- productId (stable reference)
- productName (snapshot for display)
- basePrice (snapshot)
- quantity
- selected modifiers (the user’s chosen options)
- computed pricing fields (unitTotal, lineTotal) for UI

The server will still recalculate the final amount at checkout.

---

# Data Model

## CartItem

Recommended structure:

- cartItemId: String
  - A deterministic key that identifies the configuration (product + modifiers).
  - Used to merge identical items when adding to cart.

- storeId: String
  - Cart is store-scoped for ordering.

- productId: String

- productName: String (snapshot)

- productImageUrl: String? (snapshot optional)

- basePrice: num

- quantity: int

- selectedByGroup: Map<String, String>
  - Key: modifierGroupId
  - Value: modifierId (single-select)

- selectedExtras: List<String>
  - For multi-select groups like syrups (optional)

- modifierPriceSnapshot: Map<String, num>
  - Key: modifierId
  - Value: extraPrice actually applied at time of adding
  - This supports store overrides and future price changes without breaking the cart UI.

- unitTotal: num
  - basePrice + sum(extraPrice)

- lineTotal: num
  - unitTotal \* quantity

- createdAt: Timestamp/DateTime

---

# Selecting Modifiers

## Single-select groups

Example: Size, Milk

Store in:

selectedByGroup = {
"size": "large",
"milk": "oat"
}

## Multi-select groups (optional)

Example: Syrups, Add-ons

Use either:

A) selectedExtras list
OR
B) selectedByGroupMulti: Map<String, List<String>>

Choose one approach and stay consistent.

---

# Pricing on Client

## How to compute unitTotal

unitTotal = basePrice + sum(extraPrice of all selected modifiers)

Where extraPrice comes from the _effective customization_ (global + store overrides).

## Why store modifierPriceSnapshot

If the operator changes modifier pricing later, the cart should not visually “change” mid-session.
At checkout, server still recalculates and can prompt refresh if mismatched.

---

# Deterministic cartItemId

To merge identical items (same product + same selected modifiers):

cartItemId = hash(
storeId + "|" + productId + "|" + canonicalModifiersString
)

canonicalModifiersString should be stable:

- Sort by modifierGroupId
- Serialize as: groupId=modifierId;groupId=modifierId

Example:

size=large;milk=oat

If two items produce the same cartItemId, you can:

- increment quantity instead of adding a new line

---

# Add-to-Cart Flow

1. User opens Product page
2. User optionally opens Customize page
3. User selects modifiers + quantity
4. App builds CartItem using:
   - Product snapshot
   - Selected modifiers
   - Effective modifier prices (after store overrides)
   - Computed totals

5. CartCubit.addItem(cartItem)
   - If existing cartItemId exists: quantity += newQuantity
   - else: add new line

---

# Checkout Payload

When creating an order/transaction, send minimal but complete selection:

- storeId
- items: [
  {
  productId,
  quantity,
  selectedByGroup,
  selectedExtras
  }
  ]

Do NOT trust client totals.
Server recomputes:

- base product price
- modifier prices (store overrides)
- GST
- final total

---

# Notes

- Keep Cart store-scoped: switching stores should clear cart or force confirmation.
- Keep modifier selection logic in ProductCustomizationCubit, not ProductCubit.
- CartCubit should remain simple: add/remove/update quantity, compute UI totals.

---

End of document.
