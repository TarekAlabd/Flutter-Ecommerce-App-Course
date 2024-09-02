import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/location_item_model.dart';
import 'package:flutter_ecommerce_app/services/auth_services.dart';
import 'package:flutter_ecommerce_app/services/location_services.dart';

part 'choose_location_state.dart';

class ChooseLocationCubit extends Cubit<ChooseLocationState> {
  ChooseLocationCubit() : super(ChooseLocationInitial());

  final locationServices = LocationServicesImpl();
  final authServices = AuthServicesImpl();

  String? selectedLocationId;
  LocationItemModel? selectedLocation;

  Future<void> fetchLocations() async {
    emit(FetchingLocations());
    try {
      final currentUser = authServices.currentUser();
      final locations = await locationServices.fetchLocations(currentUser!.uid);
      for (var location in locations) {
        if (location.isChosen) {
          selectedLocationId = location.id;
          selectedLocation = location;
        }
      }
      selectedLocationId ??= locations.first.id;
      selectedLocation ??= locations.first;
      emit(FetchedLocations(locations));
      emit(LocationChosen(selectedLocation!));
    } catch (e) {
      emit(FetchLocationsFailure(e.toString()));
    }
  }

  Future<void> addLocation(String location) async {
    emit(AddingLocation());
    try {
      final splittedLocations = location.split('-');
      final locationItem = LocationItemModel(
        id: DateTime.now().toIso8601String(),
        city: splittedLocations[0],
        country: splittedLocations[1],
      );
      final currentUser = authServices.currentUser();
      await locationServices.setLocation(locationItem, currentUser!.uid);
      emit(LocationAdded());
      final locations = await locationServices.fetchLocations(currentUser.uid);
      emit(FetchedLocations(locations));
    } catch (e) {
      emit(LocationAddingFailure(e.toString()));
    }
  }

  Future<void> selectLocation(String id) async {
    selectedLocationId = id;
    final currentUser = authServices.currentUser();
    final chosenLocation =
        await locationServices.fetchLocation(currentUser!.uid, id);
    selectedLocation = chosenLocation;
    emit(LocationChosen(chosenLocation));
  }

  Future<void> confirmAddress() async {
    emit(ConfirmAddressLoading());
    try {
      final currentUser = authServices.currentUser();
      var previousChosenLocations =
          await locationServices.fetchLocations(currentUser!.uid, true);
      if (previousChosenLocations.isNotEmpty) {
        var previousLocation = previousChosenLocations.first;
        previousLocation = previousLocation.copyWith(isChosen: false);
        await locationServices.setLocation(previousLocation, currentUser.uid);
        await locationServices.setLocation(previousLocation, currentUser.uid);
      }
      selectedLocation = selectedLocation!.copyWith(isChosen: true);
      await locationServices.setLocation(selectedLocation!, currentUser.uid);
      emit(ConfirmAddressLoaded());
    } catch (e) {
      emit(ConfirmAddressFailure(e.toString()));
    }
  }
}
