import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_wheels/cubit/states.dart';
import '../cubit/cubit.dart';
import '../shared/constants.dart';
import '../widgets/bill_container.dart';
import '../widgets/fab.dart';

// ignore: must_be_immutable
class IncomeBuilder extends StatelessWidget {
  var incomeSourceController = TextEditingController();
  var incomeAmountController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  IncomeBuilder({super.key});
  GoWheelsCubit cubit(context) => BlocProvider.of(context);
  @override
  Widget build(BuildContext context) {
    List<Map> incomeList = cubit(context).incomeDetails;
    return BlocConsumer<GoWheelsCubit, GoWheelsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: backGroundColor,
          body: ConditionalBuilder(
            builder: (context) => BillContainer(
              billList: incomeList,
              sourceReason: 'source',
            ),
            fallback: (context) => Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Here you can add your Income for this month',
                  style: nunitoStyle.copyWith(fontSize: 30),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            condition: incomeList.isNotEmpty,
          ),
          floatingActionButton: defaultFabButton(
              context: context,
              fabIcon: Icons.monetization_on,
              fabText: 'Add Income',
              label1: 'Add Income Source',
              error1: 'Please Add Income Source',
              label2: 'Add Income Amount',
              error2: 'please Add Income Amount',
              onConfirm: () {
                if (formKey.currentState!.validate()) {
                  cubit(context).addIncome(
                      amount: int.parse(incomeAmountController.text),
                      source: incomeSourceController.text);
                  incomeSourceController.clear();
                  incomeAmountController.clear();
                  Navigator.pop(context);
                }
              },
              keyBoardType2: TextInputType.number,
              iconData1: Icons.info_outline,
              iconData2: Icons.monetization_on,
              controller1: incomeSourceController,
              controller2: incomeAmountController,
              formKey: formKey),
        );
      },
    );
  }
}
