import 'package:flutter/material.dart';

abstract class FormValidator {
  bool validateStep(int currentStep, Map<int, GlobalKey<FormState>> formKeys);
}

class ValidateStep implements FormValidator {
  @override
  bool validateStep(int currentStep, Map<int, GlobalKey<FormState>> formKeys) {
    final formKey = formKeys[currentStep];

    if (formKey == null) {     
      return false;
    }

    if (formKey.currentState == null) {    
      return false;
    }

    if (!formKey.currentState!.validate()) {    
      return false;
    }

    formKey.currentState!.save();    
    return true;
  }
}
