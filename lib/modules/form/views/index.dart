import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:productfeflutter/core/themes.dart';

import '../../../data/models/category_model.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repository/repository.dart';
import '../controllers/form_controller.dart';

class FormProductPage extends StatefulWidget {
  @override
  State<FormProductPage> createState() => _FormProductPageState();
}

class _FormProductPageState extends State<FormProductPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameTC = TextEditingController();
  final TextEditingController _categoryIdTC = TextEditingController();
  final TextEditingController _grouCategoryTC = TextEditingController();
  final TextEditingController _stockTC = TextEditingController();
  final TextEditingController _priceTC = TextEditingController();

  final FocusNode _nameFN = FocusNode();
  final FocusNode _catagoryFN = FocusNode();
  final FocusNode _groupFN = FocusNode();
  final FocusNode _stockFN = FocusNode();
  final FocusNode _priceFN = FocusNode();
  final FormController controller = Get.find();

  bool _isLoading = false, isLoadingCategory = false;

  List<CategoryModel> categoryList = [];
  CategoryModel? selectedCategory;
  ProductModel? productModel;
  final product = Get.arguments as ProductModel?;



  @override
  void initState() {
    _init();
    _fetchCategories();
    super.initState();
  }

  void _init() {

    setState(() {
      productModel = product;
      _nameTC.text = "${product?.name ?? ''}";
      _categoryIdTC.text = "${productModel?.categoryId ?? ''}";
      _grouCategoryTC.text = "${productModel?.categoryName ?? ''}";
      _stockTC.text = "${product?.stok ?? ''}";
      _priceTC.text = "${product?.price ?? ''}";
    });
  }

  void _fetchCategories() async {
    try {
      final data = await Get.find<ProductRepository>().getCategories();
      setState(() {
        categoryList = data;

        // Jika sedang edit, otomatis pilih category dari productModel
        if (productModel != null && productModel!.categoryId != null) {
          selectedCategory = categoryList.firstWhere(
            (c) => c.id == productModel!.categoryId,
            orElse: () => CategoryModel(),
          );

          if (selectedCategory != null) {
            _categoryIdTC.text = "${selectedCategory!.id}";
          }
        }
        isLoadingCategory = false;
      });
    } catch (e) {
      setState(() {
        isLoadingCategory = false;
      });
      Get.snackbar("Error", "Gagal ambil kategori: $e");
    }
  }

  Future<void> _saveProduct() async {
    setState(() {
      _isLoading = true;
    });
    print("sssssssssssssssssssssssssssss");
    try {
     final product = ProductModel(
          name: _nameTC.text,
          categoryId: int.tryParse(_categoryIdTC.text),
          categoryName: _categoryIdTC.text,
          stok: int.tryParse(_stockTC.text),
          price: int.tryParse(_priceTC.text),
        );
        await controller.createProduct(product);
    } catch (e) {
      debugPrint("catch _saveProduct: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  

  @override
  void dispose() {
    _nameTC.dispose();
    _categoryIdTC.dispose();
    _grouCategoryTC.dispose();
    _stockTC.dispose();
    _priceTC.dispose();
    _nameFN.dispose();
    _catagoryFN.dispose();
    _groupFN.dispose();
    _stockFN.dispose();
    _priceFN.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Barang')),
      body: Expanded(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SingleChildScrollView(
                  controller: ScrollController(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(label: "Nama Barang", type: TextInputType.text, controller: _nameTC, focusNode: _nameFN),
                      _buildTextField(label: "Kategori Barang", type: TextInputType.text, controller: _categoryIdTC, focusNode: _catagoryFN, read: true),
                      _buildCategoryDropdown(categories: categoryList, selectedCategory: selectedCategory),
                      _buildTextField(label: "Stok", type: TextInputType.number, controller: _stockTC, focusNode: _stockFN),
                      _buildTextField(label: "Harga", type: TextInputType.number, controller: _priceTC, focusNode: _priceFN),
                    ],
                  ),
                ),
                Spacer(),
               if(product?.id !=null) _buildButtonEdit(),
               if(product?.id == null) _buildButtonAdd()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown({required List<CategoryModel> categories, required CategoryModel? selectedCategory}) {
    if (categories.isEmpty) {
      return const CircularProgressIndicator();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Kelompok Barang *",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(fgPrimaryColor),
            fontSize: 14,
          ),
        ),
        SizedBox(height: 5),
        Container(
          height: 50,
          child: DropdownButtonFormField<CategoryModel>(
            value: selectedCategory,
            items: categories.map((c) {
              return DropdownMenuItem<CategoryModel>(
                value: c,
                child: Text(c.nameCategory ?? ""),
              );
            }).toList(),
            padding: EdgeInsets.zero,
            onChanged: (val) {
              setState(() {
                selectedCategory = val;
                _categoryIdTC.text = "${selectedCategory?.id}";
              });
            },
            isDense: true,
            decoration: const InputDecoration(hintText: "Masukan Kelompok Barang", border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 16)),
            validator: (val) => val == null ? "Kategori wajib dipilih" : null,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({required String label, required TextInputType type, required TextEditingController controller, required FocusNode focusNode, bool? read}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label *",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(fgPrimaryColor),
              fontSize: 14,
            ),
          ),
          SizedBox(height: 5),
          FormField<String>(
            validator: (value) {
              if (controller.text.trim().isEmpty) {
                return "$label Belum diisi";
              }
              return null;
            },
            builder: (FormFieldState<String> field) {
              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      readOnly: read != null ? read : false,
                      controller: controller,
                      focusNode: focusNode,
                      onTapOutside: (event) => focusNode.unfocus(),
                      keyboardType: type,
                      onChanged: (val) {
                        field.validate();
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        hintText: "Masukan $label",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: field.hasError ? Colors.red : Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: field.hasError ? Colors.red : Colors.grey),
                        ),
                      ),
                    ),
                    if (field.hasError) ...[
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.error, color: Colors.red, size: 18),
                          SizedBox(width: 6),
                          Text(
                            field.errorText!,
                            style: TextStyle(color: Colors.red, fontSize: 13),
                          ),
                        ],
                      )
                    ]
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildButtonAdd() {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton(
        onPressed:() async {
                if (_formKey.currentState!.validate()) {
                   _saveProduct();
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: _isLoading ? Color(bgSecondaryColor) : Color(primaryColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        ),
        child: Text(
          'Tambah Barang',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: _isLoading ? Color(fgTertiaryColor) : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildButtonEdit() {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton(
        onPressed: _isLoading
            ? null
            : () async {
                if (_formKey.currentState!.validate()) {
                    final productEdit = EditProductRequest(
                    name: _nameTC.text,
                    categoryId: int.tryParse(_categoryIdTC.text)!,
                    price: int.tryParse(_priceTC.text)!,
                    stok: int.tryParse(_stockTC.text)!
                  );
                  await controller.editProduct(productEdit, productModel!.id!);
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: _isLoading ? Color(bgSecondaryColor) : Color(primaryColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        ),
        child: Text(
          'Edit Barang',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: _isLoading ? Color(fgTertiaryColor) : Colors.white,
          ),
        ),
      ),
    );
  }
}
