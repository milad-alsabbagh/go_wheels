import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_wheels/cubit/cubit.dart';
import 'package:go_wheels/cubit/states.dart';
import 'package:go_wheels/shared/constants.dart';
import '../widgets/edit_container.dart';
import '../widgets/fab.dart';

// ignore: must_be_immutable
class RentDetails extends StatelessWidget {
  final String permission;
  final String role;
  final String carModel;
  RentDetails(
      {super.key,
      required this.permission,
      required this.role,
      required this.carModel});
  GoWheelsCubit cubit(context) => BlocProvider.of(context);
  ScrollController listScrollController = ScrollController();
  var rentOdometerController = TextEditingController();
  var returnOdometerController = TextEditingController();
  var returnDateController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    List<Map> rentsDetails = cubit(context).rentDetails;
    return BlocConsumer<GoWheelsCubit, GoWheelsStates>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: backGroundColor,
            appBar: AppBar(
              backgroundColor: backGroundColor,
              elevation: 7.0,
              title: Text(
                carModel,
                style: nunitoStyle.copyWith(fontSize: 20),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ConditionalBuilder(
                    condition: rentsDetails.isNotEmpty,
                    builder: (context) => ListView.separated(
                      controller: listScrollController,
                      itemBuilder: (context, index) => Stack(
                        children: [
                          Container(
                              width: double.infinity,
                              color: index % 2 == 0
                                  ? darkDetailBackGroundColor
                                  : lightDetailBackGroundColor,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${rentsDetails[index]['rentDate']}//..${rentsDetails[index]['rentTime']}//..${rentsDetails[index]['rentKilo']}KM ',
                                      style: index % 2 == 0
                                          ? nunitoStyle.copyWith(fontSize: 20)
                                          : nunitoStyle.copyWith(
                                              color: Colors.black,
                                              fontSize: 20),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      '${rentsDetails[index]['returnDate']}//..${rentsDetails[index]['returnTime']} //..${rentsDetails[index]['returnKilo']}KM ',
                                      style: index % 2 == 0
                                          ? nunitoStyle.copyWith(fontSize: 20)
                                          : nunitoStyle.copyWith(
                                              color: Colors.black,
                                              fontSize: 20),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              )),
                          rentEditIcon(
                              formKey: formKey,
                              returnOdometerController:
                                  returnOdometerController,
                              context: context,
                              rentId: rentsDetails[index]['rentId'],
                              carModel: carModel),
                        ],
                      ),
                      separatorBuilder: (context, index) => Container(
                        height: 3,
                        width: 50,
                        color: titlesColor,
                      ),
                      itemCount: rentsDetails.length,
                    ),
                    fallback: (context) => Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'Here You can add rent detail for ${carModel}',
                          style: nunitoStyle.copyWith(fontSize: 30),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 25.0, top: 10.0, right: 20),
                  child: CircleAvatar(
                    backgroundColor: fabColor,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_downward,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        cubit(context).getMoreRents(carModel: carModel);
                        listScrollController.animateTo(
                          listScrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
            floatingActionButton: defaultFabButton(
                context: context,
                fabIcon: Icons.add_circle_outline,
                fabText: 'Add Rent',
                label1: 'Add current odoMeter',
                error1: 'Please add odoMeter',
                label2: 'Enter return Date',
                error2: 'Please Choose return Date',
                onConfirm: () {
                  if (formKey.currentState!.validate()) {
                    cubit(context)
                        .addRentDetail(
                            rentDate: DateTime.now().toString(),
                            carModel: carModel,
                            returnDate: returnDateController.text,
                            rentOdometer:
                                int.parse(rentOdometerController.text))
                        .then((value) {
                      rentOdometerController.clear();
                      returnDateController.clear();
                      Navigator.pop(context);
                    });
                  }
                },
                onTap2: () async {
                  DateTime? pickedDate = await showDatePicker(
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2030),
                      context: context);
                  if (pickedDate != null) {
                    returnDateController.text =
                        pickedDate.toString().substring(0, 10);
                  }
                },
                readOnly2: true,
                keyBoardType1: TextInputType.number,
                iconData1: Icons.local_gas_station_outlined,
                iconData2: Icons.date_range,
                controller1: rentOdometerController,
                controller2: returnDateController,
                formKey: formKey),
          );
        },
        listener: (context, state) {});
  }
}
