# `modifierPriceSnapshot` vs `modifierLabelSnapshot` in `CartItem`

Both fields are snapshots — they freeze modifier data at the moment the item is added to the cart, so the cart remains accurate even if Firestore modifier documents change later.

## `modifierPriceSnapshot`

```dart
final Map<String, double> modifierPriceSnapshot;
```

- **Key:** modifier `docId`
- **Value:** the modifier's price (as a `double`)
- **Purpose:** used in price calculations (`computeUnitTotal`, `lineTotal`)
- **Required** — no default value

**Example:**
```json
{
  "mod_oat_milk": 0.50,
  "mod_extra_shot": 0.75
}
```

## `modifierLabelSnapshot`

```dart
final Map<String, String> modifierLabelSnapshot;
```

- **Key:** modifier `docId`
- **Value:** the modifier's display label (as a `String`)
- **Purpose:** used for rendering human-readable modifier names in the UI (cart summary, receipts, order details)
- **Optional** — defaults to `const {}`

**Example:**
```json
{
  "mod_oat_milk": "Oat Milk",
  "mod_extra_shot": "Extra Shot"
}
```

## Summary

| Field | Value type | Role | Required |
|---|---|---|---|
| `modifierPriceSnapshot` | `Map<String, double>` | Pricing / totals calculation | Yes |
| `modifierLabelSnapshot` | `Map<String, String>` | Display / UI rendering | No (defaults to `{}`) |

Both are keyed by modifier `docId`, so they can be used together to display a modifier name alongside its price.
