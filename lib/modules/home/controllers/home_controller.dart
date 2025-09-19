import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../../data/providers/api_provider.dart';
import '../../../data/repository/repository.dart';

class HomeController extends GetxController {
  final ProductRepository repository = ProductRepository(ApiProvider());

  var isLoading = false.obs;
  var products = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      final result = await repository.getProducts();
      products.assignAll(result);
    } catch (e) {
      Get.snackbar("Error", e.toString());
     print("Eror: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> bulkDeleteProducts(List<int> ids) async {
    if (ids.isEmpty) return;
    try {
      isLoading.value = true;
      await repository.bulkDelete(ids);
      Get.snackbar("Sukses", "${ids.length} barang berhasil dihapus");
      await fetchProducts(); 
    } catch (e) {
      Get.snackbar("Error", e.toString());
      print("Error bulkDeleteProducts: $e");
    } finally {
      isLoading.value = false;
    }
  }
}