import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/location_item_model.dart';
import 'package:flutter_ecommerce_app/services/auth_services.dart';
import 'package:flutter_ecommerce_app/services/location_services.dart';

part 'choose_location_state.dart';

class ChooseLocationCubit extends Cubit<ChooseLocationState> {
  ChooseLocationCubit() : super(ChooseLocationInitial());

  final locationServices = LocationServicesImpl();
  final authServices = AuthServicesImpl();

  String selectedLocationId = dummyLocations.first.id;

  Future<void> fetchLocations() async {
    emit(FetchingLocations());
    try {
      final currentUser = authServices.currentUser();
      final locations = await locationServices.fetchLocations(currentUser!.uid);
      emit(FetchedLocations(locations));
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
      await locationServices.addLocation(locationItem, currentUser!.uid);
      emit(LocationAdded());
      final locations = await locationServices.fetchLocations(currentUser.uid);
      emit(FetchedLocations(locations));
    } catch (e) {
      emit(LocationAddingFailure(e.toString()));
    }
  }

  void selectLocation(String id) {
    selectedLocationId = id;
    final chosenLocation = dummyLocations
        .firstWhere((location) => location.id == selectedLocationId);
    emit(LocationChosen(chosenLocation));
  }

  void confirmAddress() {
    emit(ConfirmAddressLoading());
    Future.delayed(
      const Duration(seconds: 1),
      () {
        var chosenAddress = dummyLocations
            .firstWhere((location) => location.id == selectedLocationId);
        var previousAddress = dummyLocations.firstWhere(
          (location) => location.isChosen == true,
          orElse: () => dummyLocations.first,
        );
        previousAddress = previousAddress.copyWith(isChosen: false);
        chosenAddress = chosenAddress.copyWith(isChosen: true);
        final previousIndex = dummyLocations
            .indexWhere((location) => location.id == previousAddress.id);
        final chosenIndex = dummyLocations
            .indexWhere((location) => location.id == chosenAddress.id);
        dummyLocations[previousIndex] = previousAddress;
        dummyLocations[chosenIndex] = chosenAddress;
        emit(ConfirmAddressLoaded());
      },
    );
  }
}
