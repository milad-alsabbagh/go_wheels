import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_wheels/cubit/cubit.dart';
import 'package:go_wheels/cubit/states.dart';

import '../shared/constants.dart';
import '../widgets/bill_container.dart';
import '../widgets/fab.dart';

// ignore: must_be_immutable
class PaymentsBuilder extends StatelessWidget {
  PaymentsBuilder({super.key});
  var paymentReasonController = TextEditingController();
  var paymentAmountController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  GoWheelsCubit cubit(context) => BlocProvider.of(context);

  @override
  Widget build(BuildContext context) {
    List<Map> payments = cubit(context).paymentDetails;
    return BlocConsumer<GoWheelsCubit, GoWheelsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: backGroundColor,
          body: ConditionalBuilder(
            builder: (context) => BillContainer(
              billList: payments,
              sourceReason: 'reason',
            ),
            fallback: (context) => Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Here you can add your payments for this month',
                  style: nunitoStyle.copyWith(fontSize: 30),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            condition: payments.isNotEmpty,
          ),
          floatingActionButton: defaultFabButton(
              context: context,
              fabIcon: Icons.monetization_on,
              fabText: 'Add Payment',
              label1: 'Add Payment Reason',
              error1: 'Please Add Payment Reason',
              label2: 'Add Payment Amount',
              error2: 'please Add Payment Amount',
              onConfirm: () {
                if (formKey.currentState!.validate()) {
                  cubit(context).addPayment(
                      amount: int.parse(paymentAmountController.text),
                      reason: paymentReasonController.text);
                  paymentReasonController.clear();
                  paymentAmountController.clear();
                  Navigator.pop(context);
                }
              },
              keyBoardType2: TextInputType.number,
              iconData1: Icons.info_outline,
              iconData2: Icons.monetization_on,
              controller1: paymentReasonController,
              controller2: paymentAmountController,
              formKey: formKey),
        );
      },
    );
  }
}
