import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently_c13/db/model/AppUser.dart';
import 'package:evently_c13/db/model/DataBaseResponse.dart';
import 'package:evently_c13/db/model/event_model.dart';

class EventsDao {
  static const String eventsCollection = "events";

  static var db = FirebaseFirestore.instance;

  static CollectionReference<EventModel> getEventsCollection(String userId) {
    return db
        .collection(AppUser.collectionName)
        .doc(userId)
        .collection(eventsCollection)
        .withConverter<EventModel>(
          fromFirestore: (snapshot, options) =>
              EventModel.fromFireStore(snapshot.data()),
          toFirestore: (object, options) => object.toFireStore(),
        );
  }

  static Future<DataBaseResponse<EventModel>> addEvent(
    String userId,
    String title,
    String description,
    DateTime date,
    int time,
    int eventType,
    double? lat,
    double? lng,
  ) async {
    var docRef = getEventsCollection(userId).doc();
    var event = EventModel(
        id: docRef.id,
        title: title,
        description: description,
        date: Timestamp.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch),
        time: time,
        lat: null,
        long: null,
        eventTypeId: eventType);
    try {
      await docRef.set(event);
      print('adding end');
      return DataBaseResponse(isSuccess: true, data: event);
    } on Exception catch (ex) {
      print('exce $ex');
      return DataBaseResponse(isSuccess: false, exception: ex);
    }
  }

  static Future<DataBaseResponse<List<EventModel>>> loadEvents(
      String userId, int categoryId) async {
    try {
      var collectionReference = getEventsCollection(userId);

      Query<EventModel> query;
      if (categoryId != 0) {
        query = collectionReference
            .where("eventTypeId", isEqualTo: categoryId)
            .orderBy('date', descending: true);
      } else {
        query = collectionReference.orderBy('date', descending: true);
      }
      print('category id $categoryId');
      var data = await query.get();

      var events = data.docs
          .map(
            (docSnapshot) => docSnapshot.data(),
          )
          .toList();
      return DataBaseResponse(isSuccess: true, data: events);
    } on Exception catch (ex) {
      return DataBaseResponse(isSuccess: false, exception: ex);
    }
  }

  static Future<void> updateEvent(String userId, EventModel event) async {
    var docRef = getEventsCollection(userId).doc(event.id);
    await docRef.set(event);
  }

  static Future<DataBaseResponse<List<EventModel>>> loadFavoriteEvents(
      String userId) async {
    try {
      var collectionReference = getEventsCollection(userId);

      var eventsSnapshots =
          await collectionReference.where("isFavorite", isEqualTo: true).get();

      var events = eventsSnapshots.docs
          .map(
            (docSnapshot) => docSnapshot.data(),
          )
          .toList();
      return DataBaseResponse(isSuccess: true, data: events);
    } on Exception catch (ex) {
      return DataBaseResponse(isSuccess: false, exception: ex);
    }
  }
}
