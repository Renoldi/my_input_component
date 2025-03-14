import 'package:flutter/material.dart';

class ViewModel extends ChangeNotifier {
  void commit() {
    notifyListeners();
  }

  int? intNull;
  double? decimalNull;

  int pin1 = 0;
  int pin2 = 0;
  int pin3 = 0;
  int pin4 = 0;
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();
}
