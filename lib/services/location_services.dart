import 'package:flutter_ecommerce_app/models/location_item_model.dart';
import 'package:flutter_ecommerce_app/services/firestore_services.dart';
import 'package:flutter_ecommerce_app/utils/api_paths.dart';

abstract class LocationServices {
  Future<List<LocationItemModel>> fetchLocations(String userId,
      [bool chosen = false]);
  Future<void> setLocation(LocationItemModel location, String userId);
  Future<LocationItemModel> fetchLocation(String userId, String locationId);
}

class LocationServicesImpl implements LocationServices {
  final firestoreServices = FirestoreServices.instance;

  @override
  Future<void> setLocation(LocationItemModel location, String userId) async =>
      await firestoreServices.setData(
        path: ApiPaths.location(userId, location.id),
        data: location.toMap(),
      );

  @override
  Future<List<LocationItemModel>> fetchLocations(String userId,
          [bool chosen = false]) async =>
      await firestoreServices.getCollection(
        path: ApiPaths.locations(userId),
        builder: (data, documentId) => LocationItemModel.fromMap(data),
        queryBuilder:
            chosen ? (query) => query.where('isChosen', isEqualTo: true) : null,
      );

  @override
  Future<LocationItemModel> fetchLocation(
          String userId, String locationId) async =>
      await firestoreServices.getDocument(
        path: ApiPaths.location(userId, locationId),
        builder: (data, documentId) => LocationItemModel.fromMap(data),
      );
}
