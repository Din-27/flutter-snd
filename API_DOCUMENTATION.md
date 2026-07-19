# Shop & Drive — Customer API Documentation

> **Base URL:** `http://localhost:3000/api/customer`  
> **Content-Type:** `application/json`  
> **Authentication:** Bearer JWT token (dari login/register)

---

## ⚠️ CORS Setup (Flutter Web)

Flutter web berjalan di browser yang menerapkan CORS policy. Karena backend (`localhost:3000`) dan Flutter web (`localhost:xxxxx`) berjalan di origin berbeda, browser memblokir request.

**Solusi: Aktifkan CORS di backend.**

**Node.js / Express:**
```js
const cors = require('cors');
app.use(cors({ origin: true, credentials: true }));
```

**NestJS:**
```ts
// main.ts
app.enableCors({ origin: true, credentials: true });
```

**Go / Gin:**
```go
import "github.com/gin-contrib/cors"
router.Use(cors.Default())
```

**Laravel / PHP:**
```php
// config/cors.php — tambahkan '*' di allowed_origins
```

Setelah backend mengizinkan CORS, Flutter web dapat langsung request ke `localhost:3000`.

**Untuk Android emulator:** Gunakan `10.0.2.2:3000` alih-alih `localhost:3000` (Android emulator tidak bisa akses `localhost` host).

---

## Daftar Isi

