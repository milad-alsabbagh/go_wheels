import 'package:flutter/material.dart';

import '../screens/rentsDetail-screen.dart';
import '../shared/constants.dart';
import '../shared/methods.dart';
import 'alert_dialog.dart';

Widget carModelContainer({
  required Map car,
  required BuildContext context,
  required String permission,
  required String role,
}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: formFieldBackGroundColor,
    ),
    child: Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () {
              cubit(context).getRentsList(carModel: car['model']).then((value) {
                navigateTo(
                    context,
                    RentDetails(
                        permission: permission,
                        role: role,
                        carModel: car['model']));
              });
            },
            child: Column(
              children: [
                Text(car['model'],
                    style: nunitoStyle.copyWith(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 7,
                ),
                Text(car['number'],
                    style: nunitoStyle.copyWith(color: Colors.grey)),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10.0, top: 6.0, bottom: 6.0),
          child: Container(
            width: 10,
            height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: car['availability'] == 'true'
                    ? availableColor
                    : notAvailableColor),
          ),
        )
      ],
    ),
  );
}
