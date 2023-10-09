import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

import '../shared/constants.dart';

class BillContainer extends StatelessWidget {
  const BillContainer(
      {super.key, required this.billList, required this.sourceReason});

  final List<Map> billList;
  final String sourceReason;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ListView.separated(
        itemBuilder: (context, index) => Container(
            height: 100,
            width: double.infinity,
            color: index % 2 == 0
                ? darkDetailBackGroundColor
                : lightDetailBackGroundColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      '${billList[index]['amount']}\$',
                      style: index % 2 == 0
                          ? nunitoStyle.copyWith(fontSize: 30)
                          : nunitoStyle.copyWith(
                              color: Colors.black, fontSize: 30),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Marquee(
                            text: '${billList[index][sourceReason]}... ',
                            velocity: 20,
                            blankSpace: 2,
                            style: index % 2 == 0
                                ? nunitoStyle.copyWith(
                                    fontSize: 18, color: Colors.white54)
                                : nunitoStyle.copyWith(
                                    color: Colors.black54, fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.01,
                            decoration: BoxDecoration(
                                color: index % 2 == 0
                                    ? lightDetailBackGroundColor
                                    : darkDetailBackGroundColor,
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Marquee(
                            text: 'AT ${billList[index]['date']}...',
                            velocity: 25,
                            blankSpace: 2,
                            style: index % 2 == 0
                                ? nunitoStyle.copyWith(
                                    fontSize: 18, color: Colors.grey)
                                : nunitoStyle.copyWith(
                                    color: Colors.black54, fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
        separatorBuilder: (context, index) => Container(
          height: 3,
          width: 50,
          color: titlesColor,
        ),
        itemCount: billList.length,
      ),
    );
  }
}
