import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_wheels/cubit/cubit.dart';
import 'package:go_wheels/cubit/states.dart';
import 'package:go_wheels/screens/home-screen.dart';
import 'package:go_wheels/screens/login-screen.dart';
import 'package:go_wheels/shared-prefrences/cache_helper.dart';
import 'package:go_wheels/shared/enum.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();

  var isLogIn = CacheHelper.getBoolData(
      key: sharedPrefernecesKeys.isLogIn.toString().split('.').last);
  print(isLogIn);

  var email = CacheHelper.getStringData(
      key: sharedPrefernecesKeys.email.toString().split('.').last);
  print(email);

  email ??= 'nomail';
  isLogIn ??= false;
  runApp(MyApp(isLogIn: isLogIn, email: email));
}

class MyApp extends StatelessWidget {
  final bool isLogIn;
  final String email;
  MyApp({required this.isLogIn, required this.email});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    GoWheelsCubit cubit(context) => BlocProvider.of(context);
    return BlocProvider(
      create: (context) {
        return GoWheelsCubit()..getPermissionRole(email: email);
      },
      child: BlocConsumer<GoWheelsCubit, GoWheelsStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: child!,
                );
              },
              title: 'GoWheels',
              home: isLogIn
                  ? Home(
                      permission: cubit(context).permission,
                      role: cubit(context).role,
                    )
                  : LogIn());
        },
      ),
    );
  }
}
