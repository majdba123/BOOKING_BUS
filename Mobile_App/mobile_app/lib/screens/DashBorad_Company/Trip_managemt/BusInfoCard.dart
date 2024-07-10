import 'package:flutter/material.dart';

import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
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
            SizedBox(height: 16,),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      DatePicker.showDateTimePicker(
                        context,
                        showTitleActions: true,
                        onChanged: (date) {},
                        onConfirm: (date) {
                          onChanged(info.copyWith(startTime: date.toString()));
                        },
                        currentTime: DateTime.now(),
                        locale: LocaleType.en,
                      );
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: TextEditingController(text: info.startTime),
                        decoration: InputDecoration(
                          labelText: 'Start Time',
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      DatePicker.showDateTimePicker(
                        context,
                        showTitleActions: true,
                        onChanged: (date) {},
                        onConfirm: (date) {
                          onChanged(info.copyWith(endTime: date.toString()));
                        },
                        currentTime: DateTime.now(),
                        locale: LocaleType.en,
                      );
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: TextEditingController(text: info.endTime),
                        decoration: InputDecoration(
                          labelText: 'End Time',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
}
