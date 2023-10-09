import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../shared/constants.dart';
import 'formfield.dart';

Widget defaultFabButton({
  bool readOnly1 = false,
  bool readOnly2 = false,
  required BuildContext context,
  required IconData fabIcon,
  required String fabText,
  required String label1,
  required String error1,
  required String label2,
  required String error2,
  required Function()? onConfirm,
  TextInputType keyBoardType1 = TextInputType.text,
  TextInputType keyBoardType2 = TextInputType.text,
  Future Function()? onTap1,
  Future Function()? onTap2,
  required IconData iconData1,
  required IconData iconData2,
  required TextEditingController controller1,
  required TextEditingController controller2,
  required final GlobalKey<FormState> formKey,
}) {
  return BlocConsumer<GoWheelsCubit, GoWheelsStates>(
      builder: (context, state) {
        return FloatingActionButton.extended(
          backgroundColor: fabColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                  bottomLeft: Radius.circular(10.0),
                  topLeft: Radius.circular(10.0))),
          onPressed: () async {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) =>
                    StatefulBuilder(builder: (context, StateSetter setState) {
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Container(
                          color: fabColor,
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 10.0),
                                  child: defaultFormField(
                                      onTap: onTap1,
                                      readOnly: readOnly1,
                                      keyboard: keyBoardType1,
                                      label: label1,
                                      error: error1,
                                      prefix: iconData1,
                                      controller: controller1),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: defaultFormField(
                                      onTap: onTap2,
                                      readOnly: readOnly2,
                                      keyboard: keyBoardType2,
                                      label: label2,
                                      error: error2,
                                      prefix: iconData2,
                                      controller: controller2),
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
                                        onPressed: onConfirm,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15.0),
                                          child: Text('Confirm',
                                              style: nunitoStyle.copyWith(
                                                  color: Colors.black,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w500)),
                                        ),
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }));
          },
          label: Row(
            children: [
              Icon(
                fabIcon,
                color: Colors.white,
              ),
              const SizedBox(
                width: 7.0,
              ),
              Text(
                fabText,
                style: const TextStyle(color: Colors.white, fontSize: 16.0),
              )
            ],
          ),
        );
      },
      listener: (context, state) {});
}
