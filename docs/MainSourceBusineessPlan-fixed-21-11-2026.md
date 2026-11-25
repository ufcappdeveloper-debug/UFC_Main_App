# Main Source Business: Mobile App Integration Plan

**Audience:** Flutter developer of the UFC Main App (`UFC_Main_App`, feed module)
**Backend:** `ufcapi` (Laravel). Every endpoint in this document is live and covered by automated tests.
**Date:** 21-11-2026. This version replaces `MainSourceBusineessPlan.md` (19-11-2026).

### Changes since the 19-11-2026 version
| # | Change | Sections |
|---|---|---|
| 1 | **Bank transfer is part of this release.** When an admin enables it for a Main Source (and adds an active bank account), `BANK` appears in `payment_methods`. The app shows the bank accounts, lets the customer upload the transfer receipt, and handles rejection and re-upload. | 0, 4.5, 5, 7 |
| 2 | **Order details now return the bank accounts** (`bank_accounts`) and a `can_upload_receipt` flag, so a customer who closes the app can still see where to transfer and upload the receipt later. | 4.5, 5 |
| 3 | **Order history only contains customer-facing entries.** Internal admin notes and assignments are no longer returned; `status_history[].note` is a short customer text (or `null`). | 5 |
| 4 | **Show translated error texts.** Branch on `code` and show the app's own Arabic/English/Urdu text; the API `message` is English and is only a fallback. A ready translation table is included. | 0, 6 |
| 5 | Open business questions listed for the product owner (browsing without login, delivery area). | 9 |

---

## 0. Overview

### What is changing
UFC adds a third way to sell feed: **Main Source**. The admin chooses the business mode in the dashboard (**Settings → Business Settings**):

| Mode | What the app shows |
|---|---|
| `main_source` | No Station / Distributor choice. The home screen lists the **categories and products of the Main Sources** directly. |
| `marketplace` | Today's behaviour: "Buy from Station" and/or "Buy from Distributor", depending on which of the two is enabled. |

Only one mode is active at a time. Switching the mode only stops **new** orders for the disabled business. Existing orders of every business stay visible to customers, and order history, details and tracking keep working.

### Requirements for the app
1. **On every launch**, call `GET /app/business-config` to find out which business is enabled.
2. If `main_source_enabled` is `true`, the home screen lists all Main Source categories and products.
3. Otherwise, show "Buy from Station" and/or "Buy from Distributor", only the ones that are enabled.
4. When buying from Main Source, **hide the delivery-method choice** (no Pickup / Delivery cards, no plate number, no delivery date). Every Main Source order is delivered. This may be shown again later.
5. When buying from Main Source, **always send the user's current location**, and let the user change it by moving a **pin on the map**. This happens on every Main Source checkout. The location is saved on the order only, not in the address book.
6. Payment methods are the same as for stations: **Cash, SADAD, Mada, Wallet**, including the wallet checkbox that can pay part of the total. **Bank Transfer** is also available when the admin enables it for the Main Source (it then appears in `payment_methods`).

### Flow
```
App launch
   │
   ├─ GET /app/business-config ──────────────┐
   │                                         │
   ▼                                         ▼
mode == "main_source"                 mode == "marketplace"
   │                                         │
Main Source Home                      Station / Distributor home (existing)
(categories + products)               show only enabled cards; if only one is
   │                                  enabled, open it directly
Product details ─► Cart (Main Source)
   │
Checkout ── location card (GPS + map pin) ── POST /main-source/orders/quote
   │        payment: wallet checkbox + Cash / SADAD / Mada / Wallet / Bank Transfer
   ▼
POST /main-source/orders
   ├─ CASH / WALLET ─► success page
   ├─ SADAD ─► success page shows SADAD number + bill number
   ├─ BANK ─► bank accounts + "Upload receipt" ─► POST /main-source/orders/{id}/bank-transfer
   │          (admin approves or rejects in the dashboard; on rejection the customer uploads again)
   └─ MADA ─► MadaPaymentScreen(checkout_id, integrity)
               ─► GET /main-source/payments/verify/{checkoutId} ─► success / retry
```

