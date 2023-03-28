import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

String baseApi = 'http://jasakita.id/api/v1';
String placeHolderUrl = 'https://i.postimg.cc/rpsKNndW/New-Project.png';
String userPlaceHolderUrl =
    'https://i.postimg.cc/ZYQp5Xv1/blank-profile-picture-gb26b7fbdf-1280.png';

TextStyle mainFont = GoogleFonts.poppins();
var fourinchScreenHeight = 610;
var fourinchScreenWidth = 385;

String moneyChanger(double value, {String? customLabel}) {
  return NumberFormat.currency(
          name: customLabel ?? 'Rp', decimalDigits: 0, locale: 'id')
      .format(value.round());
}

String dateToReadable(
  String date,
) {
  String finalString = '';

  List<String> breakDate = date.split('-');

  switch (breakDate[1]) {
    case '01':
      finalString = finalString + 'Jan';
      break;
    case '02':
      finalString = finalString + 'Feb';
      break;
    case '03':
      finalString = finalString + 'Mar';
      break;
    case '04':
      finalString = finalString + 'Apr';
      break;
    case '05':
      finalString = finalString + 'Mei';
      break;
    case '06':
      finalString = finalString + 'Jun';
      break;
    case '07':
      finalString = finalString + 'Jul';
      break;
    case '08':
      finalString = finalString + 'Aug';
      break;
    case '09':
      finalString = finalString + 'Sep';
      break;
    case '10':
      finalString = finalString + 'Okt';
      break;
    case '11':
      finalString = finalString + 'Nov';
      break;
    case '12':
      finalString = finalString + 'Des';
      break;
    default:
  }

  finalString = '${breakDate[2]} $finalString ${breakDate[0]}';

  return finalString;
}
