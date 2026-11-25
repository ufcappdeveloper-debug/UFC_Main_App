import '../../infrastructure/data_sources/main_source/main_source_data_source.dart';

/// Main Source business (catalogue, cart, checkout, orders). Same contract
/// as the remote data source; errors surface as `MainSourceApiException`.
abstract class MainSourceRepository implements MainSourceRemoteDataSource {}
