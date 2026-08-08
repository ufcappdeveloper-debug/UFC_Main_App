# UFC Mobile App

Saudi-based project for **UFC**

## Flutter

Refer to the **.fvm** folder for the Flutter version used in this project.




## Android Keystore

```dart
storePassword=UFCaPP333
keyPassword=UFCaPP333
keyAlias=UFC
storeFile=../../sign_in_key.jks
```

## Easy Localization File Generator

```dart
dart run easy_localization:generate -S "assets/translations" -O "lib/global/shared/translations"
```

```dart
dart run build_runner watch --delete-conflicting-outputs  
```

## App Architecture

```
lib/  
 └─ features/  
      └─ feed/  
           ├─ domain/          <-- Entities & repository interfaces  
           │    ├─ entities/  
           │    │    └─ product_entity.dart  
           │    ├─ repositories/  
           │    │    └─ product_repository.dart  
           │    ├─ failures/  
           │    │    └─ failure.dart        // optional: custom error handling  
           │    └─ usecases/  
           │         └─ product_usecase.dart <-- Use cases & business logic  
           │  
           ├─ infrastructure/  <-- Data sources & repository implementations  
           │    ├─ datasource/  
           │    │    ├─ product_remote_data_source.dart  
           │    │    └─ product_remote_data_source_impl.dart  
           │    └─ repositories/  
           │         └─ product_repository_impl.dart  
           │  
           ├─ application/     <-- Cubit/Bloc + state management  
           │    ├─ cubit/  
           │    │    └─ product_list_cubit.dart  
           │  
           └─ presentation/    
                └─ pages/  
                     └─ product_list_screen.dart  
```

## App Build

### iOS Build

```dart
flutter build ipa --dart-define=ENV=dev
flutter build ipa --dart-define=ENV=testing
flutter build ipa --dart-define=ENV=production
```

### Android Build

```dart
flutter build appbundle --dart-define=ENV=dev
flutter build appbundle --dart-define=ENV=testing
flutter build appbundle --dart-define=ENV=production
```

## Firebase App Tester Build

### iOS Build

```dart
flutter build ipa --release --export-method=ad-hoc --dart-define=ENV=dev
flutter build ipa --release --export-method=ad-hoc --dart-define=ENV=testing
flutter build ipa --release --export-method=ad-hoc --dart-define=ENV=production
```

### Android Build

```dart
flutter build apk --release --dart-define=ENV=dev
flutter build apk --release --dart-define=ENV=testing
flutter build apk --release --dart-define=ENV=production

flutter build apk --release --split-per-abi --dart-define=ENV=dev
flutter build apk --release --split-per-abi --dart-define=ENV=testing
flutter build apk --release --split-per-abi --dart-define=ENV=production
```

## Shorebird Build

### iOS Build

```dart
shorebird release ios
shorebird release ios --dart-define=ENV=dev
shorebird release ios --dart-define=ENV=testing
shorebird release ios --dart-define=ENV=production
```

### Android Build

```dart
shorebird release android
shorebird release android --dart-define=ENV=dev
shorebird release android --dart-define=ENV=testing
shorebird release android --dart-define=ENV=production
```

## VS Code Launch Config (Optional)

To run with a specific environment in **VS Code**, update launch.json:  

```json
{
  "name": "UFC-Mobile-App",
  "request": "launch",
  "type": "dart",
  "args": ["--dart-define=ENV=dev"]
}
```

By default, the app falls back to **production** to avoid unwanted builds.
