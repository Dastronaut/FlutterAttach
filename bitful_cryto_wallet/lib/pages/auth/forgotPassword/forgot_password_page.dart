import 'package:bitful_cryto_wallet/components/switch_button.dart';
import 'package:bitful_cryto_wallet/pages/auth/forgotPassword/forgot_password_controller.dart';
import 'package:bitful_cryto_wallet/themes/colors.dart';
import 'package:bitful_cryto_wallet/themes/common_style.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class ForgotPassPage extends GetView<ForgotPassController> {
  var controller = Get.put(ForgotPassController());
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: MyColors.SteelPink),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            tr("forgotPassword"),
            style: TextStyle(fontSize: 25),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Obx(() => Container(
                height: Get.height,
                width: Get.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: Get.height * 0.4,
                        width: Get.width,
                        child: Image(
                            image: AssetImage("assets/images/security.png"))),
                    SizedBox(
                      height: 20,
                    ),
                    AnimatedToggle(
                      values: [tr("email"), tr("phoneNumber")],
                      onToggleCallback: (value) {
                        controller.isEmail = !controller.isEmail;
                      },
                      width: Get.width * 0.8,
                    ),
                    Container(
                      width: Get.width * 0.9,
                      child: controller.isEmail
                          ? Column(
                              children: [
                                TextFormField(
                                  controller: _controller,
                                  keyboardType: TextInputType.emailAddress,
                                  onFieldSubmitted: (value) => {},
                                  decoration: CommonStyle.textFieldStyle(
                                      hintTextStr: "email"),
                                ),
                                SizedBox(
                                  height: 22,
                                )
                              ],
                            )
                          : IntlPhoneField(
                              controller: _controller,
                              keyboardType: TextInputType.phone,
                              onSubmitted: (value) => {},
                              decoration: CommonStyle.textFieldStyle(
                                  hintTextStr: "phoneNumber"),
                              initialCountryCode: 'VN',
                            ),
                    ),
                    Container(
                      height: Get.width * 0.12,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          MyColors.SteelPink,
                          MyColors.MajorelleBlue
                        ]),
                        borderRadius:
                            BorderRadius.all(Radius.circular(Get.width * 0.1)),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          print(_controller.text);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(Get.width * 0.1)),
                          ),
                        ),
                        child: Text(
                          tr("sendOTP"),
                          style: TextStyle(color: MyColors.Platinum),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ));
  }
}
