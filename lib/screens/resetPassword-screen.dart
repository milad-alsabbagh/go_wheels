import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_wheels/cubit/cubit.dart';
import 'package:go_wheels/shared/constants.dart';
import '../cubit/states.dart';
import '../shared/methods.dart';
import '../widgets/formfield.dart';
import 'login-screen.dart';

// ignore: must_be_immutable
class ResetPassword extends StatelessWidget {
  var emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  ResetPassword({super.key});

  GoWheelsCubit cubit(context) => BlocProvider.of(context);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GoWheelsCubit, GoWheelsStates>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: backGroundColor,
            body: Center(
                child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  defaultFormField(
                    controller: emailController,
                    label: 'Enter your mail to reset password',
                    error: 'email mustn\'t be empty',
                    prefix: Icons.email,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: titlesColor,
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(color: Colors.grey)),
                      child: MaterialButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            cubit(context)
                                .resetPassword(email: emailController.text)
                                .then((value) {
                              emailController.clear();
                              navigateTo(context, LogIn());
                            });
                          }
                        },
                        child: Text(
                          'Reset Password',
                          style: nunitoStyle.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 24),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
          );
        },
        listener: (context, state) {});
  }
}
