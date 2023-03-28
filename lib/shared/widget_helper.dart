import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

showLoading(Color color) {
  return SpinKitThreeBounce(
    color: color,
    size: 16.0,
  );
}
