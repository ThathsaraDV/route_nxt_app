import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:location/location.dart';

part 'map_state.dart';

part 'map_cubit.freezed.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit() : super(const MapState.initial());

  Future<void> init() async {
    try {
      emit(const MapState.loading());
      Location location = Location();
      var hasPermission = await location.hasPermission();
      if (PermissionStatus.denied == hasPermission) {
        hasPermission = await location.requestPermission();
        if (PermissionStatus.denied == hasPermission) {
          emit(const MapState.loadingFailed("Please grant permission"));
        }
      }
      var serviceEnabled = await location.serviceEnabled();
      if (serviceEnabled) {
        getCurrentLocation(location);
      } else {
        var bool = await location.requestService();
        if (bool) {
          getCurrentLocation(location);
        } else {
          const MapState.loadingFailed("Please enable location");
        }
      }
    } catch (e) {
      emit(const MapState.loadingFailed("Map loading failed"));
    }
  }

  void getCurrentLocation(Location location) {
    location.getLocation().then(
      (currLocation) {
        emit(MapState.loaded(currLocation, location));
      },
    );
  }

}
