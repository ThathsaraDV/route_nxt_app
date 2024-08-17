import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart' as gc;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart'
    as pi;
import 'package:location/location.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:route_nxt/config/constants/common_styles.dart';
import 'package:route_nxt/features/common/presentation/widgets/custom_snackbar.dart';
import 'package:route_nxt/features/common/presentation/widgets/empty_widget.dart';
import 'package:route_nxt/features/dashboard/presentation/bloc/map/map_cubit.dart';
import 'package:route_nxt/features/dashboard/presentation/widgets/map/transaction_modal.dart';
import 'package:route_nxt/features/inventory/data/models/product_model.dart';

class MapPage extends StatefulWidget {
  const MapPage({
    super.key,
  });

  @override
  State<MapPage> createState() => _MapPage();
}

// TODO: Validate Optimization if user has no previous transaction date
class _MapPage extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  late Location location;
  LocationData? currentLocation;
  late LatLng destination;
  Set<Marker> markers = {};
  List<LatLng> polylineCoordinates = [];
  bool isStarted = false;
  bool isPickDestination = false;
  String draggedAddress = "";
  List<gc.Placemark>? placeMarks;
  gc.Placemark? address;
  bool isValidDestination = false;
  List<ProductModel> productList = [];
  StreamSubscription<LocationData>? locationSubscription;

  @override
  void initState() {
    super.initState();
    _initializeMapRenderer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MapCubit>().init();
    });
  }

  void _initializeMapRenderer() {
    final pi.GoogleMapsFlutterPlatform mapsImplementation =
        pi.GoogleMapsFlutterPlatform.instance;
    if (mapsImplementation is GoogleMapsFlutterAndroid) {
      mapsImplementation.useAndroidViewSurface = true;
    }
  }

  void getCurrentLocation(
      LocationData currLocation, Location newLocation) async {
    location = newLocation;
    GoogleMapController googleMapController = await _controller.future;
    locationSubscription = location.onLocationChanged.listen(
      (newLoc) {
        currentLocation = newLoc;
        if (isStarted) {
          googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                zoom: 13.5,
                target: LatLng(
                  newLoc.latitude!,
                  newLoc.longitude!,
                ),
              ),
            ),
          );
        }
        if (context.mounted) {
          setState(() {});
        }
      },
    );
  }

  Future _getAddress(LatLng position) async {
    print(
        'Location ==========================> Latitude: ${position.latitude} Longitude: ${position.longitude}');
    try {
      placeMarks = await gc.placemarkFromCoordinates(
          position.latitude, position.longitude);
      isValidDestination = true;
      address = placeMarks![0];
      String addressString =
          "${address!.street},${address!.locality},${address!.administrativeArea}, ${address!.country}";
      setState(() {
        draggedAddress = addressString;
      });
    } catch (e) {
      isValidDestination = false;
    }
  }

  void setPickDestination() {
    setState(() {
      isPickDestination = !isPickDestination;
    });
  }

  void setTripStarted() {
    setState(() {
      isStarted = !isStarted;
    });
  }

  Future<void> setDestinationMarker() async {
    if (isValidDestination) {
      setState(() {
        isPickDestination = !isPickDestination;
        markers.add(Marker(
          markerId: const MarkerId("currentLocation"),
          position:
              LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
        ));
        markers.add(Marker(
          markerId: const MarkerId("destination"),
          position: destination,
        ));
      });
      getPolyline();
    } else {
      CustomSnackBar.showSnackBar(
          null, "Please choose a valid location", 'warning');
    }
  }

  void getPolyline() async {
    context.read<MapCubit>().getPolyline(
        LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
        destination);
  }

  void finishTrip() {
    setTripStarted();
    setState(() {
      polylineCoordinates = [];
      draggedAddress = "";
      markers = {};
      placeMarks = null;
      isValidDestination = false;
      address = null;
    });
    context.read<MapCubit>().init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MapCubit, MapState>(
      listener: (context, state) {
        state.maybeWhen(
            loaded: (LocationData currLocation, Location location,
                List<ProductModel> productList) {
              currentLocation = currLocation;
              this.productList = productList;
              getCurrentLocation(currLocation, location);
            },
            polylineLoaded: (List<LatLng> polyline) {
              polylineCoordinates = polyline;
              setTripStarted();
            },
            polylineLoadingFailed: (message) {
              CustomSnackBar.showSnackBar(null, message, 'error');
            },
            orElse: () {});
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(6, 8, 6, 0),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            margin: const EdgeInsets.only(top: 6, bottom: 6, left: 4, right: 4),
            child: state.maybeWhen(
                initial: () => const Center(child: CircularProgressIndicator()),
                loading: () => const Center(child: CircularProgressIndicator()),
                loaded: (LocationData currLocation, Location location,
                        List<ProductModel> productList) =>
                    _mapContainer(context),
                loadingFailed: (String message) {
                  return EmptyWidget(
                    title: message,
                    icon: Icons.gps_off_rounded,
                  );
                },
                polylineLoading: () =>
                    const Center(child: CircularProgressIndicator()),
                polylineLoaded: (List<LatLng> polyline) =>
                    _mapContainer(context),
                polylineLoadingFailed: (message) => _mapContainer(context),
                orElse: () => const Center(child: CircularProgressIndicator())),
          ),
        );
      },
    );
  }

  Widget _mapContainer(BuildContext context) {
    return Column(
      children: [
        Expanded(
            flex: 1,
            child: Stack(
              children: [
                _getMap(context),
                Visibility(
                  visible: isPickDestination,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      width: 35,
                      height: 35,
                      margin: EdgeInsets.zero,
                      padding: EdgeInsets.zero,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                      ),
                      child: Center(
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            color: Theme.of(context).colorScheme.outline,
                            Icons.close_rounded,
                            size: 24,
                          ),
                          constraints: const BoxConstraints(),
                          onPressed: setPickDestination,
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Visibility(
                            visible: !isPickDestination && !isStarted,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 12, bottom: 6),
                              child: Container(
                                width: 35,
                                height: 35,
                                margin: EdgeInsets.zero,
                                padding: EdgeInsets.zero,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4.0,
                                      spreadRadius: 2.0,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: IconButton(
                                    icon: Icon(
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                      size: 24,
                                      Icons.pin_drop_rounded,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: setPickDestination,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: isStarted,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 12, bottom: 6),
                              child: Container(
                                width: 35,
                                height: 35,
                                margin: EdgeInsets.zero,
                                padding: EdgeInsets.zero,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4.0,
                                      spreadRadius: 2.0,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: IconButton(
                                    icon: Icon(
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                      Icons.stop_circle_rounded,
                                      size: 24, // Adjust size as needed
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    // Remove default constraints
                                    onPressed: finishTrip,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: isStarted,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Container(
                                width: 35,
                                height: 35,
                                margin: EdgeInsets.zero,
                                padding: EdgeInsets.zero,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4.0,
                                      spreadRadius: 2.0,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: IconButton(
                                    icon: Icon(
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                      Icons.add_card,
                                      size: 24, // Adjust size as needed
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    // Remove default constraints
                                    onPressed: () {
                                      _openTransactionModal(context);
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
                Visibility(visible: isPickDestination, child: _getCustomPin()),
                Visibility(
                  visible: isPickDestination,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _showDraggedAddress(),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ],
    );
  }

  GoogleMap _getMap(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
        zoom: 13.5,
      ),
      markers: markers,
      polylines: {
        Polyline(
          polylineId: const PolylineId("route"),
          points: polylineCoordinates,
          color: const Color(0xFF7B61FF),
          width: 6,
        ),
      },
      onMapCreated: (mapController) {
        _controller.complete(mapController);
      },
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      onCameraIdle: () {
        _getAddress(destination);
      },
      onCameraMove: (cameraPosition) {
        destination = cameraPosition.target;
      },
    );
  }

  Widget _showDraggedAddress() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
            spreadRadius: 4,
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.only(left: 8, top: 10, right: 8, bottom: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20, right: 10, top: 2),
            child: Row(
              children: [
                Icon(
                  Icons.pin_drop_rounded,
                  size: 24,
                ),
                SizedBox(width: 10),
                Text("Address",
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 18,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 10, top: 10),
            child: Row(
              children: [
                Flexible(
                  child: Column(
                    children: <Widget>[
                      Text(draggedAddress,
                          maxLines: 2,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontFamily: "Gilroy",
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              width: 128,
              height: 40,
              child: ElevatedButton(
                style: CommonStyles.secondaryButtonStyles(
                    minimumSizeWidth: 120, minimumSizeHeight: 32),
                onPressed: setDestinationMarker,
                child: Text('Select'.toUpperCase(),
                    style: TextStyle(
                        fontSize: 12.5,
                        letterSpacing: 1,
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _openTransactionModal(BuildContext context) {
    if (null != currentLocation) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return TransactionModal(
            productList: productList,
            currentLocation: currentLocation!,
          );
        },
      );
    } else {
      CustomSnackBar.showSnackBar(
          null, "Current location unavailable", 'warning');
    }
  }

  Widget _getCustomPin() {
    return Center(
      child: SizedBox(
        width: 150,
        child: lottie.Lottie.asset("asset/json/map_pin.json",
            width: 100, height: 100),
      ),
    );
  }

  @override
  void dispose() {
    if (null != locationSubscription) {
      locationSubscription!.cancel();
    }
    super.dispose();
  }
}
