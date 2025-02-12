import 'package:evently_c13/db/model/event_model.dart';
import 'package:evently_c13/ui/screens/event_details_screen.dart';
import 'package:evently_c13/ui/widgets/event_item.dart';
import 'package:flutter/material.dart';

class EventsListView extends StatelessWidget {
  final List<EventModel> events;
  final OnFavoriteCallBack onFavoriteCallBack;

  const EventsListView(
      {super.key, required this.events, required this.onFavoriteCallBack});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        return InkWell(
            onTap: () {
              Navigator.pushNamed(context, EventDetailsScreen.routeName,
                  arguments: events[index]);
            },
            child: EventItem(
              event: events[index],
              onFavoriteCallBack: (event) {},
            ));
      },
    );
  }
}
