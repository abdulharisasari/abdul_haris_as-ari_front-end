import 'package:get/get.dart';

import '../../../data/repository/repository.dart';
import '../controllers/form_controller.dart';

class FormProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FormController(Get.find<ProductRepository>()));
  }
}

