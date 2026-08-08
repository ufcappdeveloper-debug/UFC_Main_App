class DonutChartModel {
  final int? value;
  final double? percentageChange;
  final String? title;
  final String? id;

  DonutChartModel({
    this.value,
    this.percentageChange,
    this.title,
    this.id,
  });

  factory DonutChartModel.fromJson(Map<String, dynamic> json) {
    return DonutChartModel(
      value: int.tryParse(json['value']?.toString()??''),
      percentageChange: double.tryParse(json['percentageChange']?.toString()??''),
      title: json['title']?.toString(),
      id: json['id']?.toString(),
    );
  }
}
