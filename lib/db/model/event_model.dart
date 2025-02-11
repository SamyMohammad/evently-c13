import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  String? id;
  String? title;
  String? description;
  String? lat;
  String? long;
  Timestamp? date;
  int? time;
  int? eventTypeId;
  bool isFavorite = false;
  EventModel({
    this.id,
    this.title,
    this.description,
    this.lat,
    this.long,
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
            lat: data?["lat"],
            long: data?["long"],
            date: data?["date"],
            time: data?["time"],
            isFavorite: data?["isFavorite"] ?? false);

  Map<String, dynamic> toFireStore() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "lat": lat,
      "long": long,
      "date": date,
      "time": time,
      "eventTypeId": eventTypeId,
      "isFavorite": isFavorite,
    };
  }
}
