# API Integration Status — Shop & Drive App

Base URL: `http://localhost:3000/api/customer`

---

## ⚠️ CORS Setup (Flutter Web)

Flutter web berjalan di browser yang menerapkan CORS policy. Backend harus mengizinkan cross-origin request.

**Aktifkan CORS di backend:**

```js
// Node.js / Express
const cors = require('cors');
app.use(cors({ origin: true, credentials: true }));
```

```ts
// NestJS
app.enableCors({ origin: true, credentials: true });
```

Setelah backend mengizinkan CORS, Flutter web dapat langsung request ke `localhost:3000`.

**Android emulator:** Gunakan `10.0.2.2:3000` (tidak bisa akses `localhost` host).

---

## ✅ Semua Terintegrasi (All Integrated)

| # | Endpoint | Method | Auth | Repository | Screen/Provider | Status |
|---|---|---|---|---|---|---|
| 1 | `/auth/register` | POST | None | `AuthRepository.register()` | `register_screen.dart` | ✅ |
| 2 | `/auth/login` | POST | None | `AuthRepository.login()` | `login_screen.dart` | ✅ |
| 3 | `/profile` | GET | Bearer | `AuthRepository.getProfile()` | `profile_screen.dart` | ✅ |
| 4 | `/profile` | PUT | Bearer | `AuthRepository.updateProfile()` | `profile_screen.dart` | ✅ |
| 5 | `/products` | GET | None | `ProductRepository.fetchProducts()` | `product_screen.dart` + `ProductCubit` | ✅ |
| 6 | `/products/[id]` | GET | None | `ProductRepository.fetchProductDetail()` | `product_detail_screen.dart` (via `/detail/:id`) | ✅ |
| 7 | `/promos` | GET | None | `PromoRepository.fetchPromos()` | `promo_screen.dart` | ✅ |
| 8 | `/banners` | GET | None | `PromoRepository.fetchBanners()` | `homepage.dart` (swiper) | ✅ |
| 9 | `/workshops` | GET | None | `WorkshopRepository.fetchWorkshops()` | `workshop_map_screen.dart` | ✅ |
| 10 | `/orders` | GET | Bearer | `OrderRepository.fetchOrders()` | `transaction_detail_screen.dart` | ✅ |
| 11 | `/orders` | POST | Bearer | `OrderRepository.createOrder()` | `checkout_screen.dart` | ✅ |
| 12 | `/orders/[id]` | GET | Bearer | `OrderRepository.fetchOrderDetail()` | `transaction_detail_screen.dart` | ✅ |
| 13 | `/orders/[id]` | PUT | Bearer | `OrderRepository.cancelOrder()` | `transaction_detail_screen.dart` | ✅ |
| 14 | `/tracking/[orderId]` | GET | Bearer | `TrackingRepository.fetchTracking()` | `monitoring_screen.dart` | ✅ |

---

## 📱 Per-Screen Integration Summary

| Screen | API(s) Consumed | Fallback Behavior |
|---|---|---|
| `homepage.dart` | `PromoRepository.fetchBanners()` | Static banners on error/empty |
| `login_screen.dart` | `AuthRepository.login()` | — |
| `register_screen.dart` | `AuthRepository.register()` | — |
| `profile_screen.dart` | `AuthRepository.getProfile()` + `updateProfile()` | Default values on error |
| `product_screen.dart` | `ProductRepository.fetchProducts()` via `ProductCubit` | — |
| `product_detail_screen.dart` | `ProductRepository.fetchProductDetail()` | Route params fallback |
| `promo_screen.dart` | `PromoRepository.fetchPromos()` | 4 static promos on error/empty |
| `workshop_map_screen.dart` | `WorkshopRepository.fetchWorkshops()` | 6 static workshops on error/empty |
| `cart_screen.dart` | Local state (uses `ProductResponse` model) | — |
| `checkout_screen.dart` | `OrderRepository.createOrder()` | — |
| `transaction_detail_screen.dart` | `OrderRepository.fetchOrders()` + `cancelOrder()` | Empty state message |
| `monitoring_screen.dart` | `TrackingRepository.fetchTracking()` via latest order | Static tracking data on error |

---

## 📁 File Struktur API

```
lib/
├── core/
│   ├── di/
│   │   └── app_services.dart          ← DI container (semua repository)
│   └── network/
│       ├── api_client.dart             ← HTTP client (GET/POST/PUT, retry, JWT)
│       ├── api_endpoints.dart          ← Semua path endpoint
│       ├── api_exception.dart          ← Exception class
│       ├── api_result.dart             ← ApiSuccess / ApiFailure
│       └── global_error_handler.dart   ← Error → user message
├── models/
│   └── api_models.dart                 ← Semua response/request model
├── features/
│   ├── auth/data/auth_repository.dart
│   ├── product/data/product_repository.dart
│   ├── promo/data/promo_repository.dart
│   ├── workshop/data/workshop_repository.dart
│   ├── order/data/order_repository.dart
│   └── tracking/data/tracking_repository.dart
└── screens/                            ← Semua screen terintegrasi ✅
    ├── login_screen.dart
    ├── register_screen.dart
    ├── profile_screen.dart
    ├── homepage.dart
    ├── product_screen.dart
    ├── product_detail_screen.dart
    ├── promo_screen.dart
    ├── workshop_map_screen.dart
    ├── cart_screen.dart
    ├── checkout_screen.dart
    ├── transaction_detail_screen.dart
    └── monitoring_screen.dart
```

---

## 🔧 Cara Menjalankan

1. Pastikan backend API berjalan di `http://localhost:3000`
2. `flutter run`
3. Aplikasi akan memanggil API secara otomatis; setiap screen memiliki fallback static data jika API tidak tersedia