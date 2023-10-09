import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_wheels/cubit/cubit.dart';
import 'package:go_wheels/cubit/states.dart';
import 'package:go_wheels/shared/constants.dart';
import '../shared/ui.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

import '../widgets/alert_dialog.dart';
import '../widgets/car_model_container.dart';
import '../widgets/drawer.dart';
import '../widgets/fab.dart';

// ignore: must_be_immutable
class CarsList extends StatelessWidget {
  final String permission;
  final String role;
  CarsList({super.key, required this.permission, required this.role});
  GoWheelsCubit cubit(context) => BlocProvider.of(context);
  var carModelController = TextEditingController();
  var carNumberController = TextEditingController();
  bool isDismissible = false;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    List<Map> carsList = cubit(context).carsList;
    return BlocConsumer<GoWheelsCubit, GoWheelsStates>(
        builder: (context, state) {
          if (permission == 'true' && role == 'manager') {
            isDismissible = true;
          }
          if (permission == 'false' || role != 'manager') {
            isDismissible = false;
          }

          return Scaffold(
              drawer: drawer(context: context),
              appBar: AppBar(
                backgroundColor: backGroundColor,
                elevation: 5,
                leading: Builder(builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: InkWell(
                        onTap: () {
                          Scaffold.of(context).openDrawer();
                        },
                        child: const Image(
                          width: 24,
                          height: 24,
                          image: AssetImage('assets/images/settings.png'),
                        )),
                  );
                }),
                // automaticallyImplyLeading: false,
              ),
              backgroundColor: backGroundColor,
              body: ConditionalBuilder(
                condition: carsList.isNotEmpty,
                builder: (context) => permission == 'true'
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: ListView.separated(
                            itemBuilder: (context, index) {
                              final car = carsList[index];
                              return Dismissible(
                                key: ObjectKey(car),
                                confirmDismiss: (direction) {
                                  if (isDismissible == true) {
                                    showDialog<void>(
                                      context: context,
                                      barrierDismissible:
                                          true, // user must tap button!
                                      builder: (BuildContext context) {
                                        return deleteCarAlertDialog(
                                            carModel: carsList[index]['model'],
                                            context: context);
                                      },
                                    );
                                    return Future.value(false);
                                  } else {
                                    Fluttertoast.showToast(
                                        msg:
                                            'you don\'t have permission to delete car from database',
                                        backgroundColor: Colors.redAccent,
                                        toastLength: Toast.LENGTH_LONG);
                                    return Future.value(false);
                                  }
                                },
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Stack(
                                      children: [
                                        carModelContainer(
                                            car: carsList[index],
                                            permission: permission,
                                            role: role,
                                            context: context),
                                        carDetailIconNavigator(
                                            context: context,
                                            car: carsList[index],
                                            permission: permission,
                                            role: role)
                                      ],
                                    )),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 10),
                            itemCount: carsList.length),
                      )
                    : Center(
                        child: Text(
                        'you don\'t have permission to read dataBase',
                        style: nunitoStyle,
                      )),
                fallback: (context) => Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Here you can add your Cars ',
                      style: nunitoStyle.copyWith(fontSize: 30),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              floatingActionButton: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: permission == 'true'
                    ? defaultFabButton(
                        context: context,
                        fabIcon: Icons.add_circle_outline,
                        fabText: 'Add Car',
                        label1: 'Add Car Model',
                        error1: 'Please Add Car Model',
                        label2: 'Add Car Number',
                        error2: 'Please Add Car Number',
                        onConfirm: () {
                          if (formKey.currentState!.validate()) {
                            cubit(context).addNewCar(
                                carModel: carModelController.text,
                                carNumber: carNumberController.text);
                            carNumberController.clear();
                            carModelController.clear();
                            Navigator.pop(context);
                          }
                        },
                        iconData1: Icons.car_rental,
                        iconData2: Icons.numbers,
                        controller1: carModelController,
                        controller2: carNumberController,
                        formKey: formKey)
                    : null,
              ));
        },
        listener: (context, state) {});
  }
}
