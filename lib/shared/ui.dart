import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget carDetailIconNavigator(
    {required BuildContext context,
    required Map car,
    required String permission,
    required String role}) {
  return Container(
      decoration: const BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(5),
            bottomLeft: Radius.circular(5),
            bottomRight: Radius.circular(5),
          )),
      child: IconButton(
          onPressed: () {
            Fluttertoast.showToast(
                msg: 'this feature coming in updating scoop stay tuned',
                backgroundColor: Colors.blueGrey,
                toastLength: Toast.LENGTH_LONG);
          },
          icon: const Icon(
            Icons.edit,
            color: Colors.white,
          )));
}
