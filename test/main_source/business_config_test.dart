import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ufc_mobile/global/util/dio/business_mode_events.dart';
import 'package:ufc_mobile/main.dart' as app;
import 'package:ufc_mobile/screens/feed/application/business_config/business_config_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/feed_channel/feed_channel_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/feed_channel/feed_channel_state.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/main_source/business_config_model.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/data_sources/main_source/main_source_data_source_impl.dart';

import 'fake_main_source_repo.dart';

/// Plan §1 examples.
const mainSourceJson = {
  'mode': 'main_source',
  'main_source_enabled': true,
  'stations_enabled': false,
  'distributors_enabled': false,
  'main_sources': [
    {
      'id': 1,
      'name_en': 'UFC Main Source',
      'name_ar': 'المصدر الرئيسي',
      'name_ur': null,
      'icon': 'https://x/main_source_images/icon.png',
      'photo': 'https://x/main_source_images/photo.jpg',
      'phone': '0500000000',
      'email': 'main@ufc-app.com',
      'supports_delivery': true,
      'supports_pickup': false,
      'payment_methods': ['CASH', 'SADAD', 'MADA', 'WALLET'],
    }
  ],
};

const marketplaceJson = {
  'mode': 'marketplace',
  'main_source_enabled': false,
  'stations_enabled': true,
  'distributors_enabled': true,
  'main_sources': [],
};

final mainSourceConfig = BusinessConfigModel.fromJson(
    jsonDecode(jsonEncode(mainSourceJson)) as Map<String, dynamic>);
final marketplaceConfig = BusinessConfigModel.fromJson(
    jsonDecode(jsonEncode(marketplaceJson)) as Map<String, dynamic>);

