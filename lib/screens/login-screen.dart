import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_wheels/cubit/cubit.dart';
import 'package:go_wheels/cubit/states.dart';
import 'package:go_wheels/screens/resetPassword-screen.dart';
import 'package:go_wheels/screens/signup-screen.dart';
import 'package:go_wheels/shared/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../shared/methods.dart';
import '../widgets/formfield.dart';
import 'about-screen.dart';
import 'home-screen.dart';

// ignore: must_be_immutable
class LogIn extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  LogIn({super.key});
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
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Text('GO-WHEELS',
                            style: GoogleFonts.sirinStencil(
                              fontSize: 60,
                              color: titlesColor,
                            )),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Powered by ',
                                style: nunitoStyle.copyWith(fontSize: 18)),
                            Text('MILAD ALSABBGH',
                                style: GoogleFonts.charm(
                                    color: Colors.white, fontSize: 22))
                          ],
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        defaultFormField(
                            label: 'Enter your email',
                            error: 'Email mustn\'t be empty',
                            prefix: Icons.mail,
                            controller: emailController,
                            keyboard: TextInputType.emailAddress),
                        defaultFormField(
                            label: 'Enter your password',
                            error: 'password mustn\'t be empty',
                            prefix: Icons.visibility,
                            controller: passwordController,
                            isSecure: true),
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
                                      .logIn(
                                          password: passwordController.text,
                                          email: emailController.text)
                                      .then((value) {
                                    cubit(context)
                                        .getPermissionRole(
                                            email: emailController.text)
                                        .then((value) {
                                      navigateTo(
                                          context,
                                          Home(
                                              permission:
                                                  cubit(context).permission,
                                              role: cubit(context).role));
                                    });
                                  }).catchError((error) {
                                    Fluttertoast.showToast(
                                        msg: error.toString(),
                                        backgroundColor: Colors.red,
                                        toastLength: Toast.LENGTH_LONG);
                                  });
                                }
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Text('LOG IN',
                                    style: nunitoStyle.copyWith(
                                        color: Colors.black,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            children: [
                              Text('Forgot your password ?',
                                  style: nunitoStyle),
                              const SizedBox(
                                width: 2,
                              ),
                              TextButton(
                                  onPressed: () {
                                    navigateTo(context, ResetPassword());
                                  },
                                  child: Text('Reset Password',
                                      style: nunitoStyle.copyWith(
                                          color: textButtonsColor)))
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 0.0, left: 20.0, right: 10.0),
                                child: Container(
                                  height: 3,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Text(
                              'OR',
                              style: nunitoStyle.copyWith(fontSize: 22),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 0.0, left: 10.0, right: 20.0),
                                child: Container(
                                  height: 3,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                            onPressed: () {
                              navigateTo(context, SignUp());
                            },
                            child: Text('Sign Up',
                                style: nunitoStyle.copyWith(
                                    fontSize: 24, color: textButtonsColor))),
                        const Spacer(),
                        Center(
                          child: TextButton(
                              onPressed: () {
                                navigateTo(context, const About());
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: prefixIconsColor,
                                  ),
                                  const SizedBox(
                                    width: 7.0,
                                  ),
                                  Text('About & Contact',
                                      style: nunitoStyle.copyWith(
                                          color: textButtonsColor)),
                                ],
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        listener: (context, state) {});
  }
}
