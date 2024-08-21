import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/Data_Models/Bus.dart';
import 'package:mobile_app/Data_Models/BusInfoTrip.dart';

class BusCard extends StatelessWidget {
  final BusInfo info;
  final List<Bus> buses;
  final ValueChanged<BusInfo> onChanged;
  final VoidCallback onDelete;

  BusCard({
    required this.info,
    required this.buses,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bus Info', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: 'Select Bus',
                border: OutlineInputBorder(),
              ),
              value: info.busId,
              items: buses.map((bus) {
                return DropdownMenuItem<int>(
                  value: bus.id,
                  child: Text(bus.id.toString()),
                );
              }).toList(),
              onChanged: (value) {
                onChanged(info.copyWith(busId: value));
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a bus';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text('Type: ', style: TextStyle(fontSize: 14)),
                Expanded(
                  child: Row(
                    children: [
                      Radio(
                        value: 'all',
                        groupValue: info.type,
                        onChanged: (value) {
                          onChanged(info.copyWith(type: value));
                        },
                      ),
                      Text('All'),
                      Radio(
                        value: 'going',
                        groupValue: info.type,
                        onChanged: (value) {
                          onChanged(info.copyWith(type: value));
                        },
                      ),
                      Text('Going'),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                _pickDate(context);
              },
              child: AbsorbPointer(
                child: TextFormField(
                  controller: TextEditingController(text: _formatDate(info.date)),
                  decoration: InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                _pickStartTime(context);
              },
              child: AbsorbPointer(
                child: TextFormField(
                  controller: TextEditingController(text: _formatTime(info.startTime)),
                  decoration: InputDecoration(
                    labelText: 'Start Time',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                _pickEndTime(context);
              },
              child: AbsorbPointer(
                child: TextFormField(
                  controller: TextEditingController(text: _formatTime(info.endTime)),
                  decoration: InputDecoration(
                    labelText: 'End Time',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: onDelete,
                  child: Text('Delete Bus'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _pickDate(BuildContext context) {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      onConfirm: (date) {
        onChanged(info.copyWith(date: DateFormat('yyyy-MM-dd').format(date)));
      },
      currentTime: DateTime.now(),
      locale: LocaleType.en,
    );
  }

  void _pickStartTime(BuildContext context) {
    DatePicker.showTimePicker(
      context,
      showTitleActions: true,
      onConfirm: (time) {
        onChanged(info.copyWith(startTime: DateFormat('HH:mm').format(time)));
      },
      currentTime: _parseTime(info.startTime),
      locale: LocaleType.en,
    );
  }

  void _pickEndTime(BuildContext context) {
    DatePicker.showTimePicker(
      context,
      showTitleActions: true,
      onConfirm: (time) {
        onChanged(info.copyWith(endTime: DateFormat('HH:mm').format(time)));
      },
      currentTime: _parseTime(info.endTime),
      locale: LocaleType.en,
    );
  }

  String _formatDate(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) {
      return '';
    }
    return dateTime;
  }

  String _formatTime(String? time) {
    if (time == null || time.isEmpty) {
      return '';
    }
    return time;
  }

  DateTime _parseTime(String? time) {
    if (time == null || time.isEmpty) {
      return DateTime.now();
    }
    return DateFormat('HH:mm').parse(time);
  }
}
