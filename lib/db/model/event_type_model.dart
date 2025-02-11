import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EventType {
  final int id;
  final String name;
  final FaIcon icon;
  final String imagePath;
  EventType(
      {required this.id,
      required this.name,
      required this.icon,
      required this.imagePath});

  static List<EventType> getEventTypes() {
    return [
      EventType(
          id: 0,
          name: "All",
          imagePath: "",
          icon: const FaIcon(
            FontAwesomeIcons.compass,
          )),
      EventType(
          id: 1,
          name: "Sport",
          imagePath: "assets/images/sport.png",
          icon: const FaIcon(
            FontAwesomeIcons.bicycle,
          )),
      EventType(
          id: 2,
          name: "Birthday",
          imagePath: "assets/images/birthday.png",
          icon: const FaIcon(
            FontAwesomeIcons.cakeCandles,
          )),
      EventType(
          id: 3,
          name: "Meeting",
          imagePath: "assets/images/meeting.png",
          icon: const FaIcon(
            FontAwesomeIcons.handshake,
          )),
      EventType(
          id: 4,
          name: "Book Club",
          imagePath: "assets/images/book_club.png",
          icon: const FaIcon(
            FontAwesomeIcons.bookOpen,
          )),
      EventType(
          id: 5,
          name: "Eating",
          imagePath: "assets/images/eating.png",
          icon: const FaIcon(
            FontAwesomeIcons.utensils,
          )),
      EventType(
          id: 6,
          name: "Gaming",
          imagePath: "assets/images/gaming.png",
          icon: const FaIcon(
            FontAwesomeIcons.gamepad,
          )),
      EventType(
          id: 7,
          name: "Workshop",
          imagePath: "assets/images/workshop.png",
          icon: const FaIcon(
            FontAwesomeIcons.squareWebAwesomeStroke,
          )),
    ];
  }

  static String getEventImageById(int id) {
    if (id == 0) return "assets/images/sport.png";
    var types = getEventTypes();
    for (EventType eventType in types) {
      if (eventType.id == id) {
        return eventType.imagePath;
      }
    }
    return "assets/images/sport.png";
  }
}
