import 'package:bitful_cryto_wallet/pages/auth/login/login_page.dart';
import 'package:bitful_cryto_wallet/pages/dashboard/dashboard_binding.dart';
import 'package:bitful_cryto_wallet/pages/dashboard/dashboard_page.dart';
import 'package:get/get.dart';
part './app_routes.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
        name: Routes.DASHBOARD,
        page: () => DashboardPage(),
        binding: DashboardBinding()),
    GetPage(name: Routes.LOGIN, page: () => LoginPage()),
  ];
}
