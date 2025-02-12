import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  String? id;
  String? title;
  String? description;
  GeoPoint? geoPoint;
  Timestamp? date;
  int? time;
  int? eventTypeId;
  bool isFavorite = false;
  EventModel({
    this.id,
    this.title,
    this.description,
    this.geoPoint,
    this.date,
    this.time,
    this.eventTypeId,
    this.isFavorite = false,
  });

  EventModel.fromFireStore(Map<String, dynamic>? data)
      : this(
            id: data?["id"],
            title: data?["title"],
            description: data?["description"],
            eventTypeId: data?["eventTypeId"],
            geoPoint: data?["geoPoint"],
            date: data?["date"],
            time: data?["time"],
            isFavorite: data?["isFavorite"] ?? false);

  Map<String, dynamic> toFireStore() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "geoPoint": geoPoint,
      "date": date,
      "time": time,
      "eventTypeId": eventTypeId,
      "isFavorite": isFavorite,
    };
  }
}
