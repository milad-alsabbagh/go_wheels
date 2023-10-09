import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_wheels/cubit/states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_wheels/shared-prefrences/cache_helper.dart';
import 'package:go_wheels/shared/constants.dart';
import 'package:go_wheels/shared/enum.dart';

class GoWheelsCubit extends Cubit<GoWheelsStates> {
  GoWheelsCubit() : super(GoWheelsInitialState());
  static get(context) => BlocProvider.of(context);

  //signUp new user
  Future<void> signUp(
      {required String email,
      required String password,
      required String name,
      required String phone}) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    await FirebaseFirestore.instance.collection('employees').doc(email).set({
      'name': name,
      'phone': phone,
      'role': 'employee',
      'permission': 'false',
    });
    emit(SignUpState());
  }

  Future<void> logIn({required String password, required String email}) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    CacheHelper.putStringDate(
        key: sharedPrefernecesKeys.email.toString().split('.').last,
        value: email);
    CacheHelper.putBoolDate(
        key: sharedPrefernecesKeys.isLogIn.toString().split('.').last,
        value: true);
    emit(LogInState());
  }

  Future<void> signOut() async {
    await CacheHelper.sharedPreferences!
        .remove(sharedPrefernecesKeys.isLogIn.toString().split('.').last);
    await CacheHelper.sharedPreferences!
        .remove(sharedPrefernecesKeys.email.toString().split('.').last);
    emit(SignOutState());
  }

  Future<void> resetPassword({required String email}) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    emit(ResetPasswordState());
  }

  String role = '';
  String permission = '';
  Future<void> getPermissionRole({required email}) async {
    if (email != 'nomail') {
      await FirebaseFirestore.instance
          .collection('employees')
          .doc(email)
          .get()
          .then((value) {
        role = value.get('role');
        permission = value.get('permission');
      });
    }
    emit(GetPermissionRoleState());
  }

//get cars List
  List<Map> carsList = [];
  Future<void> getCarsList() async {
    print(DateTime.now().toString().substring(0, 10));
    carsList = [];
    final collectionReference = FirebaseFirestore.instance.collection('cars');
    _subscription = collectionReference.snapshots().listen((event) {
      carsList.clear();
      for (var element in event.docs) {
        carsList.add({
          'model': element.id,
          'number': element.get('carNumber'),
          if (element.get('lastDate') == '' ||
              DateTime.now().isAfter(DateTime.parse(element.get('lastDate'))))
            'availability': 'true'
          else
            'availability': 'false'
        });
      }
      emit(GetCarsListState());
    }, onError: (error) {
      Fluttertoast.showToast(
          msg: error.toString(), backgroundColor: Colors.red);
    });
  }

