import 'package:flutter/material.dart';
import 'package:qixer/shared/const_helper.dart';

class FormHelper {
  static Widget splitRow(
      {String data = '', required String title, Widget? dataCustom}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 4,
          child: SizedBox(
            width: double.infinity,
            child: Text(
              title,
              style: mainFont.copyWith(
                  fontSize: 13,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        SizedBox(width: 5),
        Flexible(
          flex: 6,
          child: SizedBox(
            width: double.infinity,
            child: dataCustom ??
                Text(
                  data,
                  style: mainFont.copyWith(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
          ),
        ),
      ],
    );
  }

  static void showSnackbar(BuildContext context,
      {required String data, required Color colors}) {
    final snack = SnackBar(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      content: Text(
        data,
        style: mainFont.copyWith(fontSize: 12, color: Colors.white),
      ),
      backgroundColor: colors,
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }
}
