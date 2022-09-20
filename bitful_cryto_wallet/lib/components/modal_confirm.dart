import 'package:bitful_cryto_wallet/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';

class ModalConfirm extends StatelessWidget {
  final message;
  final confirm;
  final Function()? onConfirm;
  final Function()? onCancel;

  const ModalConfirm(
      {Key? key,
      required this.message,
      required this.confirm,
      this.onConfirm,
      this.onCancel})
      : assert(message != null, confirm != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    return AlertDialog(
      title: Text(
        tr("notify"),
        style: TextStyle(color: MyColors.SteelPink),
      ),
      content: Text(message, style: TextStyle(color: MyColors.SteelPink)),
      actions: <Widget>[
        confirm == true
            ? Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 35,
                      width: width * 0.25,
                      decoration: BoxDecoration(
                        color: MyColors.SteelPink,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextButton(
                        onPressed: () =>
                            {Get.back(), if (onConfirm != null) onConfirm!()},
                        child: Text(tr("ok"),
                            style: TextStyle(color: MyColors.Platinum)),
                      ),
                    ),
                    Container(
                      height: 35,
                      width: width * 0.25,
                      decoration: BoxDecoration(
                        color: MyColors.MajorelleBlue,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextButton(
                        onPressed: () =>
                            {Get.back(), if (onCancel != null) onCancel!()},
                        child: Text(tr("cancel"),
                            style: TextStyle(color: MyColors.Platinum)),
                      ),
                    ),
                  ],
                ),
              )
            : Center(
                child: Container(
                    width: width,
                    height: 40,
                    child: Container(
                      child: TextButton(
                        onPressed: () => Get.back(),
                        child: Text(
                          tr("ok"),
                          style:
                              TextStyle(fontSize: 18, color: MyColors.Platinum),
                        ),
                      ),
                      height: 35,
                      width: width * 0.25,
                      decoration: BoxDecoration(
                        color: MyColors.SteelPink,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ))),
      ],
    );
  }
}
