import 'dart:convert';

BooleanResponseModel welcomeFromJson(String str) =>
    BooleanResponseModel.fromJson(json.decode(str));

String welcomeToJson(BooleanResponseModel data) => json.encode(data.toJson());

class BooleanResponseModel {
  BooleanResponseModel({
    required this.errors,
  });

  List<String> errors;


  factory BooleanResponseModel.fromJson(Map<String, dynamic> json) => BooleanResponseModel(
    errors: List<String>.from(json["Errors"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Errors": List<dynamic>.from(errors.map((x) => x)),
  };
}


class ValueResponse {
  DateTime timestamp;
  num value;
  String unitsAbbreviation;
  bool good;
  bool questionable;
  bool substituted;
  bool annotated;

  ValueResponse({
    required this.timestamp,
    required this.value,
    required this.unitsAbbreviation,
    required this.good,
    required this.questionable,
    required this.substituted,
    required this.annotated,
  });

  factory ValueResponse.fromJson(Map<String, dynamic> json) => ValueResponse(
    timestamp: DateTime.parse(json["Timestamp"]),
    value: json["Value"],
    unitsAbbreviation: json["UnitsAbbreviation"],
    good: json["Good"],
    questionable: json["Questionable"],
    substituted: json["Substituted"],
    annotated: json["Annotated"],
  );

  Map<String, dynamic> toJson() => {
    "Timestamp": timestamp.toIso8601String(),
    "Value": value,
    "UnitsAbbreviation": unitsAbbreviation,
    "Good": good,
    "Questionable": questionable,
    "Substituted": substituted,
    "Annotated": annotated,
  };
}