import 'package:flutter_ecommerce_app/models/location_item_model.dart';
import 'package:flutter_ecommerce_app/services/firestore_services.dart';
import 'package:flutter_ecommerce_app/utils/api_paths.dart';

abstract class LocationServices {
  Future<List<LocationItemModel>> fetchLocations(String userId);
  Future<void> addLocation(LocationItemModel location, String userId);
}

class LocationServicesImpl implements LocationServices {
  final firestoreServices = FirestoreServices.instance;

  @override
  Future<void> addLocation(LocationItemModel location, String userId) async =>
      await firestoreServices.setData(
        path: ApiPaths.location(userId, location.id),
        data: location.toMap(),
      );

  @override
  Future<List<LocationItemModel>> fetchLocations(String userId) {
    // TODO: implement fetchLocations
    throw UnimplementedError();
  }
}
