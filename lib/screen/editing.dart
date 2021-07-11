import 'package:calendar_test_app/provider/calender_provider.dart';
import 'package:calendar_test_app/screen/home_page.dart';
import 'package:calendar_test_app/model/dateformat_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventEditingPage extends StatefulWidget {
  final Meeting? event;
  const EventEditingPage({
    Key? key,
    this.event,
  }) : super(key: key);

  @override
  _EventEditingPageState createState() => _EventEditingPageState();
}

class _EventEditingPageState extends State<EventEditingPage> {
  final _formkey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  late DateTime fromDate;
  late DateTime toDate;
  @override
  void initState() {
    super.initState();
    if (widget.event == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(Duration(hours: 2));
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  Future pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(fromDate, pickDate: pickDate);
    if (date == null) return;
    if (date.isAfter(toDate)) {
      toDate =
          DateTime(date.year, date.month, date.day, toDate.hour, toDate.minute);
    }
    setState(() => fromDate = date);
  }

  Future pickToDateTime({required bool pickDate}) async {
    final date = await pickDateTime(toDate,
        pickDate: pickDate, firstDate: pickDate ? fromDate : null);
    if (date == null) return;

    setState(() => toDate = date);
  }

  Future<DateTime?> pickDateTime(
    DateTime initialDate, {
    required bool pickDate,
    DateTime? firstDate,
  }) async {
    if (pickDate) {
      final date = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate ?? DateTime(2015, 8),
        lastDate: DateTime(2101),
      );
      if (date == null) return initialDate;
      final time =
          Duration(hours: initialDate.hour, minutes: initialDate.minute);
      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );
      if (timeOfDay == null) return initialDate;
      final date =
          DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);
      return date.add(time);
    }
  }

  Widget buildTitle() => TextFormField(
        style: const TextStyle(fontSize: 24),
        decoration: const InputDecoration(
            border: UnderlineInputBorder(), hintText: 'Add Title'),
        // onFieldSubmitted: (_)=>saveForm(),
        validator: (title) =>
            title != null && title.isEmpty ? 'Title cannot by empty' : null,
        controller: titleController,
      );

  Widget buildDateTimePickers() => Column(
        children: [
          buildFrom(),
          buildTo(),
        ],
      );

  Widget buildFrom() => buildHeader(
        header: 'FROM',
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: buildDropdownField(
                text: DateFormateModel.toDate(fromDate),
                onClicked: () => pickFromDateTime(pickDate: true),
              ),
            ),
            Expanded(
                child: buildDropdownField(
              text: DateFormateModel.toTime(fromDate),
              onClicked: () => pickFromDateTime(pickDate: false),
            ))
          ],
        ),
      );
  Widget buildTo() => buildHeader(
        header: 'TO',
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: buildDropdownField(
                text: DateFormateModel.toDate(toDate),
                onClicked: () => pickToDateTime(pickDate: true),
              ),
            ),
            Expanded(
                child: buildDropdownField(
              text: DateFormateModel.toTime(toDate),
              onClicked: () => pickToDateTime(pickDate: false),
            ))
          ],
        ),
      );

  Widget buildDropdownField({
    required String text,
    required VoidCallback onClicked,
  }) =>
      ListTile(
        title: Text(text),
        trailing: Icon(Icons.arrow_drop_down),
        onTap: onClicked,
      );

  Widget buildHeader({
    required String header,
    required Widget child,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          child,
        ],
      );

  List<Widget> buildEditingActions() => [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          onPressed: saveForm,
          icon: const Icon(Icons.done),
          label: const Text('SAVE'),
        ),
      ];

  Future saveForm() async {
    final isValid = _formkey.currentState!.validate();

    if (isValid) {
      final meeting = Meeting(
          eventName: titleController.text,
          from: fromDate,
          to: toDate,
          backgroundColor: Colors.pink);
      final provider = Provider.of<CalendarProvider>(context, listen: false);
      provider.addEvent(meeting);

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const CloseButton(),
          actions: buildEditingActions(),
          backgroundColor: const Color.fromRGBO(0, 7, 36, 0.8),
          elevation: 0,
        ),
        body: SingleChildScrollView(
            child: Container(
          padding: const EdgeInsets.all(5.0),
          margin: const EdgeInsets.all(5.0),
          child: Form(
              key: _formkey,
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                buildTitle(),
                const SizedBox(height: 12),
                buildDateTimePickers(),
              ])),
        )));
  }
}
