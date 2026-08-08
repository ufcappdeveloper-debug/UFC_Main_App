import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/models/ticket_issues_model.dart';
import '../../data/ticket_service.dart';
part "ticket.g.dart";

@riverpod
class Ticket extends _$Ticket {
  late TicketService _ticketService;
  @override
  FutureOr<List<TicketIssuesModel>> build() async {
    _ticketService = TicketService();
    return [];
  }

  Future<void> getIssues() async {
    state = const AsyncValue.loading();
    try {
      final ticketIssueList = await _ticketService.getTicketIssues();
      state = AsyncValue.data(ticketIssueList);
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  // Future<void> createTicket() async {
  //   // state = const AsyncValue.loading();
  //   try {
  //     final result = await _ticketService;

  //     final ticketIssueList = await _ticketService.getTicketIssues();
  //     state = AsyncValue.data(ticketIssueList);
  //   } catch (e) {
  //     state = AsyncValue.error(e.toString(), StackTrace.current);
  //   }
  // }
}
