import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_wheels/cubit/cubit.dart';
import 'package:go_wheels/cubit/states.dart';
import 'package:go_wheels/screens/carsList-screen.dart';
import 'package:go_wheels/shared/constants.dart';
import 'package:go_wheels/shared/methods.dart';

import '../widgets/alert_dialog.dart';
import '../widgets/navigator_image.dart';
import 'accounts-screen.dart';

class Home extends StatelessWidget {
  final String permission;
  final String role;
  const Home({super.key, required this.role, required this.permission});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GoWheelsCubit, GoWheelsStates>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: backGroundColor,
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    navigatorImage(
                        imagePath: 'assets/images/cars.jpg',
                        context: context,
                        onTap: () async {
                          await cubit(context).getCarsList().then((value) {
                            navigateTo(context,
                                CarsList(permission: permission, role: role));
                          });
                        },
                        text: 'CARS'),
                    Container(
                      width: double.infinity,
                      height: 3,
                      color: Colors.blueGrey,
                    ),
                    navigatorImage(
                        imagePath: 'assets/images/accounts.jpg',
                        onTap: () async {
                          await cubit(context).getTotalRevenue().then((value) =>
                              {
                                navigateTo(
                                    context,
                                    Accounts(
                                        permission: permission, role: role))
                              });
                        },
                        context: context,
                        text: 'ACCOUNTS')
                  ],
                ),
              ),
            ),
          );
        },
        listener: (context, state) {});
  }
}
