# Shop & Drive

Flutter mobile app untuk kebutuhan e-commerce otomotif dan monitoring perjalanan, dengan pendekatan arsitektur modular, komponen reusable, state management Riverpod, serta fondasi network layer production-ready (timeout, retry, dan global unauthorized handler).

## Highlights

- UI modern dengan komponen terpisah (floating app bar, bottom bar, search bar, card product, promo, notification tile, dll)
- Routing terpusat memakai `go_router`
- State management memakai `flutter_riverpod`
- Dynamic swiper component (`card_swiper`) yang bisa dipakai untuk banner dan product card
- Monitoring perjalanan dengan `flutter_map` (OpenStreetMap, gratis)
- Template data layer + network policy:
	- Request timeout
	- Retry policy dengan backoff untuk status tertentu
	- Global `401` handler untuk force logout

## Tech Stack

- Flutter (Dart SDK `^3.12.2`)
- `go_router`
- `flutter_riverpod`
- `card_swiper`
- `flutter_map` + `latlong2`
- `http`
- `shared_preferences`

## Dependencies

Konfigurasi dependency utama ada di [pubspec.yaml](pubspec.yaml).

```yaml
dependencies:
	flutter:
		sdk: flutter
	cupertino_icons: ^1.0.8
	go_router: ^17.3.0
	card_swiper: ^3.0.1
	flutter_map: ^8.2.1
	latlong2: ^0.9.1
	http: ^1.3.0
	shared_preferences: ^2.5.3
	flutter_riverpod: ^2.6.1
```

## Project Structure

Struktur utama pada folder `lib`:

```text
lib/
	main.dart
	routers/
		app_router.dart
	core/
		di/
			app_services.dart
		network/
			api_client.dart
			api_endpoints.dart
			api_exception.dart
			api_result.dart
			global_error_handler.dart
		session/
			session_guard.dart
		storage/
			session_storage.dart
		theme/
			app_theme.dart
	features/
		auth/
			data/auth_repository.dart
			domain/models/auth_session.dart
			presentation/providers/auth_providers.dart
		product/
			data/product_repository.dart
			presentation/providers/product_providers.dart
		payment/
			data/payment_repository.dart
			domain/models/payment_result.dart
			presentation/providers/payment_providers.dart
	components/
		auth/
		floating/
		layout/
		loading/
		navigation/
		notification/
		product/
		profile/
		promo/
		swiper/
	models/
		catalog_product.dart
		swiper_item.dart
	screens/
		splash_screen.dart
		homepage.dart
		monitoring_screen.dart
		product_screen.dart
		checkout_screen.dart
		transaction_detail_screen.dart
		promo_screen.dart
		profile_screen.dart
		notification_screen.dart
		login_screen.dart
		register_screen.dart
```

## App Architecture

### 1. Entry Point

- [lib/main.dart](lib/main.dart)
	- App dibungkus `ProviderScope` untuk mengaktifkan Riverpod
	- Tema global via `AppTheme.light()`
	- Router global via `MaterialApp.router`

### 2. Routing

- [lib/routers/app_router.dart](lib/routers/app_router.dart)
	- Menyimpan semua route aplikasi
	- Route utama: splash, home, products, monitoring, promo, profile, notifications, auth, checkout, transaction detail
	- Guard unauthorized memakai `refreshListenable: AppServices.sessionGuard`
	- Jika session unauthorized, user diarahkan ke `/login`

### 3. Core Layer

- `core/di`:
	- [lib/core/di/app_services.dart](lib/core/di/app_services.dart)
	- Service locator sederhana untuk dependency global

- `core/network`:
	- [lib/core/network/api_client.dart](lib/core/network/api_client.dart)
	- [lib/core/network/api_exception.dart](lib/core/network/api_exception.dart)
	- [lib/core/network/api_result.dart](lib/core/network/api_result.dart)
	- [lib/core/network/global_error_handler.dart](lib/core/network/global_error_handler.dart)
	- [lib/core/network/api_endpoints.dart](lib/core/network/api_endpoints.dart)

- `core/storage`:
	- [lib/core/storage/session_storage.dart](lib/core/storage/session_storage.dart)
	- Menyimpan token/session menggunakan `shared_preferences`

- `core/session`:
	- [lib/core/session/session_guard.dart](lib/core/session/session_guard.dart)
	- State notifier global untuk status unauthorized

- `core/theme`:
	- [lib/core/theme/app_theme.dart](lib/core/theme/app_theme.dart)
	- Basis warna brand termasuk base soft color `#FFF0EE`

### 4. Feature Layer

Setiap feature mengikuti pemisahan:

- `data` -> repository/API source
- `domain` -> model/domain entities
- `presentation/providers` -> state controller Riverpod

Contoh:
- Auth: [lib/features/auth/data/auth_repository.dart](lib/features/auth/data/auth_repository.dart), [lib/features/auth/presentation/providers/auth_providers.dart](lib/features/auth/presentation/providers/auth_providers.dart)
- Product: [lib/features/product/data/product_repository.dart](lib/features/product/data/product_repository.dart), [lib/features/product/presentation/providers/product_providers.dart](lib/features/product/presentation/providers/product_providers.dart)
- Payment: [lib/features/payment/data/payment_repository.dart](lib/features/payment/data/payment_repository.dart), [lib/features/payment/presentation/providers/payment_providers.dart](lib/features/payment/presentation/providers/payment_providers.dart)

### 5. UI Layer

