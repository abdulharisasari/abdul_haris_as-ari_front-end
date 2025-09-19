import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:productfeflutter/core/assets.dart';
import 'package:productfeflutter/core/themes.dart';
import 'package:productfeflutter/core/utils.dart';
import '../../../data/models/product_model.dart';
import '../controllers/home_controller.dart';
import '../../../routes/app_routes.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController controller = Get.find();

  TextEditingController _searchController = TextEditingController();
  FocusNode _searchFN = FocusNode();

  bool _isEditMode = false;
  bool isSearching = false;

  int _viewBottom = 0;
  Set<int> _selectedIds = {};
  List<ProductModel> _allProducts = [];
  List<ProductModel> products = [];

  @override
  void initState() {
    super.initState();
    _getProduct();
  }

  Future<void> _getProduct() async{
    try {
      await controller.fetchProducts();
      final productController = controller.products;
      if (productController.isNotEmpty) {
        setState(() {
          products = productController;
          _allProducts = products;
        });
      }else{
        setState(() {
          products = [];
        });
      }
    } catch (e) {
      print("catch _getProduct : $e"); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: ()async {
       await _getProduct();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                   setState(() {
                     isSearching = false;
                     _searchController.clear();
                   });
                },
                child: Icon(Icons.arrow_back)),
                Expanded(
                child: isSearching
                    ? Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(color: Color(bgSecondaryColor), borderRadius: BorderRadius.all(Radius.circular(100))),
                        child: TextField(
                          controller: _searchController,
                          autofocus: true,
                          focusNode: _searchFN,
                          onTapOutside: (event) => _searchFN.unfocus(),
                          style: TextStyle(fontSize: 12),
                          decoration: InputDecoration(
                              hintText: " Cari barang...",
                              border: InputBorder.none,
                              prefixIcon: Image.asset(
                                icSearch,
                                height: 16,
                                width: 16,
                                fit: BoxFit.cover),
                              prefixIconConstraints: BoxConstraints(minWidth: 16, minHeight: 16)),
                          onChanged: (value) {
                            setState(() {
                              if (value.isEmpty) {
                                isSearching = false;
                                products = _allProducts;
                              } else {
                                isSearching = true;
                                products = _allProducts
                                    .where((p) => (p.name ?? "")
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                    .toList();
                              }
                            });
                          }

                        ),
                      )
                    : Center(child: Text('List Stok Barang', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(fgPrimaryColor)))),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    if (isSearching) {
                      isSearching = false;
                      _searchController.clear();
                      products = _allProducts;
                    } else {
                      isSearching = true;
                    }
                  });
                },
                child: !isSearching ? Image.asset( icSearch, height: 24, width: 24) : Container(),
              ),
            ],
          ),
        ),
        body: Container(
          height: double.infinity,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  height: MediaQuery.of(context).size.height - 120 - 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "20 Data ditampilkan",
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400,
                              color: Color(fgSecondaryColor),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isEditMode = !_isEditMode;
                                if (!_isEditMode) _selectedIds.clear();
                              });
                            },
                            child: Text(
                              "Edit Data",
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: Color(infoColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Expanded(
                        child: ListView.separated(
                          itemCount: products.length + 1,
                          padding: EdgeInsets.zero,
                          separatorBuilder: (context, index) => SizedBox(height: 16.0),
                          itemBuilder: (context, index) {
                            if (index < products.length) {
                              final product = products[index];
                              return InkWell(
                                  onTap: () {
                                    if (!_isEditMode) {
                                      _showProductDetail(context, product);
                                    }
                                  },
                                  child: _builListItem(
                                    product: product,
                                    isEditMode: _isEditMode,
                                    isSelected: _selectedIds.contains(product.id),
                                    onCheckboxChanged: (value) {
                                      setState(() {
                                        if (value == true) {
                                          _selectedIds.add(product.id!);
                                        } else {
                                          _selectedIds.remove(product.id);
                                        }
                                      });
                                    },
                                  ));
                            } else {
                              return  Container(child:isSearching?_buildRefresh(): _buildLoadData());
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Container(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _isEditMode
                              ? _buildSelectAllCheckbox()
                              : _viewBottom == 1
                                  ? _buildTotalPrice()
                                  : _buildButtonPlus(),
                        ],
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadData() {
    return InkWell(
     onTap: () {
       setState(() {
         _viewBottom = _viewBottom == 0 ? 1 : 0;
       });
     },
     child: Container(
       height: 50,
       alignment: Alignment.center,
       child: Row(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           Icon(Icons.arrow_upward, size: 16, color: Color(fgSecondaryColor)),
           SizedBox(width: 4),
           Text(
             "Tarik untuk memuat data lainnya",
             style: TextStyle(
               fontSize: 12,
               fontWeight: FontWeight.w400,
               color: Color(fgSecondaryColor),
             ),
           ),
         ],
       ),
     ),
   );
  }

  Widget _buildRefresh() {
    return InkWell(
     onTap: ()async {
      await _getProduct();
     },
     child: Container(
       height: 50,
       alignment: Alignment.center,
       child: Row(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           Image.asset(icRefresh, height: 16, width: 16, color: Color(infoColor)),
           SizedBox(width: 4),
           Text(
             "Refresh untuk melihat data lainnya",
             style: TextStyle(
               fontSize: 12,
               fontWeight: FontWeight.w400,
               color: Color(infoColor),
             ),
           ),
         ],
       ),
     ),
   );
  }

  Widget _buildTotalPrice() {
      int totalHarga = products
      .map((e) => e.price ?? 0) // pastikan null aman
      .reduce((value, element) => value + element);
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Total Stok",
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
              Text(
                "${products.length}",
                style: TextStyle(
                  fontSize: 12.0,
                ),
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Total Harga",
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
              Text(
                "${Utils.formatCurrency(totalHarga)}",
                style: TextStyle(
                  fontSize: 12.0,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSelectAllCheckbox() {
    bool allSelected = _selectedIds.length == products.length && products.isNotEmpty;
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Checkbox(
                value: allSelected,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      _selectedIds = products.map((p) => p.id!).toSet();
                    } else {
                      _selectedIds.clear();
                    }
                  });
                },
              ),
              Text("Pilih Semua"),
            ],
          ),
          _buildButtonDelete()
        ],
      ),
    );
  }

  _buildButtonDelete() {
  return GestureDetector(
    onTap: () async {
      if (_selectedIds.isEmpty) {
        Get.snackbar("Error", "Pilih barang yang ingin dihapus");
        return;
      }

      bool confirm = await Get.defaultDialog(
        title: "Konfirmasi",
        middleText: "Apakah yakin ingin menghapus ${_selectedIds.length} barang?",
        textConfirm: "Ya",
        textCancel: "Tidak",
        onConfirm: () => Get.back(result: true),
        onCancel: () => Get.back(result: false),
      ) ?? false;

      if (!confirm) return;

      await controller.bulkDeleteProducts(_selectedIds.toList());
      setState(() {
        _viewBottom = 0;
        _isEditMode = false;
        _selectedIds.clear();
      });
    },
    child: Container(
      height: 40,
      width: 160,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(width: 1.0, color: Colors.grey),
      ),
      alignment: Alignment.center,
      child: Text(
        "Hapus Barang",
        style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: Colors.red),
      ),
    ),
  );
}


  Widget _buildButtonEdit(ProductModel productModel) {
    return InkWell(
      onTap: () => Get.toNamed(Routes.FORM, arguments: productModel),
      child: Container(
        height: 40,
        width: 160,
        decoration: BoxDecoration(
          color: Color(primaryColor),
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(width: 1.0, color: Color(primaryColor)),
        ),
        alignment: Alignment.center,
        child: Text(
          "Edit Barang",
          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: Color(bgPrimaryColor)),
        ),
      ),
    );
  }

  Widget _builListItem({  required ProductModel product,  bool isEditMode = false,  bool isSelected = false,  Function(bool?)? onCheckboxChanged,}) {
    return Container(
      child: !isSearching
          ? Column(
              children: [
                Row(
                  children: [
                    if (isEditMode)
                      Checkbox(
                        value: isSelected,
                        onChanged: onCheckboxChanged,
                      ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.name ?? "-",
                           style: TextStyle(
                             fontSize: 16,
                             fontWeight: FontWeight.w500,
                             color: Color(fgPrimaryColor),
                           )),
                          SizedBox(height: 4),
                          Text("Kategori Id: ${product.categoryId ?? 0}",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(fgSecondaryColor)
                          )),
                          Text("Kelompok Barang: ${product.categoryName}",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(fgSecondaryColor)
                          )),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Stok: ${product.stok ?? 0}",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(fgSecondaryColor)
                        )),
                        SizedBox(height: 10),
                        Text("${Utils.formatCurrency(product.price??0)}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(fgPrimaryColor),
                            ))
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Divider(height: 1, color: Colors.grey),
              ],
            )
          : Column(
              children: [
                Row(
                  children: [
                    if (isEditMode)
                      Checkbox(
                        value: isSelected,
                        onChanged: onCheckboxChanged,
                      ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.name ?? "-",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(fgPrimaryColor),
                              )),
                          SizedBox(height: 4),
                          Text("Stok: ${product.stok ?? 0}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color(fgSecondaryColor))),
                        ],
                      ),
                    ),
                    Text("${Utils.formatCurrency(products.fold<int>(0, (sum, item) => sum + (item.price ?? 0)),)}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(fgPrimaryColor),
                        )),
                  ],
                ),
                SizedBox(height: 16),
                Divider(height: 1, color: Colors.grey),
              ],
            ),
    );
  }

  Widget _buildButtonPlus() {
    return Container(
      width: 135,
      height: 48,
      child: ElevatedButton(
        onPressed: () => Get.toNamed(Routes.FORM),
        style: ElevatedButton.styleFrom(backgroundColor: Color(primaryColor), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
        child: Row(
          children: [
            Icon(
              Icons.add,
              size: 32,
              color: Colors.white,
            ),
            Text(
              'Barang',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProductDetail(BuildContext context, ProductModel product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          width: double.infinity,
          height: 690,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 6,
                decoration: BoxDecoration(
                  color: Color(borderPrimaryColor),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 10),
              Image.asset(imgIsEmpty, height: 320, width: double.infinity, fit: BoxFit.cover),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(border: Border.all(width: 1.0, color: Color(borderPrimaryColor)), borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.only(top: 16, right: 16, left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldDetail("Nama Barang", "${product.name ?? "-"}"),
                    SizedBox(height: 8),
                    _fieldDetail("Kategori", "${product.categoryListModel?.nameCategory ?? 0}"),
                    SizedBox(height: 8),
                    _fieldDetail("Kelompok", "${product.categoryName ?? 0}"),
                    SizedBox(height: 8),
                    _fieldDetail("Stok", "${product.stok ?? 0}", isBorder: false),
                    SizedBox(height: 8),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(bgSecondaryColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _fieldDetail("Harga", "${Utils.formatCurrency(product.price??0)}", isBorder: false, colorValue: fgPrimaryColor)),
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildButtonDelete(),
                  SizedBox(width: 8),
                  _buildButtonEdit(product),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _fieldDetail(String label, String value, {bool isBorder = true, int? colorValue}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(fgPrimaryColor))),
            Text(
              value,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: colorValue != null ? Color(colorValue) : Color(fgSecondaryColor)),
            )
          ],
        ),
        SizedBox(height: 8),
        if (isBorder) Divider(height: 1, color: Color(borderPrimaryColor))
      ],
    );
  }
}

