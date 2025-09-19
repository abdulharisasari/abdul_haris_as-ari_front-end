import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'data/providers/api_provider.dart';
import 'data/repository/repository.dart';
import 'modules/form/controllers/form_controller.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

void main() {
  Get.put(ApiProvider());
  Get.put(ProductRepository(Get.find<ApiProvider>()));
  Get.put(FormController(Get.find<ProductRepository>()));

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.HOME,
      getPages: AppPages.routes,
    ),
  );
}
