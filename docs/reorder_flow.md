# Reorder Flow

## What it does

`_reorder()` in `order_card.dart` lets a user repeat a past order by reconstructing its items into the active cart and navigating to the cart page.

## Step-by-step

### 1. Precondition checks

- **Products loaded** — reads `ProductCubit.allProducts`. If the list is empty the method aborts with an error notification ("Unable to reorder at this time").
- **Order has items** — aborts with the same message if `order.items` is null or empty.
- **Preferred store set** — reads the user's `preferredStoreId` from `AuthCubit`. If no store is selected the method aborts ("No store selected. Please select a store first.").

### 2. Cart reset

`CartCubit.resetCart()` clears any existing cart before building the new one. This is necessary because `CartCubit` enforces a single-store constraint — all items in a cart must share the same `storeId`.

### 3. Per-item loop

For each `Item` in `order.items`:

| Step | What happens |
|------|-------------|
| Skip if no `productId` | Items without a product reference are ignored. |
| Product lookup | `products.firstWhereOrNull(p => p.product.docId == item.productId)` — if the product no longer exists in the catalog it is silently skipped. |
| Modifier map | Builds a `Map<modifierId, Modifier>` from `item.modifiers` for price resolution. |
| `buildModifierPriceSnapshot` | Resolves selected modifier IDs → price deltas using `CartHelper`. |
| `computeUnitTotal` | `basePrice + sum(modifierPriceDeltas)`. |
| `buildCartItemIdHashed` | Produces a stable SHA-1 hash of `"storeId|productId|canonicalMods"` used as the cart item's unique key. |
| `CartItem` construction | Creates the cart item with the user's **preferred store id** (not the original order's store). |
| `cartCubit.addProduct` | Adds or merges the item into the cart. Wrapped in try/catch — individual failures don't abort the whole loop. |

### 4. Result

- If `addedCount == 0` (all items were unavailable) → error notification and no navigation.
- Otherwise → navigates to `CartPage`.

## Key design detail: preferred store vs. order store

Cart items are stamped with the user's **currently selected store** (`preferredStoreId`), not the store the original order was placed at. This means:

- The reorder respects where the user wants to pick up today.
- Prices and availability are evaluated against the current catalog (products that no longer exist are dropped).
- The cart item ID hash includes the preferred store id, so the same product at a different store is a distinct cart entry.
