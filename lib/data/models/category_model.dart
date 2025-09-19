

class CategoryModel {
  int? id;
  String? nameCategory;

  CategoryModel({this.id, this.nameCategory});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      nameCategory: json['nama_kategori'],
    );
  }

  static List<CategoryModel> fromList(List list) {
    return list.map((e) => CategoryModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_kategori': nameCategory,
    };
  }
  
}


