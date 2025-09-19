import 'package:get/get.dart';
import '../modules/form/bindings/form_binding.dart';
import '../modules/form/views/index.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/index.dart';
import 'app_routes.dart';


class AppPages {
  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.FORM,
      page: () => FormProductPage(),
      binding: FormProductBinding(),
    ),
  ];
}