- `screens/` untuk halaman penuh
- `components/` untuk reusable UI blocks
- `models/` untuk model presentasi lintas screen/component

## State Management (Riverpod)

Implementasi sekarang memakai `StateNotifier` + `AsyncValue`:

- Auth controller:
	- `LoginController`
	- `RegisterController`
	- File: [lib/features/auth/presentation/providers/auth_providers.dart](lib/features/auth/presentation/providers/auth_providers.dart)

- Product controller:
	- `ProductListController`
	- File: [lib/features/product/presentation/providers/product_providers.dart](lib/features/product/presentation/providers/product_providers.dart)

- Payment controller:
	- `PaymentController`
	- File: [lib/features/payment/presentation/providers/payment_providers.dart](lib/features/payment/presentation/providers/payment_providers.dart)

Screen yang sudah terhubung provider:
- [lib/screens/login_screen.dart](lib/screens/login_screen.dart)
- [lib/screens/register_screen.dart](lib/screens/register_screen.dart)
- [lib/screens/product_screen.dart](lib/screens/product_screen.dart)
- [lib/screens/checkout_screen.dart](lib/screens/checkout_screen.dart)

## Network Policy

Implementasi policy ada di [lib/core/network/api_client.dart](lib/core/network/api_client.dart).

### Timeout

- Default timeout request: `12 detik`

### Retry

- Default max retry: `2` (total percobaan = request awal + retry)
- Retry untuk kondisi:
	- `408`
	- `429`
	- `5xx`
	- network exception (`SocketException`, `ClientException`, `TimeoutException`)
- Delay retry menggunakan quadratic backoff:
	- $delay = 350ms * (attempt + 1)^2$

### Global Unauthorized Handler (401)

Saat response `401`:
- `ApiClient` memanggil callback `onUnauthorized`
- [lib/core/di/app_services.dart](lib/core/di/app_services.dart) menghubungkan callback ke:
	- clear session storage
	- `sessionGuard.markUnauthorized()`
- Router membaca perubahan itu dan force redirect ke `/login`

## Feature Screens

Daftar screen utama:

- Splash: [lib/screens/splash_screen.dart](lib/screens/splash_screen.dart)
- Home: [lib/screens/homepage.dart](lib/screens/homepage.dart)
- Monitoring map: [lib/screens/monitoring_screen.dart](lib/screens/monitoring_screen.dart)
- Products + filter chip + grid/list: [lib/screens/product_screen.dart](lib/screens/product_screen.dart)
- Checkout + payment gateway: [lib/screens/checkout_screen.dart](lib/screens/checkout_screen.dart)
- Transaction detail: [lib/screens/transaction_detail_screen.dart](lib/screens/transaction_detail_screen.dart)
- Promo: [lib/screens/promo_screen.dart](lib/screens/promo_screen.dart)
- Profile: [lib/screens/profile_screen.dart](lib/screens/profile_screen.dart)
- Notification: [lib/screens/notification_screen.dart](lib/screens/notification_screen.dart)
- Login/Register: [lib/screens/login_screen.dart](lib/screens/login_screen.dart), [lib/screens/register_screen.dart](lib/screens/register_screen.dart)

## Swiper Component

Dynamic swiper reusable ada di [lib/components/swiper/swiper.dart](lib/components/swiper/swiper.dart), dengan model item di [lib/models/swiper_item.dart](lib/models/swiper_item.dart).

Desain penggunaan:
- Bisa dipakai mode banner
- Bisa dipakai mode product card
- Data source cukup kirim list model (dinamis)

## Theme & Design System

Konfigurasi warna utama di [lib/core/theme/app_theme.dart](lib/core/theme/app_theme.dart):

- `primary`: `#5C4E4B`
- `softPrimary`: `#FFF0EE` (base color request)
- `textPrimary`: `#2C2624`
- `textSecondary`: `#6D6A69`

Komponen visual konsisten:
- Card radius seragam
- Input field style seragam
- Filled button style seragam
- Background decor via shared scaffold

## Setup & Run

### Prerequisites

- Flutter SDK terpasang dan tersedia di PATH
- Android Studio / Xcode (sesuai target platform)

### Install

```bash
flutter pub get
```

### Run

```bash
flutter run
```

### Analyze

```bash
flutter analyze
```

### Test

```bash
flutter test
```

## API Integration Guide (From Mock to Real API)

Saat ini repository masih template/mock agar UI flow bisa berjalan tanpa backend. Untuk integrasi real API:

1. Set base URL di [lib/core/network/api_endpoints.dart](lib/core/network/api_endpoints.dart)
2. Aktifkan call `_apiClient.get/post` di repository:
	 - [lib/features/auth/data/auth_repository.dart](lib/features/auth/data/auth_repository.dart)
	 - [lib/features/product/data/product_repository.dart](lib/features/product/data/product_repository.dart)
	 - [lib/features/payment/data/payment_repository.dart](lib/features/payment/data/payment_repository.dart)
3. Mapping response JSON ke model domain
4. Pastikan backend mengembalikan status code yang sesuai (terutama 401/429/5xx)
5. Tambahkan refresh token flow bila dibutuhkan

## Production Notes

- Global unauthorized flow sudah ada, namun refresh token otomatis belum diaktifkan.
- Pertimbangkan menambah:
	- Request tracing/logging (tanpa expose data sensitif)
	- Feature flags/env config (`dev`, `staging`, `prod`)
	- Unit test untuk controller + repository
	- Widget test untuk screen kritikal

## License

Private/internal project.
