import 'package:bitful_cryto_wallet/components/modal_confirm.dart';
import 'package:bitful_cryto_wallet/components/modal_loading.dart';
import 'package:bitful_cryto_wallet/pages/auth/register/register_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final RxBool _isVisibility = false.obs;
  final RxBool _isEmail = true.obs;
  final RxBool _isSuccess = false.obs;

  final _msgError = ''.obs;
  get msgError => this._msgError.value;
  set msgError(value) => this._msgError.value = value;

  get isSuccess => this._isSuccess.value;
  set isSuccess(value) => this._isSuccess.value = value;

  get isEmail => this._isEmail.value;
  set isEmail(value) => this._isEmail.value = value;

  set isVisibility(value) => this._isVisibility.value = value;
  get isVisibility => this._isVisibility.value;

  void handleRegister({required String email, required String passWord}) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (email.isEmpty || email.toString().trim().isEmpty) {
      _msgError.value =
          tr("msgRequired", namedArgs: {"attribute": tr("email")});
      showModal();
    } else if (!emailValid) {
      _msgError.value = tr("msgFormatEmail");
      showModal();
    } else if (passWord.isEmpty || passWord.toString().trim().isEmpty) {
      _msgError.value =
          tr("msgRequired", namedArgs: {"attribute": tr("password")});
      showModal();
    } else if (passWord.length < 8) {
      _msgError.value =
          tr("msgMin", namedArgs: {"attribute": tr("password"), "min": "8"});
      showModal();
    } else {
      try {
        showModalLoading();
        RegisterProvider()
            .registerbyEmail(email: email, passWord: passWord)
            .then((status) => {
                  if (status == 'success')
                    {
                      isSuccess = true,
                      _msgError.value = tr("msgRegisterSuccess"),
                      showModal()
                    }
                  else
                    {_msgError.value = tr(status), showModal()},
                  // Get.to(() => LoginPage())
                });
      } catch (e) {
        print(e);
      }
    }
  }

  void showModal() {
    var modalConfirm = ModalConfirm(
      message: _msgError.value,
      confirm: false,
      onCancel: () =>
          isSuccess.value == true ? goBack() : _msgError.value == "",
      onConfirm: () => goBack(),
    );
    showDialog(
        context: Get.context!, builder: (BuildContext context) => modalConfirm);
  }

  void showModalLoading() {
    var modalLoading = ModalLoading();
    showDialog(
        context: Get.context!, builder: (BuildContext context) => modalLoading);
  }

  void goBack() {
    Get.back();
    _msgError.value = "";
  }
}
