class Residencia {
  final String name;
  final String image;
  final String city;
  final String commune;
  final String address;
  final double latitude;
  final double longitude;

  Residencia({
    required this.name,
    required this.image,
    required this.city,
    required this.commune,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'image': image,
    'city': city,
    'commune': commune,
    'address': address,
    'latitude': latitude,
    'length': longitude,
  };
}
