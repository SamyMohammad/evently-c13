import 'package:evently_c13/core/app_colors.dart';
import 'package:evently_c13/db/dao/events_dao.dart';
import 'package:evently_c13/db/model/event_type_model.dart';
import 'package:evently_c13/l10n/DateTimeUtils.dart';
import 'package:evently_c13/providers/AuthProvider.dart';
import 'package:evently_c13/ui/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:evently_c13/core/dialog_utils.dart';
import 'package:provider/provider.dart';

class AddEventScreen extends StatefulWidget {
  static const String routeName = "add_event";
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  var selexctedIndex = 0;
  List<EventType> eventTypes = [];
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    var types = EventType.getEventTypes();
    types.removeAt(0);
    eventTypes = types;
  }

  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Event"),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 22,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      eventTypes[selexctedIndex].imagePath,
                    )),
                buildEventTypesListView(),
                CustomTextFormField(
                  controller: titleController,
                  labelText: 'Title',
                  hintText: 'Event Title',
                  validator: (newText) {
                    if (newText?.trim().isEmpty == true) {
                      return "please Enter event title";
                    }
                  },
                ),
                CustomTextFormField(
                  controller: descriptionController,
                  labelText: 'description',
                  hintText: 'Event description',
                  maxLines: 5,
                  validator: (newText) {
                    if (newText?.trim().isEmpty == true) {
                      return "please Enter event Description";
                    }
                  },
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
                buildChooseLocation(),
                ElevatedButton(
                    onPressed: () {
                      addEvent();
                    },
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
      ),
    );
  }

  Container buildChooseLocation() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.purple),
      ),
      child: Row(spacing: 8, children: [
        Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.purple,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.location_on,
              color: AppColors.white,
            )),
        const Text("Choose Event Location"),
        const Spacer(),
        const Icon(
          Icons.arrow_forward_ios,
          color: AppColors.purple,
        )
      ]),
    );
  }

  InkWell buildChooseTime() {
    return InkWell(
      onTap: () {
        showTimePickerDialog();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                selectedTime == null
                    ? "Choose Time"
                    : formatTime(selectedTime!),
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              )
            ],
          ),
          if (hasValidTime == false)
            Text("Please choose time",
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: Theme.of(context).colorScheme.error))
        ],
      ),
    );
  }

  InkWell buildChooseDate() {
    return InkWell(
      onTap: () {
        showDatPickerDialog();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                selectedDate == null
                    ? "Choose Date"
                    : formatDate(selectedDate!),
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              )
            ],
          ),
          if (hasValidDate == false)
            Text(
              "Please choose Date",
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: Theme.of(context).colorScheme.error),
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

  bool hasValidDate = true;
  bool hasValidTime = true;

  void addEvent() async {
    setState(() {
      hasValidTime = selectedTime != null;
      hasValidDate = selectedDate != null;
    });
    if (formKey.currentState?.validate() == false ||
        !hasValidTime && !hasValidDate) {
      return;
    }

    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    showLoadingDialog("Loading...");
    print(authProvider.appUser?.id);
    var response = await EventsDao.addEvent(
        authProvider.appUser?.id ?? "",
        titleController.text,
        descriptionController.text,
        selectedDate!,
        selectedTime!.millisecondsSinceEpoch,
        eventTypes[selexctedIndex].id,
        null,
        null);
    print('adding in add event');

    hideDialog();
    print('$response');

    if (response.isSuccess) {
      showMessageDialog(
        "Event Successfully Added",
        posActionTitle: "ok",
        posAction: () => {Navigator.pop(context)},
      );
    } else {
      showMessageDialog(response.getErrorMessage(), posActionTitle: "ok");
    }
  }

  DateTime? selectedDate;
  DateTime? selectedTime;

  void showDatPickerDialog() async {
    var choosenDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    setState(() {
      selectedDate = choosenDate;
      hasValidDate = choosenDate != null;
    });
  }

  void showTimePickerDialog() async {
    var now =
        TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
    var chosenTime = await showTimePicker(
        context: context,
        initialTime: selectedTime == null
            ? now
            : TimeOfDay(
                hour: selectedTime!.hour, minute: selectedTime!.minute));
    setState(() {
      if (chosenTime == null) {
        selectedTime = null;
        hasValidTime = false;
        return;
      }
      selectedTime =
          DateTime(0, 0, 0, chosenTime.hour, chosenTime.minute, 0, 0);
      hasValidTime = true;
    });
  }
}

extension on DateTime {
  DateTime timeOnly() {
    return DateTime(0, 0, 0, hour, minute, second, millisecond);
  }
}
