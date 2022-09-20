import 'package:get/get.dart';

class LoginController extends GetxController {
  final RxBool _isVisibility = false.obs;

  final _isEmail = true.obs;
  get isEmail => this._isEmail.value;
  set isEmail(value) => this._isEmail.value = value;

  set isVisibility(value) => this._isVisibility.value = value;
  get isVisibility => this._isVisibility.value;
}
