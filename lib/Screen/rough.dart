import 'package:flutter/material.dart';

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TimeOfDay _startTime = TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = TimeOfDay(hour: 17, minute: 0);

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? newStartTime =
        await showTimePicker(context: context, initialTime: _startTime);
    if (newStartTime != null) {
      setState(() {
        _startTime = newStartTime;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? newEndTime =
        await showTimePicker(context: context, initialTime: _endTime);
    if (newEndTime != null) {
      setState(() {
        _endTime = newEndTime;
      });
    }
  }

  List<dynamic> data = [
    {"Name": "Sunday", "Age": 32, "Role": "Administrator", "checked": false},
    {"Name": "Monday", "Age": 28, "Role": "Seni", "checked": false},
    {"Name": "Tuesday", "Age": 32, "Role": "Administrator", "checked": false},
    {"Name": "Wednesday", "Age": 28, "Role": "Manager", "checked": false},
    {"Name": "Thursday", "Age": 32, "Role": "Administrator", "checked": false},
    {"Name": "Friday", "Age": 32, "Role": "Administrator", "checked": false},
    {"Name": "Saturday", "Age": 32, "Role": "Administrator", "checked": false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: DataTable(
            columns: const <DataColumn>[
              DataColumn(
                label: Text('Day'),
              ),
              DataColumn(
                label: Text('time'),
                numeric: true,
              ),
              DataColumn(
                label: Text('End time'),
              ),
            ],
            rows: List.generate(data.length, (index) {
              final item = data[index];
              return DataRow(
                  cells: [
                    DataCell(Text(item['Name'])),
                    DataCell(Text(item['Age'].toString())),
                    DataCell(
                      TextButton(
                        onPressed: () => _selectStartTime(context),
                        child: Text('${_startTime.format(context)}'),
                      ),
                    ),
                    DataCell(Text(item['Role'])),
                  ],
                  selected: item['checked'],
                  onSelectChanged: (bool? value) {
                    setState(() {
                      data[index]['checked'] = value!;
                    });
                    debugPrint(data.toString());
                  });
            }),
          ),
        ),
      ),
    );
  }
}
