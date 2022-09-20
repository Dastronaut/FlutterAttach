import 'package:bitful_cryto_wallet/themes/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonStyle {
  static InputDecoration textFieldStyle({String hintTextStr = ""}) {
    return InputDecoration(
      contentPadding: EdgeInsets.all(12),
      hintText: tr(hintTextStr),
      hintStyle: TextStyle(color: MyColors.Quartz, fontSize: Get.width * 0.04),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Get.width * 0.1),
        borderSide: BorderSide(width: 2, color: MyColors.Quartz),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Get.width * 0.1),
        borderSide: BorderSide(width: 2, color: Colors.red),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Get.width * 0.1),
        borderSide: BorderSide(width: 2, color: MyColors.Quartz),
      ),
    );
  }
}
