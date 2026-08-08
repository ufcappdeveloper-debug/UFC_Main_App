// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_future_riverpod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getProductDetailsHash() => r'2f955d5125f3514422f31a07c05413cd94c9e62a';

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

/// See also [getProductDetails].
@ProviderFor(getProductDetails)
const getProductDetailsProvider = GetProductDetailsFamily();

/// See also [getProductDetails].
class GetProductDetailsFamily extends Family<AsyncValue<ProductModel>> {
  /// See also [getProductDetails].
  const GetProductDetailsFamily();

  /// See also [getProductDetails].
  GetProductDetailsProvider call(
    int productId,
  ) {
    return GetProductDetailsProvider(
      productId,
    );
  }

  @override
  GetProductDetailsProvider getProviderOverride(
    covariant GetProductDetailsProvider provider,
  ) {
    return call(
      provider.productId,
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
  String? get name => r'getProductDetailsProvider';
}

/// See also [getProductDetails].
class GetProductDetailsProvider extends FutureProvider<ProductModel> {
  /// See also [getProductDetails].
  GetProductDetailsProvider(
    int productId,
  ) : this._internal(
          (ref) => getProductDetails(
            ref as GetProductDetailsRef,
            productId,
          ),
          from: getProductDetailsProvider,
          name: r'getProductDetailsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getProductDetailsHash,
          dependencies: GetProductDetailsFamily._dependencies,
          allTransitiveDependencies:
              GetProductDetailsFamily._allTransitiveDependencies,
          productId: productId,
        );

  GetProductDetailsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.productId,
  }) : super.internal();

  final int productId;

  @override
  Override overrideWith(
    FutureOr<ProductModel> Function(GetProductDetailsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetProductDetailsProvider._internal(
        (ref) => create(ref as GetProductDetailsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        productId: productId,
      ),
    );
  }

  @override
  FutureProviderElement<ProductModel> createElement() {
    return _GetProductDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetProductDetailsProvider && other.productId == productId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, productId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetProductDetailsRef on FutureProviderRef<ProductModel> {
  /// The parameter `productId` of this provider.
  int get productId;
}

class _GetProductDetailsProviderElement
    extends FutureProviderElement<ProductModel> with GetProductDetailsRef {
  _GetProductDetailsProviderElement(super.provider);

  @override
  int get productId => (origin as GetProductDetailsProvider).productId;
}

String _$getProductSubtypesHash() =>
    r'b04ad0d7e6bcc96677c8a511957aaa7964cd5acb';

/// See also [getProductSubtypes].
@ProviderFor(getProductSubtypes)
final getProductSubtypesProvider =
    FutureProvider<List<AnimalTypeModel>>.internal(
  getProductSubtypes,
  name: r'getProductSubtypesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getProductSubtypesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetProductSubtypesRef = FutureProviderRef<List<AnimalTypeModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
