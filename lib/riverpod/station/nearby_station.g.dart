// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nearby_station.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$nearByStationHash() => r'0df20caf2ef4223115bf3d9e54db849fe6574a22';

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

/// See also [nearByStation].
@ProviderFor(nearByStation)
const nearByStationProvider = NearByStationFamily();

/// See also [nearByStation].
class NearByStationFamily extends Family<AsyncValue<List<StationModel>>> {
  /// See also [nearByStation].
  const NearByStationFamily();

  /// See also [nearByStation].
  NearByStationProvider call(
    dynamic data,
  ) {
    return NearByStationProvider(
      data,
    );
  }

  @override
  NearByStationProvider getProviderOverride(
    covariant NearByStationProvider provider,
  ) {
    return call(
      provider.data,
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
  String? get name => r'nearByStationProvider';
}

/// See also [nearByStation].
class NearByStationProvider
    extends AutoDisposeFutureProvider<List<StationModel>> {
  /// See also [nearByStation].
  NearByStationProvider(
    dynamic data,
  ) : this._internal(
          (ref) => nearByStation(
            ref as NearByStationRef,
            data,
          ),
          from: nearByStationProvider,
          name: r'nearByStationProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$nearByStationHash,
          dependencies: NearByStationFamily._dependencies,
          allTransitiveDependencies:
              NearByStationFamily._allTransitiveDependencies,
          data: data,
        );

  NearByStationProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.data,
  }) : super.internal();

  final dynamic data;

  @override
  Override overrideWith(
    FutureOr<List<StationModel>> Function(NearByStationRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NearByStationProvider._internal(
        (ref) => create(ref as NearByStationRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        data: data,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<StationModel>> createElement() {
    return _NearByStationProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NearByStationProvider && other.data == data;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, data.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin NearByStationRef on AutoDisposeFutureProviderRef<List<StationModel>> {
  /// The parameter `data` of this provider.
  dynamic get data;
}

class _NearByStationProviderElement
    extends AutoDisposeFutureProviderElement<List<StationModel>>
    with NearByStationRef {
  _NearByStationProviderElement(super.provider);

  @override
  dynamic get data => (origin as NearByStationProvider).data;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
