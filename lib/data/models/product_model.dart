import 'category_model.dart';

class ProductModel {
  int? id;
  int? categoryId;
  int? stok;
  String? name;
  String? categoryName;
  int? price;
  CategoryModel? categoryListModel;


  ProductModel({this.id, this.name, this.categoryId, this.stok, this.categoryName, this.price, this.categoryListModel});


  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['nama_barang'],
      categoryId: json['kategori_id'],
      stok: json['stok'],
      categoryName: json['kelompok_barang'],
      price: json['harga'],
      categoryListModel: json['kategori'] != null
          ? CategoryModel.fromJson(json['kategori'])
          : null,
    );
  }

  static List<ProductModel> fromList(List list) {
    return list.map((e) => ProductModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_barang': name,
      'kategori_id': categoryId,
      'stok': stok,
      'kelompok_barang': categoryName,
      'harga': price,
      'kategori': categoryListModel?.toJson(), 
    };
  }
}


class EditProductRequest {
  final String name;
  final int categoryId;
  final int stok;
  final int price;

  EditProductRequest({
    required this.name,
    required this.categoryId,
    required this.stok,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'nama_barang': name,
      'kategori_id': categoryId,
      'stok': stok,
      'harga': price,
    };

    map.removeWhere((key, value) => value == null);
    return map;
  }
}
