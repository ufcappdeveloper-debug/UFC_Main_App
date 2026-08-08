import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/global/util/exception/error_handler.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/order/order_details_query_params.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/order/order_list_res_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/order/order_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/order/order_query_params.dart';
import 'package:ufc_mobile/screens/feed/domain/failure/failure.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/my_orders_usecase.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/order_details_usecase.dart';

import 'my_orders_state.dart';

class MyOrdersCubit extends Cubit<MyOrdersState> {
  final GetMyOrdersUseCase getMyOrdersUseCase;
  final GetOrderDetailsUseCase getOrderDetailsUseCase;

  MyOrdersCubit(
    this.getMyOrdersUseCase,
    this.getOrderDetailsUseCase,
  ) : super(MyOrdersInitial());

  final List<OrderModel> orders = [];

  /// Pagination info
  OrderListModel? pagination;
  OrderModel? selectedOrder;

  OrderQueryParams _currentParams = const OrderQueryParams();


  /// Fetch products initially or with filters
  Future<void> getMyOrders({OrderQueryParams? params}) async {
    emit(MyOrdersLoading());

    _currentParams = params ?? _currentParams.copyWith(page: 1);

    try {
      final response = await getMyOrdersUseCase(_currentParams);

      // Update list and pagination
      orders
        ..clear()
        ..addAll(response?.data ?? []);
      pagination = response;

      emit(MyOrdersLoaded(
        orders: orders,
        currentPage: pagination?.currentPage ?? 1,
        lastPage: pagination?.lastPage ?? 1,
        hasReachedEnd:
            (pagination?.currentPage ?? 1) >= (pagination?.lastPage ?? 1),
      ));
    } on Failure catch (f) {
      emit(MyOrdersError(f.message));
    } catch (e) {
  
    emit(MyOrdersError(ErrorHandler.getErrorMessage(e)));
    }
  }

  /// Load next page
  Future<void> loadMore() async {
    if (pagination == null ||
        (pagination?.currentPage ?? 0) >= (pagination?.lastPage ?? 0)) {
      return;
    }

    _currentParams =
        _currentParams.copyWith(page: (pagination?.currentPage ?? 0) + 1);

    try {
      final response = await getMyOrdersUseCase(_currentParams);

      // Append new data
      orders.addAll(response?.data ?? []);
      pagination = response;

      emit(MyOrdersLoaded(
        orders: orders,
        currentPage: pagination?.currentPage ?? 1,
        lastPage: pagination?.lastPage ?? 1,
        hasReachedEnd:
            (pagination?.currentPage ?? 1) >= (pagination?.lastPage ?? 1),
      ));
    } on Failure catch (f) {
      emit(MyOrdersError(f.message));
    } catch (e) {
    emit(MyOrdersError(ErrorHandler.getErrorMessage(e)));
    }
  }
Future<void> getOrderDetails(int orderId) async {
  emit(MyOrdersLoading());

  try {
    final response = await getOrderDetailsUseCase(
      OrderDetailsQueryParams(orderId: orderId, page: 1, limit: 20),
    );
    
    orders
        ..clear()
        ..addAll(response?.data ?? []);
      pagination = response;
     

      emit(MyOrdersLoaded(
        orders: orders,
        currentPage: pagination?.currentPage ?? 1,
        lastPage: pagination?.lastPage ?? 1,
        hasReachedEnd:
            (pagination?.currentPage ?? 1) >= (pagination?.lastPage ?? 1),
      ));
    } on Failure catch (f) {
      emit(MyOrdersError(f.message));
    } catch (e) {
      emit(MyOrdersError(ErrorHandler.getErrorMessage(e)));
    }
}
}