### Conventions (same as the rest of the app)
- **Base URL:** `{{base}}` = `AppConfig.baseUrl` (`https://api.ufc-app.com`). All paths below start with `{{base}}/api/ufc/v1`.
- **Auth:** `Authorization: Bearer <token>` and `Accept: application/json`, already added by `AppInterceptor`. The catalogue endpoints are public; cart, checkout and orders need a token.
- **Body:** JSON for every request except the bank receipt upload, which is `multipart/form-data`.
- **Success shape:** `{ "message": "...", "data": ... }`. Lists use Laravel pagination: items are in `data.data`, plus `current_page`, `last_page`, `total`, and so on.
- **Error shapes:**
  - Validation: HTTP **400** `{ "message": "Required fields are missing", "errors": { "field": ["..."] } }`
  - Business rule: HTTP **403 / 409 / 422** `{ "status": "fail", "code": "SOME_CODE", "message": "..." }`, sometimes with extra fields. Branch on `code`; the full list is in [section 6](#6-errors-and-codes).
  - **`message` is always English.** Show the app's own translated text for each `code` (table in [6.1](#61-translated-error-texts)) and use `message` only as a fallback for codes the app doesn't know.
- **Money:** numbers in SAR, rounded to 2 decimals.
- **Dates:** ISO-8601 in UTC (`2026-11-19T20:32:46.000000Z`).
- **Texts:** names come as `name_en`, `name_ar`, `name_ur`. Pick by app language and fall back to `name_en` when a value is `null` (same as `localized()` in `distributor_style.dart`).
- **Payment method codes:** `CASH`, `SADAD`, `MADA`, `WALLET`, the same codes the station checkout uses (`PaymentOption.getValue`), plus `BANK` for bank transfer.

### Endpoint summary

| # | Method & path | Auth | Purpose |
|---|---|---|---|
| 1 | `GET /app/business-config` | – | Business mode on launch |
| 2 | `GET /main-source/home` | – | Sources + categories + latest products (home screen) |
| 3 | `GET /main-sources` | – | Active Main Sources |
| 4 | `GET /main-source/categories` | – | Categories |
| 5 | `GET /main-source/products` | – | Product list (filters, search, paging) |
| 6 | `GET /main-source/products/{id}` | – | Product details |
| 7 | `GET /main-source/cart` | ✔ | Cart |
| 8 | `GET /main-source/cart/count` | ✔ | Cart badge |
| 9 | `POST /main-source/cart/add` | ✔ | Add to cart |
| 10 | `PUT /main-source/cart/{id}` | ✔ | Change quantity |
| 11 | `DELETE /main-source/cart/{id}` | ✔ | Remove line |
| 12 | `DELETE /main-source/cart/clear` | ✔ | Empty cart |
| 13 | `POST /main-source/orders/quote` | ✔ | Totals before paying |
| 14 | `POST /main-source/orders` | ✔ | Place order (checkout) |
| 15 | `GET /main-source/payments/verify/{checkoutId}` | ✔ | Mada result |
| 16 | `POST /main-source/orders/{id}/pay` | ✔ | Retry Mada payment |
| 17 | `GET /main-source/orders` | ✔ | My Main Source orders |
| 18 | `GET /main-source/orders/{id}` | ✔ | Order details |
| 19 | `POST /main-source/orders/{id}/cancel` | ✔ | Cancel |
| 20 | `POST /main-source/orders/{id}/reorder` | ✔ | Order again (fills the cart) |
| 21 | `POST /main-source/orders/{id}/bank-transfer` | ✔ | Upload the bank transfer receipt (multipart) |
| – | `GET /sadad/get_info`, `POST /sadad/save_info` | ✔ | **Existing** SADAD customer details (used before SADAD checkout) |

Endpoints 2–6, 9, 10, 13, 14 and 20 only work while the mode is `main_source`. Otherwise they return `403 BUSINESS_MODE_DISABLED`. Order history, details, cancel, payment retry, receipt upload and the cart read/remove endpoints work in every mode, so customers can always see and manage what they already have.

---

## 1. App launch: business config

### `GET /app/business-config`
Public; no token needed. Call it on **every app launch, before the home screen is shown**, and again when the app comes back to the foreground after more than ~10 minutes.

**Response: Main Source mode**
```json
{
  "message": "Business config fetched successfully",
  "data": {
    "mode": "main_source",
    "main_source_enabled": true,
    "stations_enabled": false,
    "distributors_enabled": false,
    "main_sources": [
      {
        "id": 1,
        "name_en": "UFC Main Source",
        "name_ar": "المصدر الرئيسي",
        "name_ur": null,
        "icon": "https://.../main_source_images/icon.png",
        "photo": "https://.../main_source_images/photo.jpg",
        "phone": "0500000000",
        "email": "main@ufc-app.com",
        "supports_delivery": true,
        "supports_pickup": false,
        "payment_methods": ["CASH", "SADAD", "MADA", "WALLET"]
      }
    ]
  }
}
```

**Response: marketplace mode** (today's behaviour; `main_sources` is empty)
```json
{
  "message": "Business config fetched successfully",
  "data": {
    "mode": "marketplace",
    "main_source_enabled": false,
    "stations_enabled": true,
    "distributors_enabled": true,
    "main_sources": []
  }
}
```

| Field | Meaning |
|---|---|
| `mode` | `main_source` or `marketplace`. Drive the home screen from this. |
| `stations_enabled` / `distributors_enabled` | Which marketplace cards to show (one or both). Always `false` in Main Source mode. |
| `main_sources[]` | Active Main Sources (usually one). `payment_methods` is what customers can use for that source: any of `CASH`, `SADAD`, `MADA`, `WALLET`, `BANK`. `supports_delivery` / `supports_pickup` can be ignored for now, because the delivery method is hidden. |

**App behaviour:**
- Store the response in a `BusinessConfigCubit`, and cache the last value in SharedPreferences (e.g. `business_config`).
- If the call fails (no network), use the cached value. If there is none, default to `marketplace` with both cards. That matches the backend defaults.
- Whenever **any** create call (add to cart, quote, place order, station `place_order`, distributor `place_order`, …) returns **403** with `code == "BUSINESS_MODE_DISABLED"`:
  1. Show the `message`.
  2. Fetch `/app/business-config` again.
  3. Go back to the home screen, which will now render the other mode.

---

## 2. Home and catalogue

### Main Source home (mode = `main_source`)
Replace the Station/Distributor cards with a Main Source home:
- A header with the source name, icon and photo. If there are several sources, show one section per source.
- **Categories** as horizontal chips or a grid (from `/main-source/home`).
- A **product grid** (from `/main-source/products`) with search, a category filter, sorting, pull-to-refresh and infinite scroll.
- The **Products tab** (`CategoryScreen`) shows the same Main Source catalogue. The **Cart tab** shows only the Main Source cart, without the Station/Distributor switch.

### Marketplace home (mode = `marketplace`)
Keep `FeedHomePage` as it is, but show only the enabled cards:
- `stations_enabled` → "Buy from Station"
- `distributors_enabled` → "Buy from Distributor"
- If only one is enabled, skip the choice and open that flow directly.

### `GET /main-source/home`
Public. Query: `products_limit` (optional, default 10).

```json
{
  "message": "Main source home fetched successfully",
  "data": {
    "main_sources": [
      {
        "id": 1,
        "name_en": "UFC Main Source",
        "name_ar": "المصدر الرئيسي",
        "name_ur": null,
        "description_en": null,
        "description_ar": null,
        "icon": null,
        "photo": null,
        "phone": "0500000000",
        "email": "main@ufc-app.com",
        "delivery_fee": 20,
        "payment_methods": ["CASH", "SADAD", "MADA", "WALLET"],
        "categories": [
          {
            "id": 3,
            "main_source_id": 1,
            "name_en": "Feed",
            "name_ar": "أعلاف",
            "name_ur": null,
            "image": null,
            "products_count": 1
          }
        ]
      }
    ],
    "latest_products": [ /* same product object as GET /main-source/products */ ]
  }
}
```
`delivery_fee` is the delivery fee charged on every order of that source, before delivery VAT.

### `GET /main-sources`
Public. Returns the same source objects as `home`, without `categories`.

### `GET /main-source/categories`
Public. Query: `main_source_id` (optional; without it, categories of all active sources are returned).
```json
{
  "message": "Categories fetched successfully",
  "data": [
    { "id": 3, "main_source_id": 1, "name_en": "Feed", "name_ar": "أعلاف", "name_ur": null, "image": null, "products_count": 1 }
  ]
}
```

### `GET /main-source/products`
Public. Without `main_source_id` it returns products of **all** active Main Sources.

| Query | Type | Notes |
|---|---|---|
| `main_source_id` | int | optional |
| `category_id` | int | optional |
| `search` | string | name in en / ar / ur |
| `in_stock` | 0/1 | only products that can be bought now |
| `sort` | `newest`, `price_asc`, `price_desc`, `name` | default is the admin's order |
| `page`, `limit` | int | default `limit` 20, max 100 |

```json
{
  "message": "Products fetched successfully",
  "data": {
    "current_page": 1,
    "data": [
      {
        "id": 12,
        "main_source_id": 1,
        "main_source": { "id": 1, "name_en": "UFC Main Source", "name_ar": "المصدر الرئيسي", "name_ur": null, "icon": null },
        "category": { "id": 3, "name_en": "Feed", "name_ar": "أعلاف", "name_ur": null },
        "name_en": "Barley",
        "name_ar": "شعير",
        "name_ur": null,
        "sku": null,
        "image": "https://.../main_source_products/barley.png",
        "images": ["https://.../main_source_products/barley.png"],
        "min_price": 100,
        "max_price": 100,
        "in_stock": true,
        "variants": [
          { "id": 21, "size": "40 KG", "price": 100, "original_price": 110, "stock": 10, "is_available": true }
        ]
      }
    ],
    "last_page": 1,
    "per_page": 20,
    "total": 1
  }
}
```

**Product fields:**
- `variants` are the sizes or units. Each has its own `price`, `stock` and `is_available`. **The cart and checkout always use `variant.id`.**
- `original_price` is optional. When it is higher than `price`, show it struck through as a discount.
- `in_stock` is `true` when at least one variant can be bought. `min_price` / `max_price` are for a "from 100 SAR" label.
- When a variant has `is_available: false`, show it as "Out of stock" and disable "Add to cart".

### `GET /main-source/products/{id}`
Public. Returns the same object as above plus `description_en`, `description_ar` and `description_ur`. Returns **404** when the product is hidden: inactive, or its category or source is inactive.

---

## 3. Cart

A Main Source cart is stored on the server, like the distributor cart. **One cart holds products of one Main Source only.**

### `GET /main-source/cart`
```json
{
  "message": "Cart fetched successfully",
  "data": {
    "main_source": { "id": 1, "name_en": "UFC Main Source", "name_ar": "المصدر الرئيسي", "name_ur": null, "icon": null },
    "items": [
      {
        "id": 27,
        "product_id": 12,
        "variant_id": 21,
        "product_name_en": "Barley",
        "product_name_ar": "شعير",
        "product_name_ur": null,
        "image": "https://.../barley.png",
        "size": "40 KG",
        "unit_price": 100,
        "original_price": 110,
        "quantity": 2,
        "total": 200,
        "stock": 10,
        "is_available": true
      }
    ],
    "items_count": 1,
    "quantity": 2,
    "subtotal": 200,
    "has_unavailable_items": false
  }
}
```
- `id` is the **cart line id**, used by update and delete. Prices are live, so they can change if an admin edits the product.
- A line with `is_available: false` means the product was disabled or there is not enough stock (`stock` < `quantity`). Show a warning on the line. `subtotal` only counts available lines.
- `main_source` is `null` when the cart is empty.

### `GET /main-source/cart/count`
```json
{ "message": "Cart count fetched successfully", "data": { "items": 1, "quantity": 4 } }
```

### `POST /main-source/cart/add`
| Field | Type | Required | Notes |
|---|---|---|---|
| `variant_id` | int | ✔ | the size to buy |
| `quantity` | int | – | default 1; adds to the existing line of the same variant |
| `replace_cart` | bool | – | `true` = empty the cart first (see 409 below) |

```json
{ "variant_id": 21, "quantity": 2 }
```
Returns the full cart (same as `GET /main-source/cart`).

**Errors:**
- **409 `MIXED_MAIN_SOURCE_CART`:** the cart has products of another Main Source. Ask the user *"Your cart has products from {cart_main_source.name}. Clear it and add this product?"*. If they agree, call again with `"replace_cart": true`.
  ```json
  { "status": "fail", "code": "MIXED_MAIN_SOURCE_CART",
    "message": "Your cart has products from another Main Source. Clear the cart to add this product.",
    "cart_main_source": { "id": 1, "name_en": "UFC Main Source", "name_ar": "المصدر الرئيسي", "name_ur": null } }
  ```
- **422 `OUT_OF_STOCK`:** `{"code":"OUT_OF_STOCK","message":"Only 10 left in stock","available_quantity":10}`
- **422 `PRODUCT_UNAVAILABLE`:** the product or size is no longer sold.

### `PUT /main-source/cart/{id}`
Body `{ "quantity": 4 }`. Returns the cart. Can return `OUT_OF_STOCK` / `PRODUCT_UNAVAILABLE`.

### `DELETE /main-source/cart/{id}` and `DELETE /main-source/cart/clear`
Both return the cart.

### "Buy now" without the cart
"Buy now" on the product page does **not** use the cart. Send `variant_id` + `quantity` to the quote and order endpoints (section 4) and the cart stays untouched.

---

## 4. Checkout: location and payment

### 4.1 Screen layout (new `MainSourceCheckoutPage`)
1. **Delivery location card (required).** Delivery-method cards, plate number and delivery date are **hidden**.
2. **Order summary:** items, subtotal, discount, VAT, delivery fee, delivery VAT, total. All values come from the quote.
3. **Coupon field.** Same widget as stations, but the code is sent to the quote.
4. **Payment:** a wallet checkbox, then radio buttons for the methods in `payment_methods`. Same widget and UX as `FeedCheckoutPaymentMethod`, plus a **Bank Transfer** option when `BANK` is listed.
5. **Note** (optional) and the **Place order** button.

### 4.2 Location (every Main Source checkout)
- When the checkout opens, request location permission and take the **current GPS position** (`AppLocation.determinePosition` / the `location` package).
- Reverse-geocode it (`placemarkFromCoordinates`, as `FeedAddressMapScreen` does) to get a readable address and city.
- Show the card *"Deliver to: {address}"* with a **"Change on map"** button.
- "Change on map" opens a full-screen map with a draggable pin, starting at the current position. On confirm, return `{latitude, longitude, address, city}` to the checkout with `Navigator.pop(result)`. Reuse the map, pin and reverse-geocode code of `FeedAddressMapScreen`, but **do not** call `POST /address`, because the location is not saved in the address book.
- If permission is denied or GPS fails, open the map picker straight away, centred on Riyadh (24.774265, 46.738586), and ask the user to place the pin.
- The **Place order** button stays disabled until there is a location.
- Get a fresh location on every checkout; don't reuse a location from a previous order.
- The delivery fee is a flat fee per Main Source, so it does not change with the location. Sending the location to the quote is still recommended.

### 4.3 `POST /main-source/orders/quote`
Call it when the checkout opens, and again whenever the wallet checkbox, payment method, coupon or location changes. Nothing is saved.

| Field | Type | Notes |
|---|---|---|
| `latitude`, `longitude` | number | optional for the quote |
| `use_wallet` | bool | wallet checkbox |
| `payment_method` | string | optional; `WALLET` also applies the wallet |
| `coupon_code` | string | optional |
| `delivery_coupon_code` | string | optional (coupon on the delivery fee) |
| `variant_id`, `quantity` | int | **"Buy now" only**; without them the cart is used |

```json
{ "latitude": 24.7136, "longitude": 46.6753, "use_wallet": true }
```
```json
{
  "message": "Quote calculated successfully",
  "data": {
    "main_source": { "id": 1, "name_en": "UFC Main Source", "name_ar": "المصدر الرئيسي", "name_ur": null, "icon": null },
    "items": [
      { "cart_item_id": 29, "product_id": 12, "variant_id": 21, "product_name": "Barley", "product_name_ar": "شعير",
        "size": "40 KG", "unit_price": 100, "quantity": 2, "total": 200 }
    ],
    "subtotal": 200,
    "coupon_amount": 0,
    "vat_percentage": 15,
    "vat_amount": 30,
    "delivery_fee": 20,
    "delivery_coupon_amount": 0,
    "delivery_vat": 3,
    "total": 220,
    "total_with_vat": 253,
    "wallet_balance": 50,
    "wallet_applied": 50,
    "payable_amount": 203,
    "payment_methods": ["CASH", "SADAD", "MADA", "WALLET"],
    "sadad_min_amount": 50
  }
}
```

**How the totals are calculated** (same as station orders):
- `subtotal` = Σ price × quantity
- items after discount = `subtotal − coupon_amount`
- `vat_amount` = items after discount × `vat_percentage` %
- `delivery_vat` = (`delivery_fee` − `delivery_coupon_amount`) × delivery VAT %
- `total_with_vat` = items after discount + delivery fee after discount + `vat_amount` + `delivery_vat` (**the amount to show as "Total"**)
- `wallet_applied` = the part of the total paid from the wallet (0 when the checkbox is off)
- `payable_amount` = `total_with_vat − wallet_applied` (**the amount still to pay** with Cash / SADAD / Mada / Bank Transfer)

**Display rules:**
- Show only the methods in `payment_methods`.
- Show the wallet checkbox only when `WALLET` is in `payment_methods` and `wallet_balance > 0`, with the label "Use wallet balance ({wallet_balance} SAR)".
- When the wallet does not cover the whole total, show "Remaining {payable_amount} SAR to be paid with …", as the station checkout does.
- **WALLET** as the main method can only be picked when `wallet_balance ≥ total_with_vat`.
- **SADAD** can only be picked when `payable_amount ≥ sadad_min_amount`; otherwise show it disabled with the minimum amount.

**Errors:** `CART_EMPTY`, `OUT_OF_STOCK`, `PRODUCT_UNAVAILABLE`, `INVALID_COUPON` (the response has `field`: `coupon_code` or `delivery_coupon_code`; show the message under that field), `MIXED_MAIN_SOURCE_CART`.

### 4.4 `POST /main-source/orders` (place order)

| Field | Type | Required | Notes |
|---|---|---|---|
| `payment_method` | `CASH` \| `SADAD` \| `MADA` \| `WALLET` \| `BANK` | ✔ | only a method listed in `payment_methods` |
| `latitude` | number | ✔ | −90..90 |
| `longitude` | number | ✔ | −180..180 |
| `address` | string | recommended | reverse-geocoded text, max 500 |
| `city` | string | – | |
| `landmark` | string | – | optional free text from the user |
| `use_wallet` | bool | – | wallet checkbox (part payment) |
| `coupon_code` / `delivery_coupon_code` | string | – | |
| `note` | string | – | max 1000 |
| `variant_id` + `quantity` | int | – | "Buy now" only |
| `force` | bool | – | `true` = skip cart lines that are out of stock (after the user agrees) |
| `platform` | `MOBILE` | – | default `MOBILE` |

Do **not** send `order_type`, `address_id`, `booking_date_time` or a plate number. Every Main Source order is a delivery to the given location.

```json
{
  "payment_method": "CASH",
  "use_wallet": false,
  "latitude": 24.7136,
  "longitude": 46.6753,
  "address": "King Fahd Rd, Al Olaya, Riyadh 12211",
  "city": "Riyadh",
  "note": "Call before arriving"
}
```

**Response** (the same for every method; `payment` changes):
```json
{
  "message": "Order placed successfully",
  "data": {
    "order": {
      "id": 105,
      "order_number": "MS-261119-000105",
      "order_status": "PENDING",
      "payment_method": "CASH",
      "payment_status": "PENDING",
      "main_source": { "id": 1, "name_en": "UFC Main Source", "name_ar": "المصدر الرئيسي", "name_ur": null, "icon": null, "phone": "0500000000" },
      "delivery": { "latitude": 24.7136, "longitude": 46.6753, "address": "King Fahd Rd, Al Olaya, Riyadh 12211", "city": "Riyadh", "landmark": null },
      "items": [
        { "id": 105, "product_id": 12, "variant_id": 21, "product_name": "Barley", "product_name_ar": "شعير",
          "size": "40 KG", "image": "https://.../barley.png", "unit_price": 100, "quantity": 2, "total": 200 }
      ],
      "subtotal": 200,
      "coupon_code": null,
      "coupon_amount": 0,
      "delivery_fee": 20,
      "delivery_coupon_amount": 0,
      "vat_amount": 30,
      "delivery_vat": 3,
      "total_with_vat": 253,
      "wallet_amount_used": 0,
      "payable_amount": 253,
      "go_pay": null,
      "bank_transfer": null,
      "bank_accounts": [],
      "can_upload_receipt": false,
      "note": "Call before arriving",
      "can_cancel": true,
      "can_pay": false,
      "status_history": [
        { "from_status": null, "to_status": "PENDING", "note": "Order placed", "created_at": "2026-11-19T20:32:46.000000Z" }
      ],
      "created_at": "2026-11-19T20:32:46.000000Z"
    },
    "payment": { "method": "CASH" }
  }
}
```
On success the cart lines that were ordered are removed from the cart (not for "Buy now"), and the customer gets a push notification "Order Placed Successfully".

### 4.5 Flows per payment method

#### CASH
- Response: `payment = { "method": "CASH" }`, `payment_status = "PENDING"`.
- Go to the success page. The customer pays on delivery.

#### WALLET (full payment)
- Send `payment_method: "WALLET"`. The balance must cover `total_with_vat`, otherwise you get `422 INSUFFICIENT_WALLET_BALANCE` (with `wallet_balance` and `total`).
- Response: `payment_method = "WALLET"`, `payment_status = "PAID"`, `wallet_amount_used = total_with_vat`, `payable_amount = 0`.
- Refresh the user's wallet balance afterwards (`AuthCubit.autoLogin()` / `who_am_i`), as the station flow does.
- If the wallet checkbox covers the whole total while another method is selected, the server also turns the order into a paid `WALLET` order. Always read `data.order.payment_method` / `payment_status` from the response.

#### Wallet + another method (part payment)
- Send `use_wallet: true` and `payment_method` = `CASH`, `SADAD`, `MADA` or `BANK`.
- The wallet pays `wallet_amount_used` straight away, and the chosen method pays `payable_amount`.
- If the order is cancelled or rejected later, the wallet part is **refunded automatically** to the customer's wallet.

#### SADAD
1. **Before placing the order**, make sure the customer has SADAD details, using the existing endpoints and `SadadUserInfoCubit`:
   - `GET /sadad/get_info`. If there are none, show the existing SADAD info form.
   - `POST /sadad/save_info` with `customer_full_name`, `customer_mobile_number` (9 digits starting with 5), and optionally `customer_id_number` and `customer_id_type`.
2. `payable_amount` must be ≥ `sadad_min_amount` (currently 50 SAR).
3. Place the order with `payment_method: "SADAD"`. Response:
   ```json
   "payment": {
     "method": "SADAD",
     "go_pay": { "bill_number": "ms_106", "sadad_number": "987654321012", "amount": 138, "expire_date": "2026-11-26" }
   }
   ```
   The same `go_pay` object is also inside `data.order.go_pay`, and in the order details later.
4. The success page shows **SADAD number** and **bill number**, each with a copy button (same as `FeedOrderSuccessPage`), plus the amount and the expiry date (7 days).
5. The order stays `payment_status: "PENDING"` until the bill is paid. When SADAD confirms the payment, the order becomes `PAID` and the customer gets a push notification "Payment Confirmed". Refresh the order details when that push arrives or the screen opens.

**Errors:**
- `SADAD_INFO_REQUIRED`: open the SADAD info form.
- `SADAD_MIN_AMOUNT` (has `sadad_min_amount`): the amount is too low.
- `SADAD_GENERATION_FAILED`: the bill could not be created. No order was created; let the user try again or pick another method.

#### MADA
1. Place the order with `payment_method: "MADA"` (optionally with `use_wallet: true`). The server **always** creates the HyperPay checkout. Unlike the station flow, there is no need to send `platform: DASHBOARD`.
   ```json
   "payment": { "method": "MADA", "checkout_id": "8AC7A4A1...", "integrity": "sha384-..." }
   ```
   The order is created with `payment_status: "PENDING"`, and `can_pay: true`.
2. Open the existing **`MadaPaymentScreen(checkoutId: checkout_id, integrity: integrity)`**, which is the WebView with the OPPWA widget.
3. When the screen closes, call **`GET /main-source/payments/verify/{checkoutId}`**. Use this endpoint instead of the station `/verify_payment/{id}`.
   ```json
   { "message": "Payment successful",
     "data": { "payment_status": "PAID", "order_id": 105, "order_number": "MS-261119-000105", "order_payment_status": "PAID" } }
   ```
   `payment_status` is one of:
   - `PAID`: show the success page.
   - `PENDING`: the bank is still processing. Show "Payment is being processed" and let the user check again from the order details.
   - `FAILED`: show "Payment failed" with **Try again**.
4. **Try again:** call `POST /main-source/orders/{id}/pay`. It returns a new checkout, so open `MadaPaymentScreen` again with the new values.
   ```json
   { "message": "Payment started",
     "data": { "order_id": 105, "order_number": "MS-261119-000105", "method": "MADA", "checkout_id": "8AC7A4A2...", "integrity": "sha384-..." } }
   ```
   Allowed only while `can_pay` is `true` (a MADA order whose payment is `PENDING` or `FAILED` and that is not cancelled or completed). Otherwise you get `422 PAYMENT_NOT_ALLOWED`.
5. The order details screen shows a **"Pay now"** button when `can_pay` is `true`, which runs steps 4, 2 and 3. A customer who closes the app in the middle can still pay later.

**Errors:** `PAYMENT_GATEWAY_ERROR` means HyperPay could not be reached. When it happens on place order, no order is created; when it happens on verify, try again.

#### BANK (bank transfer)
Offered only when `BANK` is in `payment_methods`. The admin enables it per Main Source and must add at least one active bank account.

1. Place the order with `payment_method: "BANK"` (optionally with `use_wallet: true`). The order is created with `payment_status: "PENDING"`, and the response lists the accounts to transfer to:
   ```json
   "payment": {
     "method": "BANK",
     "bank_accounts": [
       { "id": 34, "bank_name": "Al Rajhi Bank", "account_holder_name": "UFC", "account_number": "608010167519",
         "iban": "SA0380000000608010167519", "swift_code": "RJHISARI", "branch": null, "currency": "SAR", "notes": null }
     ]
   }
   ```
   The same list is in `data.order.bank_accounts`, and `data.order.can_upload_receipt` is `true`.
2. Show a **"Transfer {payable_amount} SAR"** screen: one card per account with bank name, account holder, IBAN and account number (each with a copy button), the order number as the transfer reference, and an **Upload receipt** button. The customer can close the app and come back later: **order details return the same `bank_accounts` and `can_upload_receipt: true`** until a receipt is uploaded.
3. **Upload the receipt:** `POST /main-source/orders/{id}/bank-transfer`, sent as `multipart/form-data`:

   | Field | Type | Required | Notes |
   |---|---|---|---|
   | `bank_account_id` | int | ✔ | the account the customer paid into (one of `bank_accounts`) |
   | `receipt_image` | file | ✔ | jpg, jpeg, png, webp, heic or pdf; max 5 MB (camera or gallery) |
   | `amount` | number | ✔ | amount transferred; pre-fill with `payable_amount` |
   | `reference_number` | string | – | bank reference, max 100 |
   | `transfer_date` | `YYYY-MM-DD` | – | pre-fill with today |

   ```dart
   FormData.fromMap({
     'bank_account_id': accountId,
     'amount': payableAmount,
     'reference_number': reference,
     'transfer_date': DateFormat('yyyy-MM-dd').format(date),
     'receipt_image': await MultipartFile.fromFile(file.path, filename: file.name),
   });
   ```
   Response: the updated order (same object as order details):
   ```json
   {
     "message": "Receipt uploaded",
     "data": {
       "id": 148,
       "order_number": "MS-261121-000148",
       "payment_method": "BANK",
       "payment_status": "PENDING_VERIFICATION",
       "bank_transfer": {
         "id": 22,
         "status": "pending",
         "amount": 138,
         "reference_number": "TRX123456",
         "transfer_date": "2026-11-21",
         "receipt_url": "https://.../main_source_bank_receipts/148/receipt.jpg?X-Amz-Signature=...",
         "rejection_reason": null,
         "bank_account": { "id": 34, "bank_name": "Al Rajhi Bank", "account_holder_name": "UFC", "account_number": "608010167519",
                           "iban": "SA0380000000608010167519", "swift_code": "RJHISARI", "branch": null, "currency": "SAR", "notes": null },
         "created_at": "2026-11-21T11:56:53.000000Z",
         "reviewed_at": null
       },
       "bank_accounts": [],
       "can_upload_receipt": false,
       "can_cancel": true,
       "status_history": [
         { "from_status": null, "to_status": "PENDING", "note": "Order placed", "created_at": "2026-11-21T11:56:53.000000Z" },
         { "from_status": "PENDING", "to_status": "PENDING", "note": "Bank transfer receipt uploaded", "created_at": "2026-11-21T11:56:53.000000Z" }
       ]
     }
   }
   ```
   `receipt_url` is a private link valid for 60 minutes; reload the order to get a fresh one.
4. **Admin review** (dashboard):
   - **Approved:** `payment_status` → `PAID`, `bank_transfer.status` → `approved`. Push `main_source_transfer_approved`.
   - **Rejected:** `payment_status` → `REJECTED`, `bank_transfer.status` → `rejected`, `bank_transfer.rejection_reason` is set, `can_upload_receipt` is `true` again and `bank_accounts` are returned again. Push `main_source_transfer_rejected`. Show the reason and an **Upload new receipt** button; it calls the same endpoint (step 3).
5. While `payment_status` is `PENDING_VERIFICATION`, show "Your transfer is being verified" and the uploaded receipt; a second upload is refused (`422 RECEIPT_NOT_ALLOWED`) until the admin rejects the first one.

**States of a bank transfer order:**

| `payment_status` | `bank_transfer.status` | `can_upload_receipt` | Show |
|---|---|---|---|
| `PENDING` | – (`bank_transfer` is `null`) | `true` | Bank accounts + **Upload receipt** |
| `PENDING_VERIFICATION` | `pending` | `false` | "Transfer is being verified" + receipt |
| `REJECTED` | `rejected` | `true` | Rejection reason + bank accounts + **Upload new receipt** |
| `PAID` | `approved` | `false` | Paid |

**Cancelling:** a bank order can be cancelled while it is not `PAID` (`can_cancel`). If the customer already transferred money, the refund is handled by UFC outside the app; show a warning before cancelling when `bank_transfer` is not `null`.

**Errors:** `RECEIPT_NOT_ALLOWED` (no receipt expected now), `UPLOAD_FAILED` (storage problem; retry), validation 400 on `receipt_image` (missing, wrong type or larger than 5 MB) or `bank_account_id` (not one of the listed accounts).

### 4.6 Other checkout errors
| Code | When | What to do |
|---|---|---|
| `LOCATION_REQUIRED` | no `latitude` / `longitude` | open the map picker |
| `PAYMENT_METHOD_DISABLED` | the method was switched off by the admin (response has the current `payment_methods`) | refresh the quote and ask the user to pick again |
| `OUT_OF_STOCK` | some lines can't be delivered in the requested quantity; `items[]` lists them with `requested_quantity`, `available_quantity`, `reason` (`out_of_stock` or `unavailable`) | show the list; offer **Remove unavailable items** (retry with `force: true`) or go back to the cart to change quantities. This is the same UX as the distributor checkout. |
| `CART_EMPTY` | nothing to order | go back to the cart |

Example `OUT_OF_STOCK`:
```json
{ "status": "fail", "code": "OUT_OF_STOCK", "message": "Some items are not available in the requested quantity",
  "items": [ { "cart_item_id": 32, "variant_id": 21, "product_name": "Barley", "product_name_ar": "شعير",
               "requested_quantity": 5, "available_quantity": 3, "reason": "out_of_stock" } ] }
```

---

## 5. Orders

Main Source orders are stored apart from station and distributor orders. In **My Orders**, add a **"Main Source"** tab next to the existing list, which keeps using `get_user_orders`. Show the tab when there are Main Source orders or the mode is `main_source`, so older orders of every business stay visible after the mode changes.

### `GET /main-source/orders`
Query: `page`, `limit` (default 15), `status` (optional: one status or an array).
```json
{
  "message": "Orders fetched successfully",
  "data": {
    "current_page": 1,
    "data": [
      {
        "id": 107,
        "order_number": "MS-261119-000107",
        "order_status": "PENDING",
        "payment_method": "CASH",
        "payment_status": "PENDING",
        "total_with_vat": 253,
        "payable_amount": 213,
        "items_count": 1,
        "image": "https://.../barley.png",
        "main_source": { "id": 1, "name_en": "UFC Main Source", "name_ar": "المصدر الرئيسي", "name_ur": null, "icon": null },
        "created_at": "2026-11-19T20:32:47.000000Z"
      }
    ],
    "last_page": 1,
    "total": 1
  }
}
```

### `GET /main-source/orders/{id}`
Returns the order object shown in 4.4. Other customers' orders return **404**.

| Field | Use |
|---|---|
| `order_number` | Show as the order reference (`MS-YYMMDD-000123`) |
| `delivery` | The pinned location; show the address and a small map or "Open in Maps" |
| `status_history[]` | Timeline, oldest first (`from_status`, `to_status`, `note`, `created_at`). Only customer-facing entries (see below) |
| `wallet_amount_used`, `payable_amount` | Payment breakdown |
| `go_pay` | SADAD number and bill number (SADAD orders) |
| `can_cancel` | Show the **Cancel order** button |
| `can_pay` | Show the **Pay now** button (MADA retry, 4.5) |
| `bank_transfer` | Latest receipt of a BANK order (`status`, `amount`, `reference_number`, `transfer_date`, `receipt_url`, `rejection_reason`, `bank_account`), or `null` |
| `bank_accounts` | Accounts to transfer to; filled only while a BANK order needs a receipt (`can_upload_receipt`), otherwise `[]` |
| `can_upload_receipt` | Show **Upload receipt** / **Upload new receipt** (4.5 BANK) |

**Order status (`order_status`):**

| Value | Show as |
|---|---|
| `PENDING` | Order received |
| `SCHEDULED` | Scheduled |
| `PROCESSING` | Being prepared |
| `SHIPPED` | On the way |
| `COMPLETED` | Delivered |
| `CANCELLED` | Cancelled |
| `REJECTED` | Rejected |

**Payment status (`payment_status`):**

| Value | Meaning |
|---|---|
| `PENDING` | Not paid yet (cash on delivery, an unpaid SADAD bill, or Mada not finished) |
| `PAID` | Paid |
| `FAILED` | Online payment failed (Mada: use **Pay now**) |
| `PENDING_VERIFICATION` | Bank transfer receipt uploaded, waiting for the admin |
| `REJECTED` | Bank transfer receipt rejected; the customer can upload a new one |
| `REFUNDED` | Refunded by the admin |

**Status history (`status_history`)** contains only what the customer should see:
- every real status change (`from_status` ≠ `to_status`, or `from_status` = `null` for the first entry); for changes made by UFC staff `note` is `null`,
- payment events, which keep the status (`from_status` = `to_status`) and carry a short `note`.

Internal entries (distributor assignments, notes typed by admins) are never returned. Possible `note` values, in English (translate them in the app, fall back to the text):

| `note` | When |
|---|---|
| `Order placed` | first entry |
| `Paid by wallet` | wallet covered the whole order |
| `Payment received` | SADAD or Mada payment confirmed |
| `Payment failed` | SADAD bill cancelled / Mada failed |
| `Bank transfer receipt uploaded` | customer uploaded a receipt |
| `Bank transfer approved` | admin approved the transfer |
| `Bank transfer rejected: {reason}` | admin rejected the transfer |
| the customer's own cancel reason | customer cancelled with a `reason` |
| `null` | status changed by UFC staff (show the status name only) |

### `POST /main-source/orders/{id}/cancel`
Body (optional): `{ "reason": "Changed my mind" }`.
- Allowed only while `can_cancel` is `true`: the order is `PENDING` or `SCHEDULED` and **not paid**. Otherwise you get `422 ORDER_NOT_CANCELLABLE`.
- The stock is returned and any wallet amount used is refunded to the wallet automatically.
- Returns the updated order.

### `POST /main-source/orders/{id}/reorder`
Puts the items that are still sold back into the cart (replacing a cart from another source) and returns:
```json
{ "message": "Items added to cart",
  "data": { "cart": { /* same as GET /main-source/cart */ }, "skipped_items": [] } }
```
`skipped_items` lists the product names that are no longer available. When it's not empty, the message is "Some items are no longer available". Then open the cart.

### Push notifications
These are sent through FCM with the same `user_meta_data.fcm` tokens as today. Each one is also stored in the in-app notifications list (`notifications` table).

| `data.type` | When |
|---|---|
| `main_source_order_placed` | Order placed |
| `main_source_order_status` | Status changed by the admin or the distributor (title "Order Status Updated") |
| `main_source_payment_confirmed` | SADAD or Mada payment confirmed |
| `main_source_transfer_approved` | Bank transfer approved |
| `main_source_transfer_rejected` | Bank transfer rejected (the body contains the reason; open the order to upload a new receipt) |

The data payload also contains `main_source_order_id`, so a tap on the notification can open the order details.

---

## 6. Errors and codes

| HTTP | `code` | Endpoint(s) | Meaning / app action |
|---|---|---|---|
| 400 | (none; `errors` object) | all | Validation; show the field messages |
| 401 | – | auth endpoints | Not logged in; existing login handling |
| 403 | `BUSINESS_MODE_DISABLED` | catalogue, cart add/update, quote, place order, reorder (and the station/distributor create endpoints) | Mode changed; show `message`, refetch business-config, go home |
| 404 | – | product, order, cart line, verify | Not found or not yours |
| 409 | `MIXED_MAIN_SOURCE_CART` | cart add | Ask to replace the cart, then retry with `replace_cart: true` |
| 422 | `PRODUCT_UNAVAILABLE` | cart, quote, order | Product or size no longer sold |
| 422 | `OUT_OF_STOCK` | cart, quote, order | Not enough stock (`available_quantity` or `items[]`) |
| 422 | `CART_EMPTY` | quote, order | Empty cart |
| 422 | `LOCATION_REQUIRED` | order | Pick the location |
| 422 | `INVALID_COUPON` | quote, order | Show `message` under `field` |
| 422 | `PAYMENT_METHOD_DISABLED` | order | Refresh the quote; `payment_methods` included |
| 422 | `INSUFFICIENT_WALLET_BALANCE` | order | Wallet doesn't cover the total |
| 422 | `SADAD_INFO_REQUIRED` | order | Open the SADAD info form |
| 422 | `SADAD_MIN_AMOUNT` | order | Amount below `sadad_min_amount` |
| 422 | `SADAD_GENERATION_FAILED` | order | SADAD bill failed; no order created |
| 422 | `PAYMENT_GATEWAY_ERROR` | order, pay, verify | HyperPay not reachable; retry |
| 422 | `PAYMENT_NOT_ALLOWED` | pay | Order can't be paid online any more |
| 422 | `ORDER_NOT_CANCELLABLE` | cancel | Hide the cancel button |
| 422 | `RECEIPT_NOT_ALLOWED` | bank-transfer | No receipt expected now (already waiting for review, paid, or closed); reload the order |
| 422 | `UPLOAD_FAILED` | bank-transfer | The receipt could not be stored; retry |

Examples:
```json
{ "status": "fail", "code": "BUSINESS_MODE_DISABLED", "business": "main_source", "message": "Main Source is not accepting new orders at the moment" }
{ "status": "fail", "code": "INSUFFICIENT_WALLET_BALANCE", "message": "Your wallet balance is not enough for this order", "wallet_balance": 100, "total": 138 }
{ "status": "fail", "code": "SADAD_MIN_AMOUNT", "message": "The amount to pay by SADAD must be at least 50.00 SAR", "sadad_min_amount": 50 }
{ "status": "fail", "code": "PAYMENT_METHOD_DISABLED", "message": "This payment method is not available for this order", "payment_methods": ["CASH", "SADAD", "WALLET"] }
{ "message": "Required fields are missing", "errors": { "latitude": ["The latitude field must be between -90 and 90."] } }
```

`AppInterceptor` already turns `message` into the `DioException` error. To branch on `code`, read `e.response?.data['code']` in the Main Source data sources and map it to a typed exception (e.g. `MainSourceException(code, message, data)`).

### 6.1 Translated error texts
`message` is English only. Show the app's own text for each `code`, in the user's language; fall back to `message` for unknown codes. Values in `{}` come from the response.

| `code` | English | Arabic |
|---|---|---|
| `BUSINESS_MODE_DISABLED` | This service is not accepting new orders at the moment. | هذه الخدمة لا تستقبل طلبات جديدة حالياً. |
| `MIXED_MAIN_SOURCE_CART` | Your cart has products from another Main Source. Clear it and add this product? | سلتك تحتوي على منتجات من مصدر رئيسي آخر. هل تريد إفراغها وإضافة هذا المنتج؟ |
| `PRODUCT_UNAVAILABLE` | This product is no longer available. | هذا المنتج لم يعد متوفراً. |
| `OUT_OF_STOCK` | Only {available_quantity} left in stock. / Some items are not available in the requested quantity. | الكمية المتوفرة {available_quantity} فقط. / بعض المنتجات غير متوفرة بالكمية المطلوبة. |
| `CART_EMPTY` | Your cart is empty. | سلة المشتريات فارغة. |
| `LOCATION_REQUIRED` | Choose the delivery location on the map. | حدد موقع التوصيل على الخريطة. |
| `INVALID_COUPON` | This coupon code can't be used. | لا يمكن استخدام رمز الخصم هذا. |
| `PAYMENT_METHOD_DISABLED` | This payment method is not available. Please choose another one. | طريقة الدفع هذه غير متاحة. يرجى اختيار طريقة أخرى. |
| `INSUFFICIENT_WALLET_BALANCE` | Your wallet balance is not enough for this order. | رصيد محفظتك لا يكفي لهذا الطلب. |
| `SADAD_INFO_REQUIRED` | Add your SADAD details to pay by SADAD. | أضف بيانات سداد للدفع عن طريق سداد. |
| `SADAD_MIN_AMOUNT` | The minimum amount for SADAD is {sadad_min_amount} SAR. | الحد الأدنى للدفع عن طريق سداد هو {sadad_min_amount} ريال. |
| `SADAD_GENERATION_FAILED` | We couldn't create the SADAD bill. Please try again or choose another payment method. | تعذر إنشاء فاتورة سداد. حاول مرة أخرى أو اختر طريقة دفع أخرى. |
| `PAYMENT_GATEWAY_ERROR` | The payment service is not available right now. Please try again. | خدمة الدفع غير متاحة حالياً. يرجى المحاولة مرة أخرى. |
| `PAYMENT_NOT_ALLOWED` | This order can't be paid online any more. | لم يعد بالإمكان دفع هذا الطلب إلكترونياً. |
| `ORDER_NOT_CANCELLABLE` | This order can no longer be cancelled. | لم يعد بالإمكان إلغاء هذا الطلب. |
| `RECEIPT_NOT_ALLOWED` | A receipt can't be uploaded for this order now. | لا يمكن رفع إيصال لهذا الطلب حالياً. |
| `UPLOAD_FAILED` | We couldn't upload the receipt. Please try again. | تعذر رفع الإيصال. يرجى المحاولة مرة أخرى. |
| HTTP 400 (validation) | Show the first message of `errors` (English) or a generic "Please check the highlighted fields." | يرجى التحقق من الحقول المحددة. |

Add the Urdu texts to `ur.json` in the same way.

---

## 7. Flutter implementation guide

Follow the structure of the distributor feature (`lib/screens/feed/`: `application` → `domain` → `infrastructure` → `presentation`, Cubits + get_it).

### 7.1 Launch and business mode
| Where | Change |
|---|---|
| **New** `application/business_config/business_config_cubit.dart` | States `Loading / Loaded(config) / Error`; `load()` calls `/app/business-config`, saves to and reads from SharedPreferences `business_config`; `isMainSource`, `stationsEnabled`, `distributorsEnabled`, `mainSources` |
| **New** `infrastructure/data_sources/main_source/main_source_data_source_impl.dart` | All endpoints of this document; `static const _base = '/api/ufc/v1';` |
| `global/shared/init/injection.dart` | `registerMainSourceModule()`: data source, repository, cubits |
| `app_widget.dart` | Add `BusinessConfigCubit` (and the Main Source cubits) to `MultiBlocProvider` |
| `global/shared/widgets/app/auto_login.dart` | Call `BusinessConfigCubit.load()` **together with** `who_am_i`, and wait for it before opening `BottomBar`. Reload on app resume after 10 min (`WidgetsBindingObserver`) |
| `application/feed_channel/feed_channel_cubit.dart` | Add a `FeedChannel.mainSource` value; when the mode is `main_source` force this channel, otherwise keep today's logic |

### 7.2 Home, products and cart tabs
| Where | Change |
|---|---|
| `presentation/home/pages/feed_home.dart` (`FeedHomePage`) | `main_source` → render the new `MainSourceHomePage`; marketplace → show only the enabled `_HomeOption` cards; open directly when only one is enabled |
| **New** `presentation/main_source/pages/main_source_home_page.dart` | Source header, category chips, product grid, search |
| **New** `presentation/main_source/pages/main_source_product_details_page.dart` | Variant selector (size chips), quantity, **Add to cart** / **Buy now** |
| `presentation/category/pages/category_screen.dart` | When the channel is `mainSource`, show the Main Source products page (as is done for `DistributorProductsPage`) |
| `presentation/product/pages/feed_cart_screen.dart` | When the channel is `mainSource`, hide `CartChannelSwitch` and show a new `MainSourceCartView` |
| Cubits | `MainSourceHomeCubit`, `MainSourceProductsCubit` (paging + filters), `MainSourceProductDetailsCubit`, `MainSourceCartCubit` (also drives the cart badge from `/cart/count`) |

### 7.3 Checkout
| Where | Change |
|---|---|
| **New** `presentation/main_source/pages/main_source_checkout_page.dart` | Location card, summary, coupon, payment, note. **No** `FeedDeliveryWidget`, `VehicleNumberWidget` or `DeliveryDatePicker` |
| **New** `presentation/main_source/pages/main_source_location_picker.dart` | Based on `profile/pages/feed_address_screen.dart` (`FeedAddressMapScreen`): GoogleMap + pin + current-location button + reverse geocoding; **returns** `{lat, lng, address, city}` with `Navigator.pop` and does not save an address |
| `MainSourceCheckoutCubit` | `quote()` (debounced on every change) and `placeOrder()`; holds the location, `useWallet`, payment option and coupon |
| Payment widget | Reuse `FeedCheckoutPaymentMethod` / `PaymentOption` (`cash, sadad, mada, wallet`), but **drive visibility from the quote's `payment_methods`**, not from `SADAD_STATUS` / `MADA_STATUS`. Cash must be visible here (in the station flow it is shown only for pickup) |
| SADAD | Reuse `SadadUserInfoCubit` and `isSadadInfoExist` before placing the order |
| Mada | Reuse `MadaPaymentScreen` (`feed_old/payment/pages/mada_payment_screen.dart`); verify with the **new** `GET /main-source/payments/verify/{checkoutId}` and check `data.payment_status == 'PAID'` (not the message text) |
| Success page | New or adapted success page: order number, payment status, SADAD number + bill number with copy buttons (as in `FeedOrderSuccessPage`), "Pay now" for MADA `FAILED` / `PENDING`, bank accounts + **Upload receipt** for BANK |
| Bank transfer | **New** `presentation/main_source/widgets/main_source_bank_transfer_section.dart`: account cards with copy buttons, receipt picker (camera / gallery / PDF, `image_picker` or `file_picker`), amount / reference / date fields, upload via multipart; state from `payment_status`, `bank_transfer`, `can_upload_receipt` (table in 4.5). The existing distributor `BankReceiptSection` / `BankAccountCard` widgets are a good starting point |

### 7.4 Orders
| Where | Change |
|---|---|
| `profile/pages/feed_my_orders_page.dart` | Add a "Main Source" tab using `GET /main-source/orders` |
| **New** `presentation/main_source/pages/main_source_order_details_page.dart` | Items, totals, delivery location, status timeline, SADAD info, bank transfer section, **Cancel** (`can_cancel`), **Pay now** (`can_pay`), **Upload receipt** (`can_upload_receipt`), **Order again** |
| Push handling | Open the Main Source order details for `type` starting with `main_source_` using `main_source_order_id` |

### 7.5 Translations
Add the keys to `assets/translations/{en,ar,ur}.json`, then regenerate:
```
dart run easy_localization:generate -S "assets/translations" -O "lib/global/shared/translations"
```
Suggested keys: `Main Source`, `Deliver to`, `Change on map`, `Confirm location`, `Pick the delivery location`, `Use wallet balance`, `Remaining amount to be paid`, `SADAD number`, `Bill number`, `Pay now`, `Payment is being processed`, `Order again`, `Your cart has products from another Main Source. Clear it and add this product?`, `Remove unavailable items`, `Bank Transfer`, `Transfer to one of these accounts`, `IBAN`, `Upload receipt`, `Upload new receipt`, `Transfer is being verified`, `Transfer rejected`, the history notes of section 5 and the error texts of 6.1.

### 7.6 QA checklist
- [ ] Main Source mode: the home screen shows categories and products; Station/Distributor cards are hidden; Products and Cart tabs show Main Source.
- [ ] Marketplace with only Stations on: no choice screen, the station flow opens directly. Same with only Distributors on. Both on: both cards shown.
- [ ] Switching the mode in the dashboard while the app is open: the next create action gets 403 `BUSINESS_MODE_DISABLED`, the app shows the message, refetches the config and lands on the new home.
- [ ] Checkout: no delivery-method UI; location from GPS; the pin can be moved; denied permission opens the map; Place order is disabled without a location.
- [ ] The quote updates when toggling the wallet, changing the method, or entering a coupon (valid and invalid).
- [ ] CASH order; WALLET full; wallet + CASH; wallet + MADA; SADAD (with and without saved SADAD info; below 50 SAR).
- [ ] BANK: accounts shown after placing the order and again after reopening the order; receipt upload (image and PDF, > 5 MB refused); "being verified" state; admin rejects → reason shown, new upload works; admin approves → Paid.
- [ ] Order history shows no assignment or internal admin notes.
- [ ] Every error code shows the translated text in Arabic and Urdu.
- [ ] Mada: success; failed then **Pay now**; closing the WebView and paying later from the order details.
- [ ] Out-of-stock dialog and "Remove unavailable items"; adding a product from another source asks to replace the cart.
- [ ] Order list and details; cancel (stock and wallet back); order again; push notifications open the right order.
- [ ] Old station and distributor orders are still visible in My Orders in Main Source mode.
- [ ] Arabic and Urdu: names use `name_ar` / `name_ur` with fallback to `name_en`.

---

## 8. Rollout notes
- **Defaults:** the backend ships with **marketplace** mode (Stations + Distributors on, Main Source off), so current app versions keep working until the admin switches the mode.
- **Older app versions:** they don't know about Main Source mode. When the admin switches to Main Source, older versions get `403 BUSINESS_MODE_DISABLED` (with a readable `message`) on station and distributor checkout. Before switching the mode in production, publish the new app version and mark it as a **forced update** in **App Updates** (the app's `getLatestUpdate` check already handles `is_force_update`).
- **Payment switches:** a Main Source offers only the methods enabled on it in the dashboard (**Main Sources → Payment & Delivery**) **and** not switched off globally in **App Settings** (`COD_STATUS`, `SADAD_STATUS`, `MADA_STATUS`, `WALLET_STATUS`). The app always follows `payment_methods` from the API.
- **Bank transfer:** part of this release. It is off by default for every Main Source; the admin enables it in **Main Sources → Payment & Delivery → Advanced** and adds an active account in the **Bank Accounts** tab. Without an active account `BANK` is not offered.

---

## 9. Open questions (product owner)
These do not block development; the current backend behaviour is noted.
1. **Browsing without login:** the catalogue endpoints are public. Should guests see the Main Source home and products (and be asked to log in at "Add to cart"), or must they log in first? The app should follow the same rule as the station catalogue today.
2. **Delivery area:** any location is accepted at checkout and the delivery fee is flat. If UFC only delivers to some cities or areas, say so; the backend can then reject locations outside the area with a new error code.