void main() {
  group('BusinessConfigModel.fromJson', () {
    test('main source mode', () {
      final c = mainSourceConfig;
      expect(c.mode, 'main_source');
      expect(c.isMainSource, isTrue);
      expect(c.stationsEnabled, isFalse);
      expect(c.distributorsEnabled, isFalse);
      expect(c.mainSources, hasLength(1));
      final s = c.mainSources.first;
      expect(s.id, 1);
      expect(s.nameAr, 'المصدر الرئيسي');
      expect(s.nameUr, isNull);
      expect(s.paymentMethods, ['CASH', 'SADAD', 'MADA', 'WALLET']);
      expect(s.supportsPickup, isFalse);
    });

    test('marketplace mode', () {
      final c = marketplaceConfig;
      expect(c.isMainSource, isFalse);
      expect(c.stationsEnabled, isTrue);
      expect(c.distributorsEnabled, isTrue);
      expect(c.mainSources, isEmpty);
    });

    test('toJson round trip (cache)', () {
      final again = BusinessConfigModel.fromJson(
          jsonDecode(jsonEncode(mainSourceConfig.toJson())));
      expect(again, mainSourceConfig);
      expect(again.mainSources.first.phone, '0500000000');
    });

    test('defaults are marketplace with both cards', () {
      expect(BusinessConfigModel.defaults.isMainSource, isFalse);
      expect(BusinessConfigModel.defaults.stationsEnabled, isTrue);
      expect(BusinessConfigModel.defaults.distributorsEnabled, isTrue);
    });
  });

  group('error mapping', () {
    test('code and extra fields are kept', () {
      final e = MainSourceRemoteDataSourceImpl.toMainSourceException(
        DioException(
          requestOptions: RequestOptions(path: '/x'),
          response: Response(
            requestOptions: RequestOptions(path: '/x'),
            statusCode: 422,
            data: {
              'status': 'fail',
              'code': 'SADAD_MIN_AMOUNT',
              'message': 'The amount to pay by SADAD must be at least 50.00 SAR',
              'sadad_min_amount': 50,
            },
          ),
        ),
      );
      expect(e.code, 'SADAD_MIN_AMOUNT');
      expect(e.statusCode, 422);
      expect(e.sadadMinAmount, 50);
    });

    test('400 with errors becomes VALIDATION', () {
      final e = MainSourceRemoteDataSourceImpl.toMainSourceException(
        DioException(
          requestOptions: RequestOptions(path: '/x'),
          response: Response(
            requestOptions: RequestOptions(path: '/x'),
            statusCode: 400,
            data: {
              'message': 'Required fields are missing',
              'errors': {
                'latitude': ['The latitude field must be between -90 and 90.']
              },
            },
          ),
        ),
      );
      expect(e.isValidation, isTrue);
      expect(e.firstFieldError,
          'The latitude field must be between -90 and 90.');
    });
  });

  group('BusinessConfigCubit', () {
    late FakeMainSourceRepository repo;
    late SharedPreferences prefs;
    late StreamController<BusinessModeDisabledEvent> events;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      repo = FakeMainSourceRepository();
      events = StreamController<BusinessModeDisabledEvent>.broadcast();
    });

    tearDown(() => events.close());

    BusinessConfigCubit build({DateTime Function()? now}) =>
        BusinessConfigCubit(repo,
            prefs: prefs, modeDisabledEvents: events.stream, now: now);

    test('load: loaded and cached', () async {
      repo.onGetBusinessConfig = () async => mainSourceConfig;
      final cubit = build();
      await cubit.load();
      expect(cubit.state.status, BusinessConfigStatus.loaded);
      expect(cubit.isMainSource, isTrue);
      expect(prefs.getString(BusinessConfigCubit.cacheKey), isNotNull);
      await cubit.close();
    });

    test('offline without cache: marketplace defaults', () async {
      repo.onGetBusinessConfig = () async => throw Exception('offline');
      final cubit = build();
      await cubit.load();
      expect(cubit.state.status, BusinessConfigStatus.error);
      expect(cubit.state.config, BusinessConfigModel.defaults);
      await cubit.close();
    });

    test('offline with cache: cached value', () async {
      await prefs.setString(
          BusinessConfigCubit.cacheKey, jsonEncode(mainSourceConfig.toJson()));
      repo.onGetBusinessConfig = () async => throw Exception('offline');
      final cubit = build();
      // The cached value is usable before the first fetch.
      expect(cubit.isMainSource, isTrue);
      await cubit.load();
      expect(cubit.isMainSource, isTrue);
      expect(cubit.state.fromCache, isTrue);
      await cubit.close();
    });

    test('concurrent loads share one request', () async {
      final completer = Completer<BusinessConfigModel>();
      repo.onGetBusinessConfig = () => completer.future;
      final cubit = build();
      final a = cubit.load();
      final b = cubit.ensureLoaded();
      completer.complete(marketplaceConfig);
      await Future.wait([a, b]);
      expect(repo.calls, ['getBusinessConfig']);
      await cubit.ensureLoaded(); // already loaded: no call
      expect(repo.calls, hasLength(1));
      await cubit.close();
    });

    test('reloadIfStale only after 10 minutes', () async {
      var now = DateTime(2026, 11, 21, 10);
      repo.onGetBusinessConfig = () async => marketplaceConfig;
      final cubit = build(now: () => now);
      await cubit.load();
      now = now.add(const Duration(minutes: 5));
      await cubit.reloadIfStale();
      expect(repo.calls, hasLength(1));
      now = now.add(const Duration(minutes: 6));
      await cubit.reloadIfStale();
      expect(repo.calls, hasLength(2));
      await cubit.close();
    });

    test('BUSINESS_MODE_DISABLED: event id bumps and config reloads',
        () async {
      repo.onGetBusinessConfig = () async => marketplaceConfig;
      final cubit = build();
      await cubit.load();
      repo.onGetBusinessConfig = () async => mainSourceConfig;
      events.add(const BusinessModeDisabledEvent(
          business: 'distributors', message: 'closed'));
      await Future<void>.delayed(Duration.zero);
      await cubit.load();
      expect(cubit.state.modeDisabledEventId, 1);
      expect(cubit.isMainSource, isTrue);
      await cubit.close();
    });
  });

  group('BusinessModeEvents.reportIfDisabled', () {
    test('only 403 with the code', () async {
      final got = <BusinessModeDisabledEvent>[];
      final sub = BusinessModeEvents.stream.listen(got.add);
      BusinessModeEvents.reportIfDisabled(422, {'code': 'BUSINESS_MODE_DISABLED'});
      BusinessModeEvents.reportIfDisabled(403, {'code': 'OTHER'});
      BusinessModeEvents.reportIfDisabled(403, {
        'code': 'BUSINESS_MODE_DISABLED',
        'business': 'main_source',
        'message': 'Main Source is not accepting new orders at the moment',
      });
      await Future<void>.delayed(Duration.zero);
      expect(got, hasLength(1));
      expect(got.first.business, 'main_source');
      await sub.cancel();
    });
  });

  group('FeedChannelCubit with business config', () {
    late FakeMainSourceRepository repo;

    setUp(() async {
      SharedPreferences.setMockInitialValues({'feed_channel': 'distributor'});
      app.preferences = await SharedPreferences.getInstance();
      repo = FakeMainSourceRepository();
    });

    test('main source mode forces the channel and blocks other choices',
        () async {
      repo.onGetBusinessConfig = () async => mainSourceConfig;
      final config = BusinessConfigCubit(repo,
          prefs: app.preferences, modeDisabledEvents: const Stream.empty());
      final channel = FeedChannelCubit(businessConfig: config);
      expect(channel.state.channel, FeedChannel.distributor);
      await config.load();
      await Future<void>.delayed(Duration.zero);
      expect(channel.state.channel, FeedChannel.mainSource);
      await channel.setChannel(FeedChannel.station);
      expect(channel.state.channel, FeedChannel.mainSource);
      await channel.close();
      await config.close();
    });

    test('back to marketplace restores the saved channel', () async {
      repo.onGetBusinessConfig = () async => mainSourceConfig;
      final config = BusinessConfigCubit(repo,
          prefs: app.preferences, modeDisabledEvents: const Stream.empty());
      final channel = FeedChannelCubit(businessConfig: config);
      await config.load();
      await Future<void>.delayed(Duration.zero);
      repo.onGetBusinessConfig = () async => marketplaceConfig;
      await config.load();
      await Future<void>.delayed(Duration.zero);
      expect(channel.state.channel, FeedChannel.distributor);
      await channel.close();
      await config.close();
    });

    test('a disabled channel is replaced by the enabled one', () {
      final channel = FeedChannelCubit();
      channel.applyBusinessConfig(const BusinessConfigModel(
          stationsEnabled: true, distributorsEnabled: false));
      expect(channel.state.channel, FeedChannel.station);
      channel.close();
    });
  });
}
