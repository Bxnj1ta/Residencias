// To parse this JSON data, do
//
//     final estado = estadoFromJson(jsonString);

import 'dart:convert';

Estado estadoFromJson(String str) => Estado.fromJson(json.decode(str));

String estadoToJson(Estado data) => json.encode(data.toJson());

class Estado {
    final int homeScheduleId;
    final String homeScheduleState;

    Estado({
        required this.homeScheduleId,
        required this.homeScheduleState,
    });

    factory Estado.fromJson(Map<String, dynamic> json) => Estado(
        homeScheduleId: json["home_schedule_id"],
        homeScheduleState: json["home_schedule_state"],
    );

    Map<String, dynamic> toJson() => {
        "home_schedule_id": homeScheduleId,
        "home_schedule_state": homeScheduleState,
    };
}
