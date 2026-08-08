import 'package:equatable/equatable.dart';

import '../../domain/entities/address/profile_address_model.dart';

abstract class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object?> get props => [];
}

class AddressInitial extends AddressState {}

class AddressLoading extends AddressState {}

class AddressLoaded extends AddressState {
  final List<ProfileAddressModel>? addresses;
  final ProfileAddressModel? defaultAddress;
  const AddressLoaded({this.addresses, this.defaultAddress});

  @override
  List<Object?> get props => [addresses];
}

class AddressSuccess extends AddressState {
  final String message;
  const AddressSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AddressError extends AddressState {
  final Object message;
  const AddressError(this.message);

  @override
  List<Object?> get props => [message];
}
