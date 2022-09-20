import 'package:bitful_cryto_wallet/components/switch_button.dart';
import 'package:bitful_cryto_wallet/pages/auth/register/register_controller.dart';
import 'package:bitful_cryto_wallet/themes/colors.dart';
import 'package:bitful_cryto_wallet/themes/common_style.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class RegisterPage extends GetWidget<RegisterController> {
  var controller = Get.put(RegisterController());
  TextEditingController _emailInput = TextEditingController();
  TextEditingController _phoneInput = TextEditingController();
  TextEditingController _password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: MyColors.SteelPink),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            tr("register"),
            style: TextStyle(fontSize: 25),
          ),
          centerTitle: true,
        ),
        body: Obx(
          () => Container(
            height: Get.height,
            width: Get.width,
            child: Column(children: [
              AnimatedToggle(
                values: [tr("email"), tr("phoneNumber")],
                onToggleCallback: (value) {
                  controller.isEmail = !controller.isEmail;
                },
                width: Get.width * 0.8,
              ),
              Container(
                height: Get.height * 0.6,
                width: Get.width * 0.9,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      controller.isEmail
                          ? TextFormField(
                              controller: _emailInput,
                              keyboardType: TextInputType.emailAddress,
                              onFieldSubmitted: (value) => {},
                              decoration: CommonStyle.textFieldStyle(
                                  hintTextStr: "email"),
                            )
                          : IntlPhoneField(
                              controller: _phoneInput,
                              keyboardType: TextInputType.phone,
                              onSubmitted: (value) => {},
                              decoration: CommonStyle.textFieldStyle(
                                  hintTextStr: "phoneNumber"),
                              initialCountryCode: 'VN',
                            ),
                      TextFormField(
                        controller: _password,
                        keyboardType: TextInputType.text,
                        onFieldSubmitted: (value) => {},
                        obscureText: !controller.isVisibility,
                        decoration:
                            CommonStyle.textFieldStyle(hintTextStr: "password")
                                .copyWith(
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          controller.isVisibility =
                                              !controller.isVisibility;
                                        },
                                        icon: controller.isVisibility
                                            ? Icon(Icons.visibility_off)
                                            : Icon(Icons.visibility))),
                      ),
                      Container(
                        height: Get.width * 0.12,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            MyColors.SteelPink,
                            MyColors.MajorelleBlue
                          ]),
                          borderRadius: BorderRadius.all(
                              Radius.circular(Get.width * 0.1)),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            controller.handleRegister(
                                email: _emailInput.text,
                                passWord: _password.text);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(Get.width * 0.1)),
                            ),
                          ),
                          child: Text(
                            tr("register"),
                            style: TextStyle(color: MyColors.Platinum),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text(
                          tr("haveAccount"),
                          style:
                              TextStyle(decoration: TextDecoration.underline),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: Get.width * 0.1),
                        child: Divider(
                          height: 1.5,
                          color: MyColors.SteelPink.withOpacity(0.4),
                          thickness: 1.5,
                        ),
                      ),
                      Text(tr("orLogin")),
                      SizedBox(
                        width: Get.width * 0.7,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.g_mobiledata, size: 75)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.apple, size: 60)),
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.facebook, size: 55))
                          ],
                        ),
                      )
                    ]),
              )
            ]),
          ),
        ));
  }
}
