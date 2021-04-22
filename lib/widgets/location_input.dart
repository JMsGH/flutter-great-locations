import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../helpers/location_help.dart';
import '../screens/map_screen.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;

  LocationInput(this.onSelectPlace);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl;

  void _showPreview(double lat, double lng) {
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
      latitude: lat,
      longitude: lng,
    );
    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  Future<void> _getCurrentUserLocation() async {
    // final locData = await Location().getLocation();
    try {
      Location location = new Location();

      bool _serviceEnabled;
      PermissionStatus _permissionGranted;
      LocationData _locData;

      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

      _locData = await location.getLocation();
      print(_locData.latitude);
      print(_locData.longitude);

      _showPreview(_locData.latitude, _locData.longitude);
      widget.onSelectPlace(_locData.latitude, _locData.longitude);
    } catch (error) {
      return;
    }
  }

  Future<void> _selectOnMap() async {
    final LatLng selectedLocation = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(
          isSelecting: true,
        ),
      ),
    );
    if (selectedLocation == null) {
      return;
    }
    _showPreview(selectedLocation.latitude, selectedLocation.longitude);
    widget.onSelectPlace(selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border.all(
            width: 1,
            color: Colors.grey,
          )),
          child: _previewImageUrl == null
              ? Text(
                  '場所が未選択です',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageUrl, // Google mapから取得する画像
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton.icon(
              icon: Icon(Icons.location_on),
              label: Text('現在地'),
              style: ButtonStyle(
                foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.indigo),
              ),
              onPressed: _getCurrentUserLocation,
            ),
            TextButton.icon(
              icon: Icon(Icons.map),
              label: Text('地図から選択'),
              style: ButtonStyle(
                foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.indigo),
              ),
              onPressed: _selectOnMap,
            )
          ],
        ),
      ],
    );
  }
}
