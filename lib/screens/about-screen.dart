import 'package:flutter/material.dart';
import 'package:go_wheels/shared/constants.dart';
class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50.0),
          child: Column(
            children: [
              const Image(image:AssetImage(
                'assets/images/go-wheels.png'
              ),),
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                     Text('for more information, suggestions, updates and ideas please contact.',style:nunitoStyle,),
                    const SizedBox(height: 7,),
                    Row(
                      children:  [
                        Text('E_mail :  ',style:nunitoStyle,),
                        Text('alsabbaghmeald@gmail.com',style:nunitoStyle.copyWith(color: textButtonsColor,fontSize: 18),),
                        const SizedBox(height: 7,),

                      ],
                    ),
                    const SizedBox(height: 7,),
                    Row(
                      children:  [
                         Text('Phone :  ',style: nunitoStyle,),
                        Text('+9647510209547',style: TextStyle(color:textButtonsColor,fontSize: 18),),
                        const SizedBox(height: 20,),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Container(
                      height: 3,
                      width: double.infinity,
                      color: Colors.grey,
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
