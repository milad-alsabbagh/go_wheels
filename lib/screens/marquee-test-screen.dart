import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

import '../shared/constants.dart';
class MarqueeTest extends StatelessWidget {
  const MarqueeTest({super.key});

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body: Center(
       child: ListView.separated(itemBuilder: (Buicontext,index)=>Container(
         height: 100,
         color: index % 2 == 0
             ? darkDetailBackGroundColor
             : lightDetailBackGroundColor,
         child: Padding(
           padding: const EdgeInsets.all(10.0),
           child: Column(
             mainAxisSize: MainAxisSize.min,
             children: [
               Text('hello world!',style: TextStyle(color: Colors.black),),
               Expanded(
                 child: Row(
                   children: [
                     Container(
                         width: MediaQuery.of(context).size.width*0.4,
                         // height:  MediaQuery.of(context).size.height,
                         child: Marquee(text: 'first text iejfiejifjefjeifjeijfeijfiejfiejifije',
                           style: TextStyle(fontSize: 16),
                         )),
                     SizedBox(width: 40,),
                     Container(
                         width: MediaQuery.of(context).size.width*0.4,
                         // height:  MediaQuery.of(context).size.height,
                         child: Marquee(text: 'jiejfiejfiejfiejfiejfiejfiejfijeifjef990',
                           velocity: 50,
                           blankSpace: 100,
                           startPadding: 20,
                           style: TextStyle(fontSize: 16),
                         )),
                   ],
                 ),
               ),
             ],
           ),
         ),
       ), separatorBuilder: (context,index)=>Container(height: 7,width: double.infinity,), itemCount: 5)
     ),
   );
  }
}
