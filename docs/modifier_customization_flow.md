# Modifier Customization Fetch Flow

## Purpose

This document defines the step-by-step process for fetching and building product customization (modifier groups + modifiers) when a user opens the Customize Product screen.

This flow supports:

- Global product definitions
- Store-specific overrides
- Clean separation of responsibilities
- Scalable Firestore reads

---

# Architecture Overview

Global Source of Truth:

- products/{productId}
- modifierGroups/{groupId}
- modifiers/{modifierId}

Store Override Layer:

- stores/{storeId}/productOverrides/{productId}

The Store does NOT redefine the catalog.
It only restricts or overrides availability and pricing.

---

# When This Runs

This process runs ONLY when:

- User enters Customize Product screen
- OR user taps the customization button

It should NOT run on the product list screen.

---

# Step-by-Step Fetch Process

## Step 1 — Receive Inputs

Required inputs:

- storeId
- product (already selected from menu)

The product must contain:

- modifierGroupIds (List<String>)

---

## Step 2 — Fetch Store Override (1 Read)

Path:

stores/{storeId}/productOverrides/{productId}

If document exists, read:

- disabledGroupIds
- disabledModifierIds
- priceOverrides (optional)
- defaultModifierByGroup (optional)

If document does NOT exist:

- Treat as empty override

---

## Step 3 — Compute Enabled Modifier Groups

From product.modifierGroupIds:

Remove any group found in override.disabledGroupIds

Result:

- enabledGroupIds

If empty → no customization required.

---

## Step 4 — Fetch Modifier Groups (Batch)

Query modifierGroups collection using:

- whereIn (max 10 per query, chunk if needed)

Important:

- Preserve the original order of enabledGroupIds
- Firestore does NOT guarantee order

---

## Step 5 — Collect Modifier IDs

From fetched groups:

Collect all group.modifierIds

Remove any ID in:

- override.disabledModifierIds

Result:

- filteredModifierIds

---

## Step 6 — Fetch Modifiers (Batch)

Query modifiers collection using:

- whereIn (chunk if more than 10)

Build a modifierId → Modifier map for quick lookup.

---

## Step 7 — Apply Overrides and Build UI Bundles

For each group (in correct order):

1. Filter disabled modifiers
2. Map modifierId → Modifier
3. Apply priceOverrides if present
4. Apply defaultModifierByGroup if defined

Return:

List<ModifierGroupBundle>

Each bundle contains:

- group
- list of effective modifiers

---

# Responsibility Breakdown

Repository Layer:

- Performs all Firestore reads
- Applies override logic
- Returns clean UI-ready structure

CustomizationCubit:

- Calls repository method
- Emits loading / loaded / error state
- Handles user selections
- Calculates client-side preview total

Server (Cloud Functions):

- Recalculate final price
- Validate modifiers
- Apply GST
- Prevent client manipulation

---

# Performance Notes

- Only fetch customization data when screen opens
- Do NOT prefetch modifiers for all products
- Cache results in-memory using key: "{storeId}:{productId}"
- Chunk whereIn queries to respect Firestore limits

---

# Key Rules

1. Product only stores modifierGroupIds
2. ModifierGroup only stores modifierIds
3. Store only restricts or overrides
4. Never mix group IDs and modifier IDs in one list
5. Always preserve ordering from product definition

---

# Future Extensions Supported

This structure allows:

- Store-specific price overrides
- Required vs optional groups
- Multi-select groups (e.g. syrups)
- Default selections per store
- Temporary disabling of modifiers
- Inventory-based availability

Without refactoring the data model.

---

End of document.
