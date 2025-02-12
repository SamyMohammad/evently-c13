import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently_c13/core/app_colors.dart';
import 'package:evently_c13/core/dialog_utils.dart';
import 'package:evently_c13/db/dao/events_dao.dart';
import 'package:evently_c13/db/model/event_model.dart';
import 'package:evently_c13/db/model/event_type_model.dart';
import 'package:evently_c13/l10n/DateTimeUtils.dart';
import 'package:evently_c13/providers/AuthProvider.dart';
import 'package:evently_c13/ui/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class UpsertEventScreen extends StatefulWidget {
  static const String routeName = "add_event";
  const UpsertEventScreen({super.key});

  @override
  State<UpsertEventScreen> createState() => _UpsertEventScreenState();
}

class _UpsertEventScreenState extends State<UpsertEventScreen>
    with AutomaticKeepAliveClientMixin {
  var selexctedIndex = 0;
  List<EventType> eventTypes = [];
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  EventModel? eventModel;

  @override
  void initState() {
    super.initState();
    var types = EventType.getEventTypes();
    types.removeAt(0);
    eventTypes = types;
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      eventModel = ModalRoute.of(context)!.settings.arguments as EventModel?;
      if (eventModel != null) {
        titleController = TextEditingController(text: eventModel?.title ?? '');
        descriptionController =
            TextEditingController(text: eventModel?.description ?? '');
        selectedDate = DateTime.fromMillisecondsSinceEpoch(
            eventModel!.date?.millisecondsSinceEpoch ?? 0);
        selectedTime = DateTime(
            0,
            0,
            0,
            DateTime.fromMillisecondsSinceEpoch(eventModel!.time!).hour,
            DateTime.fromMillisecondsSinceEpoch(eventModel!.time!).minute);

        selexctedIndex = eventTypes.indexWhere((type) {
          return type.id == eventModel?.eventTypeId;
        });
      }
      setState(() {});
    });
  }

  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(eventModel == null ? "Create Event" : "Update Event"),
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
                    return null;
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
                    return null;
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
                    onPressed: () =>
                        eventModel == null ? addEvent() : updateEvent(),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: AppColors.purple,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 10)),
                    child: Text(
                      eventModel == null ? "Add Event" : "Update Event",
                      style: const TextStyle(fontSize: 20, color: Colors.white),
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
              const Icon(
                Icons.access_time_outlined,
                size: 30,
              ),
              const SizedBox(
                width: 10,
              ),
              const Text(
                "Event Time",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                    fontSize: 18),
              ),
              const Spacer(),
              Text(
                selectedTime == null
                    ? "Choose Time"
                    : formatTime(selectedTime!),
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
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
              const Icon(
                Icons.calendar_month_outlined,
                size: 30,
              ),
              const SizedBox(
                width: 10,
              ),
              const Text(
                "Event Date",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                    fontSize: 18),
              ),
              const Spacer(),
              Text(
                selectedDate == null
                    ? "Choose Date"
                    : formatDate(selectedDate!),
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
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
        const GeoPoint(31.244288, 29.9859968));

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

  Future<void> updateEvent() async {
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
    var response = await EventsDao.updateEvent(
      event: EventModel(
        date: Timestamp.fromDate(selectedDate!),
        description: descriptionController.text,
        title: titleController.text,
        time: selectedTime?.millisecondsSinceEpoch,
        eventTypeId: eventTypes[selexctedIndex].id,
        id: eventModel?.id,
      ),
      userId: authProvider.appUser?.id ?? "",
    );
    print('updating in add event');

    hideDialog();
    print('$response');

    if (response.isSuccess) {
      showMessageDialog(
        "Event Successfully Updated",
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
      lastDate: DateTime.now().add(const Duration(days: 365)),
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

extension on DateTime {
  DateTime timeOnly() {
    return DateTime(0, 0, 0, hour, minute, second, millisecond);
  }
}
