class Store {
  final int id;
  final String name;
  final double? longitude;
  final double? latitude;
  final double? distance;

  Store({
    required this.id,
    required this.name,
     this.longitude,
     this.latitude,
     this.distance,
  });

  factory Store.fromMap(Map<String, dynamic> map) {
    return Store(
      id: map['id'],
      name: map['name'],
      longitude: map['longitude'],
      latitude: map['latitude'],
      distance: map['distance'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'longitude': longitude,
      'latitude': latitude,
      'distance': distance,
    };
  }
}
