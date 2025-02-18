import 'dart:async';

import 'package:evently_c13/core/location_manager.dart';
import 'package:evently_c13/db/dao/events_dao.dart';
import 'package:evently_c13/db/model/event_model.dart';
import 'package:evently_c13/providers/AuthProvider.dart';
import 'package:evently_c13/ui/screens/event_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class MapTab extends StatefulWidget {
  const MapTab({super.key});

  @override
  State<MapTab> createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> {
  LocationManager locationManager = LocationManager();
  StreamSubscription<LocationData>? subscription;
  GoogleMapController? _controller;
  static const String userLocationId = 'user';
  CameraPosition? userLocation = const CameraPosition(
    target: LatLng(0, 0),
  );
  Set<Marker> markers = {};
  List<EventModel> nearbyEvents = [];

  @override
  void initState() {
    super.initState();
    initializeLocation();
    // subscription = locationManager.trackLocation().listen((locationData) {
    //   setState(() {
    //     userLocation = CameraPosition(
    //       target: LatLng(locationData.latitude!, locationData.longitude!),
    //       zoom: 14,
    //     );
    //     _updateEventMarkers();
    //   });
    // });
    loadNearbyEvents();
  }

  Future<void> initializeLocation() async {
    bool canGetLocation = await locationManager.canGetLocation();
    if (!canGetLocation) {
      return;
    }
    LocationData location = await locationManager.getUserLocation();
    setState(() {
      userLocation = CameraPosition(
        target: LatLng(location.latitude!, location.longitude!),
        zoom: 14,
      );
      // _updateEventMarkers();
      _controller?.animateCamera(CameraUpdate.newCameraPosition(userLocation!));
    });
  }

  Future<void> loadNearbyEvents() async {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    var response =
        await EventsDao.loadEvents(authProvider.appUser?.id ?? "", 0);
    if (response.isSuccess && response.data != null) {
      setState(() {
        nearbyEvents = response.data!;
        _updateEventMarkers();
      });
    }
  }

  void _updateEventMarkers() {
    // markers.clear();
    // // Add user location marker
    // markers.add(Marker(
    //   markerId: const MarkerId(userLocationId),
    //   position: userLocation!.target,
    //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    // ));

    // Add event markers
    for (var event in nearbyEvents) {
      if (event.geoPoint != null) {
        markers.add(
          Marker(
            markerId: MarkerId(event.id ?? ''),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
            position:
                LatLng(event.geoPoint!.latitude, event.geoPoint!.longitude),
            infoWindow: InfoWindow(
              title: event.title,
              snippet: event.description,
            ),
            onTap: () {
              // Show event details or navigate to details screen
              Navigator.pushNamed(context, EventDetailsScreen.routeName,
                  arguments: event);
            },
          ),
        );
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: userLocation!,
          markers: markers,
          onMapCreated: (GoogleMapController controller) {
            _controller = controller;
          },
        ),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: nearbyEvents.length,
              itemBuilder: (context, index) {
                final event = nearbyEvents[index];
                return GestureDetector(
                  onTap: () {
                    if (event.geoPoint != null) {
                      _controller?.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: LatLng(event.geoPoint!.latitude,
                                event.geoPoint!.longitude),
                            zoom: 14,
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: 250,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.title ?? "Untitled Event",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  size: 16, color: Colors.blue),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  event.description ?? "No description",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  changeCameraPosition() {
    _controller?.animateCamera(CameraUpdate.newCameraPosition(userLocation!));
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }
}
