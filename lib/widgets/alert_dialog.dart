import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../shared/constants.dart';

GoWheelsCubit cubit(context) => BlocProvider.of(context);
Widget deleteCarAlertDialog(
    {required carModel, required BuildContext context}) {
  return BlocConsumer<GoWheelsCubit, GoWheelsStates>(
    listener: (context, state) {},
    builder: (context, state) {
      return AlertDialog(
        backgroundColor: fabColor,
        title: Row(
          children: [
            Icon(
              Icons.warning_amber,
              color: notAvailableColor,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              'Delete car from database',
              style: nunitoStyle,
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('You are about to delete $carModel', style: nunitoStyle),
              const SizedBox(
                height: 7.0,
              ),
              Text(
                  'and its all information from dataBase this operation can\'t be undone',
                  style: nunitoStyle)
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel',
                style: nunitoStyle.copyWith(color: notAvailableColor)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Approve',
                style: nunitoStyle.copyWith(color: availableColor)),
            onPressed: () async {
              Navigator.pop(context);
              Timer(const Duration(milliseconds: 100), () {
                cubit(context).deleteCar(carModel: carModel);
              });
            },
          )
        ],
      );
    },
  );
}
