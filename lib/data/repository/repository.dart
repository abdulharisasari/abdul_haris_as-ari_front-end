import 'package:dio/dio.dart';
import 'package:productfeflutter/data/models/category_model.dart';
import '../models/bulk_delete_model.dart';
import '../models/product_model.dart';
import '../providers/api_provider.dart';

class ProductRepository {
  final ApiProvider apiProvider;

  ProductRepository(this.apiProvider);

 
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await apiProvider.dio.get("/barang");
      print("Dio error response: ${response.toString()}"); 
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return ProductModel.fromList(data);
      } else {
        throw Exception("Gagal mengambil data barang (code: ${response.statusCode})");
      }
    } on DioException catch (e) {
      throw Exception(
          e.response?.data["message"] ?? "Gagal ambil data barang (code: ${e.response?.statusCode})");
    }
  }

  Future<List<CategoryModel>> getCategories() async{
    try {
      final response = await apiProvider.dio.get("/kategori");
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return CategoryModel.fromList(data);
      }else{
        throw Exception("Gagal mengambil kategori (code: ${response.statusCode})");
      }
    } on DioException catch (e) {
      throw Exception(
          e.response?.data["message"] ?? "Gagal ambil data kategori (code: ${e.response?.statusCode})");
    }
  }

  Future<ProductModel> createProduct(ProductModel product) async {
    try {
      final response = await apiProvider.dio.post("/barang", data: product.toJson());
      print("DEBUG createProduct: status=${response.statusCode}, data=${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null && response.data['data'] != null) {
          return ProductModel.fromJson(response.data['data']);
        } else {
          return ProductModel();
        }
      } else {
        throw Exception("Gagal membuat barang (code: ${response.statusCode})");
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data["message"] ??
          "Gagal membuat barang (code: ${e.response?.statusCode})");
    }
  }

 Future<ProductModel?> editProduct(EditProductRequest product, int id) async {
  try {
    final data = product.toJson();
    final response = await apiProvider.dio.put(
      "/barang/$id",
      data: data,
    );
    if (response.statusCode == 200 || response.statusCode ==201) {
      if (response.data != null && response.data['data'] != null) {
        return ProductModel.fromJson(response.data['data']);
      } else {
        return null;
      }
    } else {
      throw Exception("Gagal mengubah barang (code: ${response.statusCode})");
    }
    } on DioException catch (e) {
      final message = e.response?.data["message"] ?? "Gagal mengubah barang (code: ${e.response?.statusCode})";
      throw Exception(message);
    }
  }

  Future<void> bulkDelete(List<int> ids) async {
    try {
      final request = BulkDeleteRequest(ids: ids);
      final response = await apiProvider.dio.post(
        "/barang/bulk-delete",
        data: request.toJson(),
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception("Gagal menghapus barang (code: ${response.statusCode})");
      }
    } on DioException catch (e) {
      throw Exception( e.response?.data["message"] ?? "Gagal menghapus barang (code: ${e.response?.statusCode})");
    }
  }
}
