import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../shared/constants.dart';
import 'alert_dialog.dart';
import 'formfield.dart';

Widget rentEditIcon({
  required BuildContext context,
  required String rentId,
  required String carModel,
  required TextEditingController returnOdometerController,
  required final GlobalKey<FormState> formKey,
}) {
  return BlocConsumer<GoWheelsCubit, GoWheelsStates>(
    listener: (context, state) {},
    builder: (context, state) {
      return IconButton(
          onPressed: () async {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Container(
                          // height: MediaQuery.of(context).size.height * 0.3,
                          color: fabColor,
                          child: Form(
                            key: formKey,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: defaultFormField(
                                        keyboard: TextInputType.number,
                                        label: 'Add Current Odometer',
                                        error: 'please Enter Car Odometer',
                                        prefix: Icons.numbers,
                                        controller: returnOdometerController),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: titlesColor,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                                color: Colors.white30)),
                                        child: MaterialButton(
                                          onPressed: () {
                                            if (formKey.currentState!
                                                .validate()) {
                                              cubit(context)
                                                  .editRentDetail(
                                                      returnOdometer: int.parse(
                                                          returnOdometerController
                                                              .text),
                                                      rentId: rentId,
                                                      carModel: carModel)
                                                  .then((value) {
                                                returnOdometerController
                                                    .clear();
                                                Navigator.pop(context);
                                              });
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15.0),
                                            child: Text('Confirm',
                                                style: nunitoStyle.copyWith(
                                                    color: Colors.black,
                                                    fontSize: 24,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }));
          },
          icon: const Icon(
            Icons.edit,
            color: Colors.white,
          ));
    },
  );
}
