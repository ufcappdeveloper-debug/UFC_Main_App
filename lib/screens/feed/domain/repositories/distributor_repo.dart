import '../../infrastructure/data_sources/distributor/distributor_data_source.dart';

/// Distributor channel (browse, cart, checkout, favorites).
/// Same contract as the remote data source; errors surface as
/// `DistributorApiException`.
abstract class DistributorRepository implements DistributorRemoteDataSource {}
