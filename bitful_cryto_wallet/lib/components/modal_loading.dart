import 'package:bitful_cryto_wallet/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';

class ModalLoading extends StatelessWidget {
  const ModalLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    return SimpleDialog(
      contentPadding: EdgeInsets.all(10),
      children: [
        Container(
          width: width * 0.9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(Get.width * 0.1)),
            color: MyColors.Platinum,
          ),
          child: Column(
            children: [
              CircularProgressIndicator(
                  strokeWidth: 2.0, color: MyColors.SteelPink),
              SizedBox(height: 15),
              Text(tr("waiting"))
            ],
          ),
        )
      ],
    );
  }
}
