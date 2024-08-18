import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:route_nxt/features/common/data/data_sources/auth_service.dart';
import 'package:route_nxt/features/inventory/data/data_sources/inventory_service.dart';
import 'package:route_nxt/features/inventory/data/models/product_model.dart';

part 'map_state.dart';

part 'map_cubit.freezed.dart';

class MapCubit extends Cubit<MapState> {
  final FirebaseFunctions _firebaseFunctions;
  final InventoryService _inventoryService;
  final AuthService _authService;

  MapCubit(this._firebaseFunctions, this._inventoryService, this._authService)
      : super(const MapState.initial());

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
      var currentUser = _authService.getCurrentUser();
      if (null != currentUser) {
        List<ProductModel> productList =
            await _inventoryService.getAllActiveProducts(currentUser.uid);
        getCurrentLocation(location, productList);
      } else {
        throw Exception("Internal Server Error");
      }
    } catch (e) {
      emit(const MapState.loadingFailed("Map loading failed"));
    }
  }

  Future<void> getCurrentLocation(
      Location location, List<ProductModel> productList) async {
    var currentLocation = await location.getLocation();
    emit(MapState.loaded(currentLocation, location, productList));
  }

  Future<void> getPolyline(LatLng source, LatLng destination) async {
    try {
      emit(const MapState.polylineLoading());
      _firebaseFunctions.useFunctionsEmulator("192.168.8.108", 5001);
      final result =
          await _firebaseFunctions.httpsCallable('optimizeRoute').call(
        {
          "source": {
            "latitude": source.latitude,
            "longitude": source.longitude
          },
          "destination": {
            "latitude": destination.latitude,
            "longitude": destination.longitude
          },
        },
      );
      List<dynamic> data = result.data;

      List<LatLng> polyline = data.map((item) {
        return LatLng(item[0], item[1]);
      }).toList();
      emit(MapState.polylineLoaded(polyline));
    } catch (e) {
      emit(const MapState.polylineLoadingFailed("Route Optimizing Failed"));
    }
  }
}
