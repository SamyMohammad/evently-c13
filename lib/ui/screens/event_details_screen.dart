import 'package:evently_c13/db/model/event_model.dart';
import 'package:evently_c13/ui/screens/upsert_event_screen.dart';
import 'package:evently_c13/ui/widgets/selection_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class EventDetailsScreen extends StatelessWidget {
  static const String routeName = 'eventDetailsScreen';
  const EventDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final event = ModalRoute.of(context)!.settings.arguments as EventModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Event Details"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, UpsertEventScreen.routeName,
                    arguments: event);
              },
              icon: const Icon(Icons.edit)),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  "assets/images/book_club.png",
                )),
            Text(
              event.title ?? '',
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SelectionWidget(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat.yMMMMEEEEd()
                        .format(event.date?.toDate() ?? DateTime.now()),
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    DateFormat.jm().format(
                        DateTime.fromMillisecondsSinceEpoch(event.time ?? 0)),
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  )
                ],
              ),
              prefixIcon: Icons.calendar_month,
            ),
            if (event.geoPoint != null)
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        event.geoPoint!.latitude,
                        event.geoPoint!.longitude,
                      ),
                      zoom: 15,
                    ),
                    markers: {
                      Marker(
                        markerId: MarkerId(const Uuid().v4()),
                        position: LatLng(
                          event.geoPoint!.latitude,
                          event.geoPoint!.longitude,
                        ),
                      ),
                    },
                  ),
                ),
              ),
            const Text(
              "Description",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            Text(
              event.description ?? '',
              style: const TextStyle(fontSize: 16, color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
