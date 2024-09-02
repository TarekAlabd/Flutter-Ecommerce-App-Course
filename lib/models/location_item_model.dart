class LocationItemModel {
  final String id;
  final String city;
  final String country;
  final String imgUrl;
  final bool isChosen;

  LocationItemModel({
    required this.id,
    required this.city,
    required this.country,
    this.isChosen = false,
    this.imgUrl =
        'https://previews.123rf.com/images/emojoez/emojoez1903/emojoez190300018/119684277-illustrations-design-concept-location-maps-with-road-follow-route-for-destination-drive-by-gps.jpg',
  });

  LocationItemModel copyWith({
    String? id,
    String? city,
    String? country,
    String? imgUrl,
    bool? isChosen,
  }) {
    return LocationItemModel(
      id: id ?? this.id,
      city: city ?? this.city,
      country: country ?? this.country,
      imgUrl: imgUrl ?? this.imgUrl,
      isChosen: isChosen ?? this.isChosen,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'city': city});
    result.addAll({'country': country});
    result.addAll({'imgUrl': imgUrl});
    result.addAll({'isChosen': isChosen});
  
    return result;
  }

  factory LocationItemModel.fromMap(Map<String, dynamic> map) {
    return LocationItemModel(
      id: map['id'] ?? '',
      city: map['city'] ?? '',
      country: map['country'] ?? '',
      imgUrl: map['imgUrl'] ?? '',
      isChosen: map['isChosen'] ?? false,
    );
  }
}

List<LocationItemModel> dummyLocations = [
  LocationItemModel(
    id: '1',
    city: 'Cairo',
    country: 'Egypt',
  ),
  LocationItemModel(
    id: '2',
    city: 'Giza',
    country: 'Egypt',
  ),
  LocationItemModel(
    id: '3',
    city: 'Alexandria',
    country: 'Egypt',
  ),
];