//add new Car to the list
  Future<void> addNewCar(
      {required String carModel, required String carNumber}) async {
    FirebaseFirestore.instance
        .collection('cars')
        .doc(carModel)
        .set({'carNumber': carNumber, 'lastDate': ''});
    emit(AddNewCarState());
  }

  Future<void> deleteCar({required String carModel}) async {
    // await FirebaseFirestore.instance.collection('cars').doc(carModel).collection('rents').delete();
    await FirebaseFirestore.instance.collection('cars').doc(carModel).delete();
    emit(DeleteCarState());
  }

  List<Map> rentDetails = [];

  StreamSubscription<QuerySnapshot>? _subscription;
  DocumentSnapshot? _lastDocument;

  Future<void> getRentsList({required String carModel}) async {
    rentDetails = [];
    final collectionReference = FirebaseFirestore.instance
        .collection('cars')
        .doc(carModel)
        .collection('rents')
        .orderBy('rentDate', descending: true)
        .limit(5); // Add limit here

    _subscription = collectionReference.snapshots().listen((event) {
      rentDetails.clear();
      for (var element in event.docs) {
        rentDetails.add({
          'rentId': element.id,
          'rentDate': element.get('rentDate'),
          'returnDate': element.get('returnDate'),
          'rentKilo': element.get('rentKilo'),
          'returnKilo':
              element.get('returnKilo') == 0.1 ? 0 : element.get('returnKilo'),
          'rentTime': element.get('rentTime'),
          'returnTime': element.get('returnTime'),
        });
      }

      if (event.docs.isNotEmpty) {
        // Save the last document
        _lastDocument = event.docs.last;
      }

      emit(GetRentSDetailsState());
    }, onError: (error) {
      Fluttertoast.showToast(
          msg: error.toString(), backgroundColor: notAvailableColor);
    });
  }

  Future<void> getMoreRents({required String carModel}) async {
    if (_lastDocument == null) return; // No more documents to fetch

    final collectionReference = FirebaseFirestore.instance
        .collection('cars')
        .doc(carModel)
        .collection('rents')
        .orderBy('rentDate', descending: true)
        .startAfterDocument(_lastDocument!) // Use startAfterDocument here
        .limit(5);

    final snapshot = await collectionReference.get();
    for (var element in snapshot.docs) {
      rentDetails.add({
        'rentId': element.id,
        'rentDate': element.get('rentDate'),
        'returnDate': element.get('returnDate'),
        'rentKilo': element.get('rentKilo'),
        'returnKilo':
            element.get('returnKilo') == 0.1 ? 0 : element.get('returnKilo'),
        'rentTime': element.get('rentTime'),
        'returnTime': element.get('returnTime'),
      });
    }

    if (snapshot.docs.isNotEmpty) {
      // Save the last document for the next query
      _lastDocument = snapshot.docs.last;
    } else {
      _lastDocument = null; // No more documents to fetch
    }

    emit(GetMoreRentsDetailsState());
  }

  Future<void> addRentDetail({
    required String rentDate,
    required String carModel,
    required String returnDate,
    required int rentOdometer,
  }) async {
    await FirebaseFirestore.instance
        .collection("cars")
        .doc(carModel)
        .collection("rents")
        .doc()
        .set({
      'rentDate': rentDate.substring(0, 10),
      'returnDate': returnDate.substring(0, 10),
      'rentKilo': rentOdometer,
      'returnKilo': 0.1,
      'rentTime': rentDate.substring(10, 16),
      'returnTime': 'waiting'
    });
    FirebaseFirestore.instance
        .collection('cars')
        .doc(carModel)
        .update({'lastDate': returnDate.substring(0, 10)});
    emit(AddRentDetailState());
  }

  Future<void> editRentDetail({
    required String rentId,
    required String carModel,
    required int returnOdometer,
  }) async {
    await FirebaseFirestore.instance
        .collection('cars')
        .doc(carModel)
        .collection('rents')
        .doc(rentId)
        .update({
      'returnKilo': returnOdometer,
      'returnTime': DateTime.now().toString().substring(10, 16)
    });
    emit(EditRentDetailState());
  }

  Future<void> addPayment({
    required int amount,
    required String reason,
  }) async {
    int total = 0;
    await FirebaseFirestore.instance
        .collection('accounts')
        .doc('payments')
        .collection('payments')
        .doc()
        .set({
      'date': DateTime.now().toString().substring(0, 10),
      'reason': reason,
      'amount': amount,
      'timeStamp': DateTime.now()
    });
    await FirebaseFirestore.instance
        .collection('accounts')
        .doc('revenue')
        .get()
        .then((value) {
      total = value.get('total');
    }).then((value) {
      FirebaseFirestore.instance.collection('accounts').doc('revenue').update({
        'total': total - amount,
      });
    }).catchError((error) {
      FirebaseFirestore.instance
          .collection('accounts')
          .doc('revenue')
          .set({'total': -amount});
    });
    emit(AddPaymentState());
    getTotalRevenue();
    getPaymentsList();
  }

  List<Map> paymentDetails = [];
  Future<void> getPaymentsList() async {
    paymentDetails = [];
    final collectionReference = FirebaseFirestore.instance
        .collection('accounts')
        .doc('payments')
        .collection('payments')
        .orderBy('timeStamp', descending: true); // Add limit here
    _subscription = collectionReference.snapshots().listen((event) {
      paymentDetails.clear();
      for (var element in event.docs) {
        paymentDetails.add({
          'date': element.get('date'),
          'reason': element.get('reason'),
          'amount': element.get('amount'),
        });
      }

      emit(GetPaymentsState());
    }, onError: (error) {
      Fluttertoast.showToast(
          msg: error.toString(), backgroundColor: notAvailableColor);
    });
  }

  Future<void> addIncome({
    required int amount,
    required String source,
  }) async {
    int total = 0;
    await FirebaseFirestore.instance
        .collection('accounts')
        .doc('income')
        .collection('income')
        .doc()
        .set({
      'date': DateTime.now().toString().substring(0, 10),
      'source': source,
      'amount': amount,
      'timeStamp': DateTime.now()
    });
    await FirebaseFirestore.instance
        .collection('accounts')
        .doc('revenue')
        .get()
        .then((value) {
      total = value.get('total');
    }).then((value) {
      FirebaseFirestore.instance.collection('accounts').doc('revenue').update({
        'total': total + amount,
      });
    }).catchError((error) {
      FirebaseFirestore.instance
          .collection('accounts')
          .doc('revenue')
          .set({'total': amount});
    });
    emit(AddIncomeState());
    getTotalRevenue();
    getIncomeList();
  }

  List<Map> incomeDetails = [];
  Future<void> getIncomeList() async {
    incomeDetails = [];
    final collectionReference = FirebaseFirestore.instance
        .collection('accounts')
        .doc('income')
        .collection('income')
        .orderBy('timeStamp', descending: true); // Add limit here
    _subscription = collectionReference.snapshots().listen((event) {
      incomeDetails.clear();
      for (var element in event.docs) {
        incomeDetails.add({
          'date': element.get('date'),
          'source': element.get('source'),
          'amount': element.get('amount'),
        });
      }

      emit(GetIncomeState());
    }, onError: (error) {
      Fluttertoast.showToast(
          msg: error.toString(), backgroundColor: notAvailableColor);
    });
  }

  int totalRevenue = 0;
  Future<void> getTotalRevenue() async {
    await FirebaseFirestore.instance
        .collection('accounts')
        .doc('revenue')
        .get()
        .then((value) {
      totalRevenue = value.get('total');
    }).catchError((error) {
      totalRevenue = 0;
    });
    emit(GetTotalRevenueState());
  }
}
