import 'package:evently_c13/core/app_colors.dart';
import 'package:evently_c13/db/model/event_type_model.dart';
import 'package:evently_c13/ui/widgets/custom_text_form_field.dart';
import 'package:evently_c13/ui/widgets/selection_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddEventScreen extends StatefulWidget {
  static const String routeName = "add_event";
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  var selexctedIndex = 0;
  var eventTypes = [];

  @override
  void initState() {
    super.initState();
    eventTypes = [...EventType.eventTypes..removeAt(0)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Event"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 22,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    "assets/images/book_club.png",
                  )),
              buildEventTypesListView(),
              const CustomTextFormField(
                  labelText: 'Title', hintText: 'Event Title'),
              const CustomTextFormField(
                labelText: 'description',
                hintText: 'Event description',
                maxLines: 5,
              ),
              buildChooseDate(),
              buildChooseTime(),
              const Text(
                "Location",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                    fontSize: 18),
              ),
              const SelectionWidget(
                prefixIcon: Icons.location_on_outlined,
                title: Text("Choose Location"),
                isSuffixIcon: true,
              ),
              ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: AppColors.purple,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 10)),
                  child: const Text(
                    "Add Event",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  // Container buildChooseLocation() {
  //   return ;
  // }

  InkWell buildChooseTime() {
    return const InkWell(
      child: Row(
        children: [
          Icon(
            Icons.access_time_outlined,
            size: 30,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            "Event Time",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.black,
                fontSize: 18),
          ),
          Spacer(),
          Text(
            "Choose Time",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
          )
        ],
      ),
    );
  }

  InkWell buildChooseDate() {
    return const InkWell(
      child: Row(
        children: [
          Icon(
            Icons.calendar_month_outlined,
            size: 30,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            "Event Date",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.black,
                fontSize: 18),
          ),
          Spacer(),
          Text(
            "Choose Date",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
          )
        ],
      ),
    );
  }

  SizedBox buildEventTypesListView() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
          itemCount: eventTypes.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  selexctedIndex = index;
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                margin: const EdgeInsets.only(right: 10),
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.purple),
                  borderRadius: BorderRadius.circular(20),
                  color: selexctedIndex == index
                      ? AppColors.purple
                      : AppColors.white,
                ),
                child: Row(
                  spacing: 8,
                  children: [
                    FaIcon(
                      eventTypes[index].icon.icon,
                      color: selexctedIndex == index
                          ? AppColors.white
                          : AppColors.purple,
                    ),
                    Text(eventTypes[index].name,
                        style: TextStyle(
                            color: selexctedIndex == index
                                ? AppColors.white
                                : AppColors.purple,
                            fontWeight: FontWeight.w500,
                            fontSize: 18)),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
