import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently_c13/core/app_colors.dart';
import 'package:evently_c13/db/model/event_model.dart';
import 'package:evently_c13/db/model/event_type_model.dart';
import 'package:evently_c13/l10n/DateTimeUtils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

typedef OnFavoriteCallBack = void Function(EventModel event);

class EventItem extends StatelessWidget {
  EventModel event;
  OnFavoriteCallBack onFavoriteCallBack;

  EventItem(this.event, this.onFavoriteCallBack, {super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.25,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          image: DecorationImage(
            image: AssetImage(
              EventType.getEventImageById(event.eventTypeId ?? 0),
            ),
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildDateContainer(event.date),
          const Spacer(),
          buildTitleContainer(context)
        ],
      ),
    );
  }

  Container buildTitleContainer(BuildContext context) {
    return Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Row(
            children: [
              Text(
            event.title ?? "",
            style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Spacer(),
          InkWell(
            onTap: () {
              onFavoriteCallBack.call(event);
            },
            child: FaIcon(
              event.isFavorite
                  ? FontAwesomeIcons.solidHeart
                  : FontAwesomeIcons.heart,
              color: AppColors.purple,
            ),
          ),
            ],
          ),
        );
  }

  Container buildDateContainer(Timestamp? timeStamp) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: [
          Text(
            "${timeStamp?.toDate().day}",
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: AppColors.purple),
          ),
          Text(
            "${getMonthNameFromDate(timeStamp!.toDate())}",
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: AppColors.purple),
          ),
        ],
      ),
    );
  }
}
