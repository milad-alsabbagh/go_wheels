import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_wheels/cubit/cubit.dart';
import 'package:go_wheels/cubit/states.dart';
import 'package:go_wheels/shared/constants.dart';

class CarDetail extends StatelessWidget {
  final String carModel;
  final String permission;
  final String role;
  CarDetail(
      {required this.carModel, required this.permission, required this.role});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GoWheelsCubit, GoWheelsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: backGroundColor,
        );
      },
    );
  }
}
