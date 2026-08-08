import 'package:ufc_mobile/global/util/common/common_utils.dart';
import 'package:ufc_mobile/screens/farm/domain/entities/barn/barn_model.dart';
import 'package:ufc_mobile/screens/farm/domain/entities/livestock/live_stock_vaccine_model.dart';
import 'package:ufc_mobile/screens/farm/domain/entities/livestock/predefined_animal_list_model.dart';

class LiveStockDetailsModel {
  List<PredefinedAnimalDetails>? predefinedAnimalDetails;
  List<AnimalDetailsAsAnswer>? animalDetailsAsAnswer;
  List<Vaccinations>? vaccinations;
  BarnModel? barn;
  ReportAnswers? reportAnswers;
  DeathRecord? deathRecord;

  LiveStockDetailsModel({
    this.predefinedAnimalDetails,
    this.animalDetailsAsAnswer,
    this.vaccinations,
    this.barn,
    this.reportAnswers,
    this.deathRecord,
  });

  LiveStockDetailsModel.fromJson(Map<String, dynamic> json) {
    if (json['predefined_animal_details'] != null) {
      predefinedAnimalDetails = <PredefinedAnimalDetails>[];
      animalDetailsAsAnswer = <AnimalDetailsAsAnswer>[];
      json['predefined_animal_details'].forEach((v) {
        predefinedAnimalDetails!.add(PredefinedAnimalDetails.fromJson(v));
        animalDetailsAsAnswer!.add(AnimalDetailsAsAnswer.fromJson(v));
      });
    }
    if (json['vaccinations'] != null) {
      vaccinations = <Vaccinations>[];
      json['vaccinations'].forEach((v) {
        vaccinations!.add(Vaccinations.fromJson(v));
      });
    }
    barn = json['barn'] != null ? BarnModel.fromJson(json['barn']) : null;
    if (json['death_record'] is Map<String, dynamic>) {
      deathRecord = DeathRecord.fromJson(json['death_record']);
    } else {
      deathRecord = null;
    }

    if (json['report_answers'] is Map<String, dynamic>) {
      reportAnswers = ReportAnswers.fromJson(json['report_answers']);
    } else {
      reportAnswers = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (predefinedAnimalDetails != null) {
      data['predefined_animal_details'] =
          predefinedAnimalDetails!.map((v) => v.toJson()).toList();
    }
    if (vaccinations != null) {
      data['vaccinations'] = vaccinations!.map((v) => v.toJson()).toList();
    }
    if (barn != null) {
      data['barn'] = barn!.toJson();
    }
    if (reportAnswers != null) {
      data['report_answers'] = reportAnswers;
    }
    return data;
  }
}

class LiveStockDetailsResponse {
  String? status;
  String? message;
  LiveStockDetailsModel? data;

  LiveStockDetailsResponse({this.status, this.message, this.data});

  LiveStockDetailsResponse.fromJson(Map<String, dynamic> json) {
    status = parseString(json['status']);
    message = parseString(json['message']);
    data = json['data'] != null
        ? LiveStockDetailsModel.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ReportAnswers {
  Map<String, dynamic>? reports;

  ReportAnswers({this.reports});

  ReportAnswers.fromJson(Map<String, dynamic> json) {
    reports = json.map((key, value) => MapEntry(key, value));
  }

  Map<String, dynamic> toJson() {
    return reports ?? {};
  }
}

class DeathRecord {
  DateTime? date;
  String? reason;
  int? id;

  DeathRecord({this.date, this.reason, this.id});

  DeathRecord.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '');
    date = DateTime.tryParse(json['death_date']?.toString() ?? '');
    reason = parseString(json['death_reason']);
  }
}
