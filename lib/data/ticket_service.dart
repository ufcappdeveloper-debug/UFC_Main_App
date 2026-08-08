import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ufc_mobile/models/create_ticket_model/create_ticket_model.dart';

import '../global/config/dio.dart';
import '../models/ticket_issues_model.dart';
import '../models/ticket_model/ticket_model.dart';

class TicketService {
  Future<List<TicketIssuesModel>> getTicketIssues() async {
    Response response = await api.get('/api/ufc/v1/ticket/get_ticket_issues');

    return (response.data["data"] as List<dynamic>)
        .map((e) => TicketIssuesModel.fromJson(e))
        .toList();
  }

  Future<List<TicketModel>> getTickets(final data) async {
    Response response =
        await api.get('/api/ufc/v1/ticket/get_tickets', data: data);

    return (response.data["data"]["data"] as List<dynamic>)
        .map((e) => TicketModel.fromJson(e))
        .toList();
  }

  Future<CreateTicketModel> createTicket(
      {File? image,
      required String details,
      required String? orderId,
      required int? issueId}) async {
    final data = {
      "order_id": orderId,
      "issue_id": issueId,
      "details": details,
    };

    final formData = FormData.fromMap(data);

    if (image != null) {
      formData.files
          .add(MapEntry("image", await MultipartFile.fromFile(image.path)));
    }

    Response response =
        await api.post("/api/ufc/v1/ticket/create_ticket", data: formData);
    log("new ${response.data['data']}");
    log("new ${response.data['status']}");
    // print(response.data['status']);
    // print(response.data['data']);
    // log("new ${CreateTicketModel.fromJson(response.data['data'])}");
    return CreateTicketModel.fromJson(response.data);

    //response.data["status"];
    // final ticketModel = Data.fromJson(response.data['data']);
    // print(ticketModel);
    //return ticketModel;
  }

// Future<List<TicketIssuesModel>> getTicketIssues() async {
//     Response response = await api.get('/api/ufc/v1/ticket/get_ticket_issues');

//     return (response.data["data"] as List<dynamic>)
//         .map((e) => TicketIssuesModel.fromJson(e))
//         .toList();
//   }
}
