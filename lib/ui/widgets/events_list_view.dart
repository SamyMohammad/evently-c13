import 'package:evently_c13/db/model/event_model.dart';
import 'package:evently_c13/ui/widgets/event_item.dart';
import 'package:flutter/material.dart';

class EventsListView extends StatelessWidget {
  final List<EventModel> events;
  OnFavoriteCallBack onFavoriteCallBack;

  EventsListView(
      {super.key, required this.events, required this.onFavoriteCallBack});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        return EventItem(events[index], onFavoriteCallBack);
      },
    );
  }
}
