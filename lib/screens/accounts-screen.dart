import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_wheels/cubit/cubit.dart';
import 'package:go_wheels/cubit/states.dart';
import 'package:go_wheels/screens/payments-screen.dart';
import '../shared/constants.dart';
import '../shared/methods.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/navigator_image.dart';
import 'income-screen.dart';

class Accounts extends StatelessWidget {
  final String permission;
  final String role;
  Accounts({required this.permission, required this.role});

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
                        ratio: 0.46,
                        boxFit: BoxFit.cover,
                        imagePath: 'assets/images/income.jpg',
                        context: context,
                        onTap: () async {
                          await cubit(context).getIncomeList().then((value) {
                            print(cubit(context).incomeDetails);
                            navigateTo(context, IncomeBuilder());
                          });
                        },
                        text: 'INCOME'),
                    Container(
                      width: double.infinity,
                      height: 3,
                      color: Colors.blueGrey,
                    ),
                    navigatorImage(
                        ratio: 0.46,
                        boxFit: BoxFit.cover,
                        onTap: () async {
                          await cubit(context).getPaymentsList().then((value) {
                            navigateTo(context, PaymentsBuilder());
                          });
                        },
                        imagePath: 'assets/images/payments.jpg',
                        context: context,
                        text: 'PAYMENTS'),
                    Container(
                      color: backGroundColor,
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.08 - 1,
                      child: Center(
                        child: Text(
                          '${cubit(context).totalRevenue.toString()} \$',
                          style: cubit(context).totalRevenue >= 0
                              ? nunitoStyle.copyWith(
                                  fontSize: 30.0, color: availableColor)
                              : nunitoStyle.copyWith(
                                  fontSize: 30.0, color: textButtonsColor),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
        listener: (context, state) {});
  }
}
