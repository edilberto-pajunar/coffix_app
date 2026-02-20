# Cart line items and modifiers

## Summary

A cart line item is uniquely identified by **product** and **modifiers**. The same product with different modifiers is treated as a different line item. The same product with the same modifiers is merged (quantity and total updated).

---

## Uniqueness

- **Same line item:** same `product.docId` and same set of modifier `docId`s.
- **Different line item:** different product, or same product but different modifier selection.

Modifiers are compared by their `docId` set (order does not matter).

---

## Add-to-cart behavior

When `CartCubit.addProduct` is called:

1. **Match:** If the cart already has an item with the same product and same modifiers, that item is updated:
   - `quantity` = existing quantity + new quantity
   - `total` = existing total + new total
   - Other fields (product, storeId, modifiers) unchanged.

2. **No match:** Otherwise a new line item is appended with the given product, quantity, storeId, modifiers, and total.

So:
- Add “Espresso” with modifier “Extra shot” twice → one line, quantity 2, totals summed.
- Add “Espresso” with “Extra shot” and “Espresso” with “Oat milk” → two separate lines.

---

## Implementation

- **Location:** `lib/features/order/logic/cart_cubit.dart`
- **Helper:** `_sameProductAndModifiers(item, product, modifiers)` compares `product.docId` and the set of modifier `docId`s.
- **Remove:** `removeProduct(productId)` still removes by product id only (all lines for that product). If you need to remove a single line, you’d remove by product + modifiers or by line index.
