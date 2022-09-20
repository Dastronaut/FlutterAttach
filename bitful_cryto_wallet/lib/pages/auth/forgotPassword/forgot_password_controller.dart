import 'package:get/get.dart';

class ForgotPassController extends GetxController {
  final _isEmail = true.obs;
  get isEmail => this._isEmail.value;
  set isEmail(value) => this._isEmail.value = value;
}
