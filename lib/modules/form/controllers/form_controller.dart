import 'package:get/get.dart';
import 'package:productfeflutter/routes/app_routes.dart';

import '../../../data/models/category_model.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repository/repository.dart';

class FormController extends GetxController {
  final ProductRepository repository;
  var isLoading = false.obs;
  var isCategoryLoading = false.obs;

  var categories = <CategoryModel>[].obs;
  var selectedCategory = Rxn<CategoryModel>();


  FormController(this.repository);


  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isCategoryLoading.value = true;
      final data = await repository.getCategories();
      categories.assignAll(data);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isCategoryLoading.value = false;
    }
  }



  Future<void> createProduct(ProductModel product) async {
    try {
      isLoading.value = true;
      await repository.createProduct(product);
      Get.offAllNamed(Routes.HOME);
      Get.snackbar("Sukses", "Produk berhasil ditambahkan!");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> editProduct(EditProductRequest product, int id) async {
  try {
    isLoading.value = true;
   
    await repository.editProduct(product, id);

    Get.offAllNamed(Routes.HOME);
    Get.snackbar("Sukses", "Produk berhasil diubah!");
  } catch (e) {
    Get.snackbar("Error", e.toString());
  } finally {
    isLoading.value = false;
  }
}

}
