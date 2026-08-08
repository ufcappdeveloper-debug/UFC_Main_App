class PrescriptionModel {
  int? id;
  int? animalId;
  int? doctorBookingId;
  String? visitReason;
  String? instructions;
  String? medicine;
  String? notes;
  String? healthStatus;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  List<FileModel>? files;

  PrescriptionModel({
    this.id,
    this.animalId,
    this.doctorBookingId,
    this.visitReason,
    this.instructions,
    this.medicine,
    this.notes,
    this.healthStatus,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.files,
  });

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionModel(
      id: json['id'],
      animalId: json['animal_id'],
      doctorBookingId: json['doctor_booking_id'],
      visitReason: json['visit_reason'],
      instructions: json['instructions'],
      medicine: json['medicine'],
      notes: json['notes'],
      healthStatus: json['health_status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      files: json['files'] != null
          ? List<FileModel>.from(
              json['files'].map((x) => FileModel.fromJson(x)),
            )
          : [],
    );
  }
}

class FileModel {
  int? id;
  int? prescriptionId;
  String? file;
  String? createdAt;
  String? updatedAt;

  FileModel({
    this.id,
    this.prescriptionId,
    this.file,
    this.createdAt,
    this.updatedAt,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      id: json['id'],
      prescriptionId: json['prescription_id'],
      file: json['file'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
