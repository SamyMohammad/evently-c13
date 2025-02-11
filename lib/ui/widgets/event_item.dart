import 'package:evently_c13/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EventItem extends StatelessWidget {

  const EventItem({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.25,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          image: DecorationImage(
            image: AssetImage(
              "assets/images/book_club.png",
            ),
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildDateContainer(),
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
                "Book Club",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Spacer(),
              const FaIcon(
                FontAwesomeIcons.solidHeart,
                color: AppColors.purple,
              ),
            ],
          ),
        );
  }

  Container buildDateContainer() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: const Column(
        children: [
          Text(
            "21",
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: AppColors.purple),
          ),
          Text(
            "Nov",
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
