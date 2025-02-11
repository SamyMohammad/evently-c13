import 'package:evently_c13/db/model/event_model.dart';
import 'package:evently_c13/ui/widgets/selection_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
          IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
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
            const Text(
              "We Are Going To Play Football",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
                    DateFormat.jm()
                        .format(event.date?.toDate() ?? DateTime.now()),
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  )
                ],
              ),
              prefixIcon: Icons.calendar_month,
            ),
            const SelectionWidget(
                title: Text("Cairo , Egypt", style: TextStyle(fontSize: 16)),
                isSuffixIcon: true,
                prefixIcon: Icons.location_on_outlined),
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
