import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/image_input.dart';
import '../providers/great_places.dart';
import '../widgets/location_input.dart';
import '../models/place.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = '/add-place';

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File _pickedImage;
  PlaceLocation _pickedLocation;

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _selectPlace(double lat, double lng) {
    _pickedLocation = PlaceLocation(
      latitude: lat,
      longitude: lng,
    );
  }

  void _savePlace() {
    if (_titleController.text.isEmpty ||
        _pickedImage == null ||
        _pickedLocation == null) {
      return;
    }
    Provider.of<GreatPlaces>(context, listen: false)
        .addPlace(_titleController.text, _pickedImage, _pickedLocation);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('訪問地を追加'),
      ),
      body: SafeArea(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween, // 下のColumnをExpandedでwrapしたので不要になった
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(labelText: 'タイトル'),
                        controller: _titleController,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ImageInput(_selectImage),
                      SizedBox(
                        height: 10,
                      ),
                      LocationInput(_selectPlace),
                    ],
                  ),
                ),
              ),
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.add),
              label: Text('追加'),
              onPressed: _savePlace,
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.yellow[800]),
                foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.indigo),
                // textStyle: MaterialStateProperty.all<TextStyle>(     // ボールドにしたい！
                //   TextStyle(
                //     fontStyle: FontStyle.italic,
                //   ),
                // ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
