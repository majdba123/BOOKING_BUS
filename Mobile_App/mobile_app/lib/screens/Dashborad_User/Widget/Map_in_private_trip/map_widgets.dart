// map_widgets.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidgets {
  static Widget buildZoomButtons(
      BuildContext context, GoogleMapController mapController) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ClipOval(
              child: Material(
                color: Colors.blue.shade100, // button color
                child: InkWell(
                  splashColor: Colors.blue, // inkwell color
                  child:
                      SizedBox(width: 50, height: 50, child: Icon(Icons.add)),
                  onTap: () {
                    mapController.animateCamera(CameraUpdate.zoomIn());
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            ClipOval(
              child: Material(
                color: Colors.blue.shade100, // button color
                child: InkWell(
                  splashColor: Colors.blue, // inkwell color
                  child: SizedBox(
                      width: 50, height: 50, child: Icon(Icons.remove)),
                  onTap: () {
                    mapController.animateCamera(CameraUpdate.zoomOut());
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  static Widget buildTextField({
    required String label,
    required String hint,
    required Icon prefixIcon,
    required TextEditingController controller,
    required Function(String) locationCallback,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        onChanged: (value) {
          locationCallback(value);
        },
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.grey.shade400, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.blue.shade300, width: 2),
          ),
          hintText: hint,
        ),
      ),
    );
  }

  static Widget buildCurrentLocationButton(
      BuildContext context, Future<void> Function() getCurrentLocation) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 10.0, bottom: 20.0),
          child: ClipOval(
            child: Material(
              color: Colors.orange.shade100, // button color
              child: InkWell(
                splashColor: Colors.orange, // inkwell color
                child: SizedBox(
                    width: 56, height: 56, child: Icon(Icons.my_location)),
                onTap: () {
                  getCurrentLocation();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
