import '../shared/constants.dart';
import 'package:flutter/material.dart';

Widget navigatorImage(
    {required String imagePath,
    double ratio = 0.5,
    required BuildContext context,
    required String text,
    Future Function()? onTap,
    BoxFit boxFit = BoxFit.cover}) {
  return InkWell(
    onTap: onTap,
    child: Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Image(
          image: AssetImage(imagePath),
          fit: boxFit,
          height: MediaQuery.of(context).size.height * ratio - 1,
        ),
        Text(
          text,
          style: nunitoStyle.copyWith(
              fontSize: 60, backgroundColor: Colors.blueGrey.withOpacity(0.5)),
        )
      ],
    ),
  );
}
