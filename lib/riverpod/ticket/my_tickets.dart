import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';

import '../../data/ticket_service.dart';
import '../../models/ticket_model/ticket_model.dart';

part "my_tickets.g.dart";

@riverpod
class Tickets extends _$Tickets {
  late TicketService _ticketService;
  @override
  FutureOr<List<TicketModel>> build() async {
    _ticketService = TicketService();
    return [];
  }

  Future<void> getTickets() async {
    state = const AsyncValue.loading();
    final Map<String, dynamic> data = {
      "page": 1,
      "limit": 10,
    };

    try {
      final ticketsList = await _ticketService.getTickets(data);
      state = AsyncValue.data(ticketsList);
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<void> initialLoad(int page, int limit) async {
    final Map<String, dynamic> data = {
      "page": page,
      "limit": limit,
    };
    state = const AsyncValue.loading();
    try {
      final savedAddressList = await _ticketService.getTickets(data);
      state = AsyncValue.data(savedAddressList);
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  // Future<bool> loadTickets(int page, int limit) async {
  //   final Map<String, dynamic> data = {
  //     "page": page,
  //     "limit": limit,
  //   };
  //   try {
  //     final myTicketsList = await _ticketService.getTickets(data);
  //     if (myTicketsList.isEmpty || myTicketsList.length < limit) {
  //       return false;
  //     }

  //     state = AsyncValue.data([...state.value!, ...myTicketsList]);
  //   } catch (e) {
  //     state = AsyncValue.error(e.toString(), StackTrace.current);
  //   }
  //   return true;
  // }
  Future<bool> loadTickets(final int page) async {
    final Map<String, dynamic> data = {
      "page": page,
      "limit": 10,
    };
    try {
      List<TicketModel> result = await _ticketService.getTickets(data);
      if (result.isEmpty) {
        return false;
      }

      state = AsyncValue.data([...state.value!, ...result]);
    } on DioException catch (e) {
      state = AsyncValue.error(e.dioMessage, StackTrace.current);
    } catch (e) {
      log(e.toString());
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
    return true;
  }

  // void addNewTicket() {
  //   state = AsyncValue.data([
  //     ...state.value ?? [],
  //   ]);
  // }

  // void addNewTicket() {
  //   try {
  //     state = AsyncValue.data([
  //       ...state.value!,
  //     ]);
  //   } on DioException catch (e) {
  //     state = AsyncValue.error(e.dioMessage, StackTrace.current);
  //   } catch (e) {
  //     log(e.toString());
  //     state = AsyncValue.error(e.toString(), StackTrace.current);
  //   }
  // }

  void addNewTicket(TicketModel newTicket) {
    state = AsyncValue.data([
      ...state.value ?? [],
    ]);
    final updatedList = [...state.value!, newTicket];
    state = AsyncValue.data(updatedList);
  }
}
