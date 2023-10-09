import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_wheels/cubit/cubit.dart';
import 'package:go_wheels/cubit/states.dart';
import 'package:go_wheels/shared/constants.dart';
import 'package:go_wheels/shared/methods.dart';
import '../widgets/formfield.dart';
import 'login-screen.dart';

// ignore: must_be_immutable
class SignUp extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();
  var nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  SignUp({super.key});
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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    defaultFormField(
                        label: 'Enter your Email',
                        error: 'Email mustn\'t be empty',
                        prefix: Icons.email,
                        controller: emailController,
                        keyboard: TextInputType.emailAddress),
                    defaultFormField(
                        label: 'Enter your password',
                        error: 'password mustn\'t be empty',
                        prefix: Icons.visibility,
                        controller: passwordController,
                        isSecure: true),
                    defaultFormField(
                        label: 'Enter your Name',
                        error: 'Name mustn\'t be empty',
                        prefix: Icons.person,
                        controller: nameController),
                    defaultFormField(
                        label: 'Enter your phone number',
                        error: 'phone mustn\'t be empty',
                        prefix: Icons.phone_android,
                        controller: phoneController,
                        keyboard: TextInputType.number),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: titlesColor,
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(color: Colors.white30)),
                        child: MaterialButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              cubit(context)
                                  .signUp(
                                      email: emailController.text,
                                      password: passwordController.text,
                                      name: nameController.text,
                                      phone: phoneController.text)
                                  .then((value) {
                                emailController.clear();
                                passwordController.clear();
                                navigateTo(context, LogIn());
                              });
                            }
                          },
                          child: Text(
                            'SIGN UP',
                            style: nunitoStyle.copyWith(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
          );
        },
        listener: (context, state) {});
  }
}
