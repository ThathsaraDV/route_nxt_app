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
      PermissionStatus permissionStatus = await location.hasPermission();
      if (permissionStatus == PermissionStatus.denied) {
        permissionStatus = await location.requestPermission();
        if (permissionStatus == PermissionStatus.denied) {
          emit(const MapState.loadingFailed("Please grant permission"));
          return;
        }
      }
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          emit(const MapState.loadingFailed("Please enable location"));
          return;
        }
      }
      getCurrentLocation(location);
    } catch (e) {
      emit(const MapState.loadingFailed("Map loading failed"));
    }
  }

  Future<void> getCurrentLocation(Location location) async {
    var currentLocation = await location.getLocation();
    emit(MapState.loaded(currentLocation, location));
  }

}