1. [Authentication](#1-authentication)
   - [POST /auth/register](#post-authregister)
   - [POST /auth/login](#post-authlogin)
2. [Profile](#2-profile)
   - [GET /profile](#get-profile)
   - [PUT /profile](#put-profile)
3. [Products](#3-products)
   - [GET /products](#get-products)
   - [GET /products/:id](#get-productsid)
4. [Promos & Banners](#4-promos--banners)
   - [GET /promos](#get-promos)
   - [GET /banners](#get-banners)
5. [Workshops](#5-workshops)
   - [GET /workshops](#get-workshops)
6. [Orders](#6-orders)
   - [GET /orders](#get-orders)
   - [POST /orders](#post-orders)
   - [GET /orders/:id](#get-ordersid)
   - [PUT /orders/:id](#put-ordersid)
7. [Tracking](#7-tracking)
   - [GET /tracking/:orderId](#get-trackingorderid)

---

## 1. Authentication

### POST /auth/register

Registrasi customer baru. Password akan di-hash oleh backend. Mengembalikan JWT token.

| | |
|---|---|
| **URL** | `/auth/register` |
| **Method** | `POST` |
| **Auth** | None |
| **UI Screen** | `register_screen.dart` |

**Request Body (JSON):**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `name` | `string` | ✅ | Nama lengkap customer |
| `email` | `string` | ✅ | Alamat email |
| `password` | `string` | ✅ | Password (min. 6 karakter) |

```json
{
  "name": "Herdiyana",
  "email": "herdiyana@example.com",
  "password": "rahasia123"
}
```

**Response 201 (Success):**

| Field | Type | Description |
|---|---|---|
| `accessToken` | `string` | JWT access token |
| `refreshToken` | `string` | JWT refresh token |
| `userId` | `string` | ID customer |
| `name` | `string` | Nama customer |
| `email` | `string` | Email customer |

```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIs...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIs...",
  "userId": "64a1b2c3d4e5f6a7b8c9d0e1",
  "name": "Herdiyana",
  "email": "herdiyana@example.com"
}
```

**Response 400 (Validation Error):**

```json
{
  "message": "Email sudah terdaftar"
}
```

**Catatan UI:**
- Form register di `register_screen.dart` memiliki field: Nama, No. Telepon, Email, Password, Konfirmasi Password
- Field `phone` saat ini hanya divalidasi di client (min. 10 karakter), **belum dikirim ke backend**
- Setelah register sukses, user langsung login dan diarahkan ke homepage `/`

---

### POST /auth/login

Login customer dengan email & password. Mengembalikan JWT token.

| | |
|---|---|
| **URL** | `/auth/login` |
| **Method** | `POST` |
| **Auth** | None |
| **UI Screen** | `login_screen.dart` |

**Request Body (JSON):**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `email` | `string` | ✅ | Email terdaftar |
| `password` | `string` | ✅ | Password |

```json
{
  "email": "herdiyana@example.com",
  "password": "rahasia123"
}
```

**Response 200 (Success):**

| Field | Type | Description |
|---|---|---|
| `accessToken` | `string` | JWT access token |
| `refreshToken` | `string` | JWT refresh token |
| `userId` | `string` | ID customer |
| `name` | `string` | Nama customer |
| `email` | `string` | Email customer |

```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIs...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIs...",
  "userId": "64a1b2c3d4e5f6a7b8c9d0e1",
  "name": "Herdiyana",
  "email": "herdiyana@example.com"
}
```

**Response 401 (Unauthorized):**

```json
{
  "message": "Email atau password salah"
}
```

**Catatan UI:**
- Login screen (`login_screen.dart`) memiliki 2 mode: login via **email/password** dan login via **nomor telepon** (OTP)
- Login via nomor telepon saat ini **hanya navigasi ke OTP screen** (`/otp`), tidak memanggil API
- Google Sign-In juga tersedia via `AuthRepository.loginWithGoogle()` — mengirim `idToken`, `accessToken`, `provider: "google"` ke endpoint `/auth/login`
- Setelah login sukses, user diarahkan ke homepage `/`

---

## 2. Profile

### GET /profile

Mendapatkan data profile customer yang sedang login.

| | |
|---|---|
| **URL** | `/profile` |
| **Method** | `GET` |
| **Auth** | Bearer JWT |
| **UI Screen** | `profile_screen.dart` |

**Headers:**

| Header | Value |
|---|---|
| `Authorization` | `Bearer <accessToken>` |

**Response 200 (Success):**

| Field | Type | Description |
|---|---|---|
| `userId` | `string` | ID customer |
| `name` | `string` | Nama lengkap |
| `email` | `string` | Alamat email |

```json
{
  "userId": "64a1b2c3d4e5f6a7b8c9d0e1",
  "name": "Herdiyana",
  "email": "herdiyana@example.com"
}
```

**Catatan UI:**
- `profile_screen.dart` menampilkan: Avatar, Nama, Email, Poin, Jumlah Transaksi, Jumlah Promo
- Jika API gagal/unavailable, profile tetap bisa dibuka dengan data default (fallback)
- Tombol **Edit Profile** membuka dialog untuk edit nama dan email

---

### PUT /profile

Mengupdate data profile customer.

| | |
|---|---|
| **URL** | `/profile` |
| **Method** | `PUT` |
| **Auth** | Bearer JWT |
| **UI Screen** | `profile_screen.dart` (Edit Profile dialog) |

**Request Body (JSON):**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `name` | `string` | ❌ | Nama baru |
| `email` | `string` | ❌ | Email baru |

```json
{
  "name": "Herdiyana Updated",
  "email": "herdiyana.new@example.com"
}
```

**Response 200 (Success):**

```json
{
  "userId": "64a1b2c3d4e5f6a7b8c9d0e1",
  "name": "Herdiyana Updated",
  "email": "herdiyana.new@example.com"
}
```

**Catatan UI:**
- Dialog edit profile memiliki 2 field: **Nama** dan **Email**
- Field `phone` tidak disertakan dalam request edit profile
- Setelah update sukses, profile otomatis di-refresh

---

## 3. Products

### GET /products

Mendapatkan daftar produk aktif.

| | |
|---|---|
| **URL** | `/products` |
| **Method** | `GET` |
| **Auth** | None |
| **UI Screen** | `product_screen.dart` (via `ProductCubit`) |

**Query Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `page` | `int` | ❌ | `1` | Nomor halaman |
| `merchantId` | `string` | ❌ | — | Filter berdasarkan toko/merchant |
| `category` | `string` | ❌ | — | Filter berdasarkan kategori produk |
| `search` | `string` | ❌ | — | Pencarian berdasarkan nama produk |

**Contoh Request:**

```
GET /products?category=Sparepart&page=1
GET /products?search=Brake+Pad
GET /products?merchantId=64abc123&page=1
```

**Response 200 (Success):**

| Field | Type | Description |
|---|---|---|
| `data` | `array` | List produk (bisa juga di-wrap dalam `products` atau `results`) |

**Item Object:**

| Field | Type | Description |
|---|---|---|
| `id` | `string` | ID produk |
| `name` | `string` | Nama produk |
| `category` | `string` | Kategori produk |
| `price` | `int` | Harga dalam Rupiah |
| `imageUrl` | `string` | URL gambar produk |
| `rating` | `double` | Rating (0.0–5.0) |
| `merchantId` | `string` | ID toko (opsional) |
| `merchantName` | `string` | Nama toko (opsional) |

```json
{
  "data": [
    {
      "id": "64a1b2c3d4e5f6a7b8c9d0e1",
      "name": "Brake Pad Ceramic",
      "category": "Sparepart",
      "price": 850000,
      "imageUrl": "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400",
      "rating": 4.8,
      "merchantId": "64m001",
      "merchantName": "Toko Sparepart Jaya"
    },
    {
      "id": "64a1b2c3d4e5f6a7b8c9d0e2",
      "name": "Oli Mesin Shell Helix 5W-30",
      "category": "Oli & Pelumas",
      "price": 450000,
      "imageUrl": "https://images.unsplash.com/photo-1635789221425-7e6d1db68a6c?w=400",
      "rating": 4.9
    }
  ]
}
```

**Response wrapper yang didukung (client):**
Client (`_extractList()`) mendukung 3 bentuk response:
- `{ "data": [...] }`
- `{ "products": [...] }`
- `{ "results": [...] }`

**Catatan UI:**
- `product_screen.dart` menampilkan produk dalam dua mode: **grid** (2 kolom) dan **list** (1 kolom)
- Filter kategori tersedia via chips horizontal di bagian atas
- Search bar tersedia (`floating_search_bar.dart`)
- Produk ditampilkan via `ProductGridCard` / `ProductListCard`
- Pull-to-refresh tersedia

---

### GET /products/:id

Mendapatkan detail produk + informasi merchant.

| | |
|---|---|
| **URL** | `/products/:id` |
| **Method** | `GET` |
| **Auth** | None |
| **UI Screen** | `product_detail_screen.dart` (via `/detail/:id`) |

**Path Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `id` | `string` | ✅ | ID produk |

**Contoh Request:**

```
GET /products/64a1b2c3d4e5f6a7b8c9d0e1
```

**Response 200 (Success):**

| Field | Type | Description |
|---|---|---|
| `id` | `string` | ID produk |
| `name` | `string` | Nama produk |
| `category` | `string` | Kategori |
| `price` | `int` | Harga dalam Rupiah |
| `imageUrl` | `string` | URL gambar |
| `rating` | `double` | Rating (0.0–5.0) |
| `description` | `string` | Deskripsi produk (opsional) |
| `merchantId` | `string` | ID toko (opsional) |
| `merchantName` | `string` | Nama toko (opsional) |
| `merchantAddress` | `string` | Alamat toko (opsional) |

```json
{
  "id": "64a1b2c3d4e5f6a7b8c9d0e1",
  "name": "Brake Pad Ceramic",
  "category": "Sparepart",
  "price": 850000,
  "imageUrl": "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800",
  "rating": 4.8,
  "description": "Brake pad ceramic kualitas premium untuk semua tipe mobil Jepang.",
  "merchantId": "64m001",
  "merchantName": "Toko Sparepart Jaya",
  "merchantAddress": "Jl. Pegangsaan Dua Km 2.2, Jakarta Utara"
}
```

**Catatan UI:**
- `product_detail_screen.dart` menerima `productId` via route `/detail/:id`
- Jika `productId` tidak tersedia, screen menerima data dari query parameters (nama, kategori, harga, gambar, rating) sebagai fallback
- UI menampilkan: gambar produk, kategori, rating, nama, harga, deskripsi, info toko
- Qty selector (+/-) dan opsi delivery tersedia
- Tombol **Checkout** mengarah ke `/checkout` dengan membawa parameter produk

---

## 4. Promos & Banners

### GET /promos

Mendapatkan daftar promo yang sedang aktif (sekarang berada di antara `startDate` dan `endDate`).

| | |
|---|---|
| **URL** | `/promos` |
| **Method** | `GET` |
| **Auth** | None |
| **UI Screen** | `promo_screen.dart` |

**Response 200 (Success):**

| Field | Type | Description |
|---|---|---|
| `data` | `array` | List promo (bisa juga `promos` atau `results`) |

**Item Object:**

| Field | Type | Description |
|---|---|---|
| `id` | `string` | ID promo |
| `title` | `string` | Judul promo |
| `description` | `string` | Deskripsi promo |
| `imageUrl` | `string` | URL gambar promo |
| `startDate` | `string` | Tanggal mulai (ISO format, opsional) |
| `endDate` | `string` | Tanggal berakhir (ISO format, opsional) |

```json
{
  "data": [
    {
      "id": "promo_001",
      "title": "Diskon Servis 25%",
      "description": "Untuk booking home service hari ini",
      "imageUrl": "https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=600",
      "startDate": "2026-07-01T00:00:00Z",
      "endDate": "2026-07-31T23:59:59Z"
    },
    {
      "id": "promo_002",
      "title": "Gratis Cek Mesin",
      "description": "Minimal transaksi Rp 300.000",
      "imageUrl": "https://images.unsplash.com/photo-1487754180451-c456f719a1fc?w=600",
      "endDate": "2026-08-15T23:59:59Z"
    }
  ]
}
```

**Response wrapper yang didukung (client):** `data`, `promos`, `results`

**Catatan UI:**
- `promo_screen.dart` menampilkan promo dalam list card dengan:
  - Gambar, tag (PROMO / HOT / NEW / LIMITED), judul, deskripsi, tanggal berlaku
  - Tombol **Pakai** → navigasi ke `/products`
- Fallback: 4 promo statis jika API gagal/unavailable

---

### GET /banners

Mendapatkan daftar banner yang sedang aktif.

| | |
|---|---|
| **URL** | `/banners` |
| **Method** | `GET` |
| **Auth** | None |
| **UI Screen** | `homepage.dart` (swiper/carousel) |

**Query Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `position` | `string` | ❌ | — | Filter berdasarkan posisi banner (misal: `home_top`, `home_middle`) |

**Contoh Request:**

```
GET /banners?position=home_top
```

**Response 200 (Success):**

| Field | Type | Description |
|---|---|---|
| `data` | `array` | List banner (bisa juga `banners` atau `results`) |

**Item Object:**

| Field | Type | Description |
|---|---|---|
| `id` | `string` | ID banner |
| `title` | `string` | Judul banner |
| `subtitle` | `string` | Sub-judul (opsional) |
| `imageUrl` | `string` | URL gambar banner |
| `position` | `string` | Posisi banner (opsional) |

```json
{
  "data": [
    {
      "id": "banner_001",
      "title": "Promo Home Service",
      "subtitle": "Diskon hingga 30%",
      "imageUrl": "https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?w=800",
      "position": "home_top"
    },
    {
      "id": "banner_002",
      "title": "Ganti Oli Murah",
      "subtitle": "Mulai dari Rp 150.000",
      "imageUrl": "https://images.unsplash.com/photo-1530046339160-ce3e530c7d2f?w=800",
      "position": "home_top"
    }
  ]
}
```

**Response wrapper yang didukung (client):** `data`, `banners`, `results`

**Catatan UI:**
- `homepage.dart` menampilkan banner dalam swiper/carousel di bagian atas halaman
- Fallback: 3 banner statis jika API gagal/unavailable

---

## 5. Workshops

### GET /workshops

Mendapatkan daftar bengkel yang upcoming/ongoing.

| | |
|---|---|
| **URL** | `/workshops` |
| **Method** | `GET` |
| **Auth** | None |
| **UI Screen** | `workshop_map_screen.dart` |

**Response 200 (Success):**

| Field | Type | Description |
|---|---|---|
| `data` | `array` | List bengkel (bisa juga `workshops` atau `results`) |

**Item Object:**

| Field | Type | Description |
|---|---|---|
| `id` | `string` | ID bengkel |
| `name` | `string` | Nama bengkel |
| `address` | `string` | Alamat lengkap |
| `latitude` | `double` | Koordinat latitude |
| `longitude` | `double` | Koordinat longitude |
| `phone` | `string` | Nomor telepon (opsional) |
| `status` | `string` | Status bengkel (opsional) |

```json
{
  "data": [
    {
      "id": "ws_001",
      "name": "Shop & Drive Kelapa Gading",
      "address": "Jl. Pegangsaan Dua Km 2.2, Jakarta Utara",
      "latitude": -6.1685,
      "longitude": 106.9142,
      "phone": "021-12345678",
      "status": "active"
    },
    {
      "id": "ws_002",
      "name": "Shop & Drive Cempaka Putih",
      "address": "Jl. Cempaka Putih Raya No. 19, Jakarta Pusat",
      "latitude": -6.1824,
      "longitude": 106.8732,
      "phone": "021-87654321",
      "status": "active"
    }
  ]
}
```

**Response wrapper yang didukung (client):** `data`, `workshops`, `results`

**Catatan UI:**
- `workshop_map_screen.dart` menampilkan:
  - **Peta interaktif** (OpenStreetMap via flutter_map) dengan marker bengkel dan lokasi user
  - **List bengkel terdekat** diurutkan berdasarkan jarak dari lokasi user
  - **Detail card** saat bengkel dipilih (nama, alamat, rating, jarak, ETA, layanan)
  - Tombol **Pesan Home Service**
- Lokasi user didapatkan via GPS (`geolocator`), fallback ke Jakarta Pusat jika izin ditolak
- ETA dihitung secara client-side (`km × 2.5 menit`)
- Fallback: 6 bengkel statis di Jakarta jika API gagal/unavailable

---

## 6. Orders

### GET /orders

Mendapatkan daftar pesanan milik customer yang sedang login.

| | |
|---|---|
| **URL** | `/orders` |
| **Method** | `GET` |
| **Auth** | Bearer JWT |
| **UI Screen** | `transaction_detail_screen.dart` |

**Headers:**

| Header | Value |
|---|---|
| `Authorization` | `Bearer <accessToken>` |

**Response 200 (Success):**

| Field | Type | Description |
|---|---|---|
| `data` | `array` | List pesanan (bisa juga `orders` atau `results`) |

**Item Object:**

| Field | Type | Description |
|---|---|---|
| `id` | `string` | ID pesanan (order ID) |
| `status` | `string` | Status: `pending`, `processing`, `confirmed`, `completed`, `cancelled` |
| `totalAmount` | `int` | Total harga dalam Rupiah |
| `createdAt` | `string` | Timestamp pembuatan (opsional) |
| `items` | `array` | List item pesanan (opsional) |

**Items Object:**

| Field | Type | Description |
|---|---|---|
| `productId` | `string` | ID produk |
| `productName` | `string` | Nama produk |
| `price` | `int` | Harga satuan dalam Rupiah |
| `quantity` | `int` | Jumlah item |

```json
{
  "data": [
    {
      "id": "ord_001",
      "status": "pending",
      "totalAmount": 1700000,
      "createdAt": "2026-07-19T15:30:00Z",
      "items": [
        {
          "productId": "64a1b2c3d4e5f6a7b8c9d0e1",
          "productName": "Brake Pad Ceramic",
          "price": 850000,
          "quantity": 2
        }
      ]
    },
    {
      "id": "ord_002",
      "status": "completed",
      "totalAmount": 450000,
      "createdAt": "2026-07-15T10:00:00Z",
      "items": [
        {
          "productId": "64a1b2c3d4e5f6a7b8c9d0e2",
          "productName": "Oli Mesin Shell Helix 5W-30",
          "price": 450000,
          "quantity": 1
        }
      ]
    }
  ]
}
```

**Response wrapper yang didukung (client):** `data`, `orders`, `results`

**Catatan UI:**
- `transaction_detail_screen.dart` menampilkan list order dalam card:
  - ID pesanan (#ord_xxx), status (dengan warna: orange=pending, biru=processing, hijau=completed, merah=cancelled)
  - Total amount, tanggal, list item
  - Tombol **Batalkan Pesanan** (hanya untuk status `pending`)
- Pull-to-refresh tersedia
- Empty state: "Belum ada transaksi"

---

### POST /orders

Membuat pesanan baru.

| | |
|---|---|
| **URL** | `/orders` |
| **Method** | `POST` |
| **Auth** | Bearer JWT |
| **UI Screen** | `checkout_screen.dart` |

**Request Body (JSON):**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `items` | `array` | ✅ | List item yang dipesan |

**Items Object:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `productId` | `string` | ✅ | ID produk |
| `quantity` | `int` | ✅ | Jumlah item |

```json
{
  "items": [
    {
      "productId": "64a1b2c3d4e5f6a7b8c9d0e1",
      "quantity": 2
    }
  ]
}
```

**Response 201 (Success):**

Sama dengan response GET /orders/:id (lihat di bawah).

**Catatan UI:**
- `checkout_screen.dart` menerima data dari halaman detail produk:
  - `productName`, `amount` (total), `quantity` (dari query params)
- Tampilan: ringkasan pesanan (produk, jumlah, harga satuan, total)
- Tombol **Konfirmasi Pesanan** → loading → toast sukses → navigasi ke `/transaction-detail`
- Error handling: toast error message

---

### GET /orders/:id

Mendapatkan detail satu pesanan.

| | |
|---|---|
| **URL** | `/orders/:id` |
| **Method** | `GET` |
| **Auth** | Bearer JWT |
| **UI Screen** | `transaction_detail_screen.dart` |

**Path Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `id` | `string` | ✅ | ID pesanan |

**Response 200 (Success):**

Format sama dengan item di GET /orders (lihat di atas).

---

### PUT /orders/:id

Membatalkan pesanan (ubah status menjadi `cancelled`).

| | |
|---|---|
| **URL** | `/orders/:id` |
| **Method** | `PUT` |
| **Auth** | Bearer JWT |
| **UI Screen** | `transaction_detail_screen.dart` (tombol **Batalkan Pesanan**) |

**Path Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `id` | `string` | ✅ | ID pesanan yang akan dibatalkan |

**Request Body (JSON):**

```json
{
  "status": "cancelled"
}
```

**Response 200 (Success):**

Mengembalikan data pesanan yang sudah di-update (status: `cancelled`).

**Catatan UI:**
- Konfirmasi dialog: "Yakin ingin membatalkan pesanan #xxx?"
- Hanya pesanan dengan status `pending` yang bisa dibatalkan
- Setelah sukses, list pesanan di-refresh

---

## 7. Tracking

### GET /tracking/:orderId

Mendapatkan riwayat tracking lengkap + posisi terkini teknisi.

| | |
|---|---|
| **URL** | `/tracking/:orderId` |
| **Method** | `GET` |
| **Auth** | Bearer JWT |
| **UI Screen** | `monitoring_screen.dart` |

**Path Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `orderId` | `string` | ✅ | ID pesanan untuk tracking |

**Contoh Request:**

```
GET /tracking/ord_001
```

**Response 200 (Success):**

| Field | Type | Description |
|---|---|---|
| `orderId` | `string` | ID pesanan |
| `status` | `string` | Status tracking saat ini |
| `latitude` | `double` | Koordinat latitude teknisi (opsional) |
| `longitude` | `double` | Koordinat longitude teknisi (opsional) |
| `history` | `array` | Riwayat tracking (opsional) |

**History Item Object:**

| Field | Type | Description |
|---|---|---|
| `status` | `string` | Status tahapan |
| `description` | `string` | Deskripsi (opsional) |
| `timestamp` | `string` | Waktu update (opsional) |

```json
{
  "orderId": "ord_001",
  "status": "in_progress",
  "latitude": -8.6495,
  "longitude": 116.3200,
  "history": [
    {
      "status": "order_received",
      "description": "Order diterima bengkel",
      "timestamp": "09:12"
    },
    {
      "status": "technician_dispatched",
      "description": "Teknisi berangkat",
      "timestamp": "09:18"
    },
    {
      "status": "in_transit",
      "description": "Dalam perjalanan",
      "timestamp": "09:25"
    }
  ]
}
```

**Catatan UI:**
- `monitoring_screen.dart` menampilkan:
  - **Peta interaktif** dengan marker: lokasi user, bengkel-bengkel, teknisi
  - **Polyline route** dari bengkel ke lokasi user
  - **List bengkel terdekat** (3 bengkel)
  - **Timeline progress** home service (step-by-step dengan centang)
  - **Posisi terkini** teknisi (lat/lng, jika tersedia dari API)
- Alur: ambil order terbaru → ambil tracking untuk order tersebut
- Fallback: data tracking statis + 4 bengkel di Mataram jika API gagal

---

## Ringkasan Response Wrapper

Client mendukung 3 bentuk response wrapper untuk endpoint list:

| Wrapper | Contoh |
|---|---|
| `{ "data": [...] }` | `{ "data": [{...}, {...}] }` |
| `{ "products": [...] }` / `{ "orders": [...] }` / `{ "workshops": [...] }` / `{ "promos": [...] }` / `{ "banners": [...] }` | `{ "products": [{...}] }` |
| `{ "results": [...] }` | `{ "results": [{...}] }` |

---

## Error Response Format

Semua endpoint mengembalikan format error yang sama:

```json
{
  "message": "Deskripsi error"
}
```

Client menangani error dengan menampilkan toast/snackbar dengan pesan dari `message`.

---

## Auth Flow

```
[Register] → POST /auth/register → JWT token → simpan ke SessionStorage
[Login]    → POST /auth/login    → JWT token → simpan ke SessionStorage
[Profile]  → GET/PUT /profile    → Header: Authorization: Bearer <token>
[Orders]   → GET/POST/PUT /orders → Header: Authorization: Bearer <token>
[Tracking] → GET /tracking/:id   → Header: Authorization: Bearer <token>
```

Token disimpan secara lokal menggunakan `SessionStorage` (shared_preferences).
Token otomatis disertakan oleh `ApiClient` untuk endpoint yang membutuhkan auth.

---

## Screens → API Mapping

| Screen | API Call(s) | Auth |
|---|---|---|
| `login_screen.dart` | `POST /auth/login` | No |
| `register_screen.dart` | `POST /auth/register` | No |
| `homepage.dart` | `GET /banners` | No |
| `product_screen.dart` | `GET /products` | No |
| `product_detail_screen.dart` | `GET /products/:id` | No |
| `promo_screen.dart` | `GET /promos` | No |
| `workshop_map_screen.dart` | `GET /workshops` | No |
| `profile_screen.dart` | `GET /profile`, `PUT /profile` | Yes |
| `cart_screen.dart` | — (local state only) | — |
| `checkout_screen.dart` | `POST /orders` | Yes |
| `transaction_detail_screen.dart` | `GET /orders`, `PUT /orders/:id` | Yes |
| `monitoring_screen.dart` | `GET /orders` + `GET /tracking/:orderId` | Yes |