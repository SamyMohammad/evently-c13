import 'package:evently_c13/db/dao/events_dao.dart';
import 'package:evently_c13/db/model/event_model.dart';
import 'package:evently_c13/db/model/event_type_model.dart';
import 'package:evently_c13/providers/AuthProvider.dart';
import 'package:evently_c13/ui/widgets/events_list_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeTab extends StatefulWidget {
  EventType eventType;

  HomeTab(this.eventType, {super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  List<EventModel>? events = [];

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    if (authProvider.appUser == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return FutureBuilder(
        future: EventsDao.loadEvents(
            authProvider.appUser?.id ?? "", widget.eventType.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // waiting for future to complete
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          var events = snapshot.data?.data;
          if (events == null || events.isEmpty) {
            return Center(
              child: Text("No Events Found"),
            );
          }
          return EventsListView(
            events: events,
            onFavoriteCallBack: onFavoriteCallBack,
          );
        },
      );
    }
  }

  void onFavoriteCallBack(EventModel event) async {
    event.isFavorite = !event.isFavorite;
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    await EventsDao.updateEvent(authProvider.appUser?.id ?? "", event);
    setState(() {});
  }
}
