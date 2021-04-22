import 'dart:io'; // File typeを使うのに必要

import 'package:flutter/foundation.dart'; // @required するのに必要

class PlaceLocation {
  final double latitude;
  final double longitude;
  final String address;

  const PlaceLocation({
    @required this.latitude,
    @required this.longitude,
    this.address,
  });
}

class Place {
  final String id;
  final String title;
  final PlaceLocation location; // 緯度経度　と 住所。このために新たにclassを作成
  final File image; // device上のファイル

  Place({
    @required this.id,
    @required this.title,
    @required this.location,
    @required this.image,
  });
}
