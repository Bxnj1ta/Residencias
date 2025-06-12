// To parse this JSON data, do
//
//     final residencia = residenciaFromJson(jsonString);

// archivo en deshuso, pero vale dejarlo para futuras implementaciones

import 'dart:convert';

Residencia residenciaFromJson(String str) => Residencia.fromJson(json.decode(str));

String residenciaToJson(Residencia data) => json.encode(data.toJson());

class Residencia {
    final String name;
    final String image;
    final String city;
    final String commune;
    final String address;
    final double latitude;
    final double length;

    Residencia({
        required this.name,
        required this.image,
        required this.city,
        required this.commune,
        required this.address,
        required this.latitude,
        required this.length,
    });

    factory Residencia.fromJson(Map<String, dynamic> json) => Residencia(
        name: json["name"],
        image: json["image"],
        city: json["city"],
        commune: json["commune"],
        address: json["address"],
        latitude: json["latitude"]?.toDouble(),
        length: json["length"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "image": image,
        "city": city,
        "commune": commune,
        "address": address,
        "latitude": latitude,
        "length": length,
    };
}
