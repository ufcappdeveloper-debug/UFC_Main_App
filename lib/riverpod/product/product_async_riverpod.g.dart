// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_async_riverpod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$productAsyncHash() => r'26fb697713ebcf674c678fc189bcc1e066289569';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$ProductAsync
    extends BuildlessAsyncNotifier<List<ProductModel>?> {
  late final int? categoryId;

  FutureOr<List<ProductModel>?> build({
    int? categoryId,
  });
}

/// See also [ProductAsync].
@ProviderFor(ProductAsync)
const productAsyncProvider = ProductAsyncFamily();

/// See also [ProductAsync].
class ProductAsyncFamily extends Family<AsyncValue<List<ProductModel>?>> {
  /// See also [ProductAsync].
  const ProductAsyncFamily();

  /// See also [ProductAsync].
  ProductAsyncProvider call({
    int? categoryId,
  }) {
    return ProductAsyncProvider(
      categoryId: categoryId,
    );
  }

  @override
  ProductAsyncProvider getProviderOverride(
    covariant ProductAsyncProvider provider,
  ) {
    return call(
      categoryId: provider.categoryId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'productAsyncProvider';
}

/// See also [ProductAsync].
class ProductAsyncProvider
    extends AsyncNotifierProviderImpl<ProductAsync, List<ProductModel>?> {
  /// See also [ProductAsync].
  ProductAsyncProvider({
    int? categoryId,
  }) : this._internal(
          () => ProductAsync()..categoryId = categoryId,
          from: productAsyncProvider,
          name: r'productAsyncProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$productAsyncHash,
          dependencies: ProductAsyncFamily._dependencies,
          allTransitiveDependencies:
              ProductAsyncFamily._allTransitiveDependencies,
          categoryId: categoryId,
        );

  ProductAsyncProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryId,
  }) : super.internal();

  final int? categoryId;

  @override
  FutureOr<List<ProductModel>?> runNotifierBuild(
    covariant ProductAsync notifier,
  ) {
    return notifier.build(
      categoryId: categoryId,
    );
  }

  @override
  Override overrideWith(ProductAsync Function() create) {
    return ProviderOverride(
      origin: this,
      override: ProductAsyncProvider._internal(
        () => create()..categoryId = categoryId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoryId: categoryId,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<ProductAsync, List<ProductModel>?>
      createElement() {
    return _ProductAsyncProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductAsyncProvider && other.categoryId == categoryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProductAsyncRef on AsyncNotifierProviderRef<List<ProductModel>?> {
  /// The parameter `categoryId` of this provider.
  int? get categoryId;
}

class _ProductAsyncProviderElement
    extends AsyncNotifierProviderElement<ProductAsync, List<ProductModel>?>
    with ProductAsyncRef {
  _ProductAsyncProviderElement(super.provider);

  @override
  int? get categoryId => (origin as ProductAsyncProvider).categoryId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
