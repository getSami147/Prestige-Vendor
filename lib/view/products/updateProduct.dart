import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prestige_vender/models/getCatagriesModel.dart';
import 'package:prestige_vender/models/subcatagoryByCatagoryModel.dart';
import 'package:prestige_vender/utils/Images.dart';
import 'package:prestige_vender/utils/colors.dart';
import 'package:prestige_vender/utils/constant.dart';
import 'package:prestige_vender/utils/string.dart';
import 'package:prestige_vender/utils/widget.dart';
import 'package:prestige_vender/viewModel/homeViewModel.dart';
import 'package:prestige_vender/viewModel/userViewModel.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

// UpdateProductScreen Component
class UpdateProductScreen extends StatefulWidget {
  final Map<String, dynamic> prouctData;
  UpdateProductScreen({required this.prouctData, Key? key}) : super(key: key);

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  final formkey = GlobalKey<FormState>();
  final productNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final int maxLines = 5;
  final locationController = TextEditingController();

  String? categoryId = '';
  String? subCategoryId = '';
  String? images =
      'https://cdn.dribbble.com/users/3512533/screenshots/14168376/web_1280___8_4x.jpg';

  @override
  void initState() {
      // TODO: implement initState
    super.initState();
    var userViewModel = Provider.of<UserViewModel>(context, listen: false);
    userViewModel.selectedCatagory = null;
    userViewModel.productImage=null;
    initializeControllers();

  
  }
  
@override
  void dispose() {
    super.dispose();
    productNameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
   
    // TODO: implement dispose
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: text("Update Product", fontWeight: FontWeight.bold),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildProductImage(context),
              buildTextFormField(
                label: "Product Name",
                controller: productNameController,
                hintText: "Enter the product name",
              ),
              buildTextFormField(
                label: product_price,
                controller: priceController,
                hintText: product_price,
                keyboardType: TextInputType.phone,
              ),
              text(
                "Category",
                fontSize: textSizeSMedium,
              ).paddingTop(spacing_middle),
              _buildCategoryDropdown(context).paddingTop(spacing_middle),
              const SizedBox(height: spacing_middle),
              buildTextFormField(
                  label: product_description,
                  controller: descriptionController,
                  hintText: product_description,
                  maxLines: maxLines,
                  maxLength: 100),
              buildFeatureCheckbox(),
              buildUpdateButton(context),
            ],
          ).paddingSymmetric(horizontal: spacing_standard_new),
        ),
      ),
    );
  }

  void initializeControllers() {
    productNameController.text = widget.prouctData["name"].toString();
    descriptionController.text = widget.prouctData["description"].toString();
    priceController.text = widget.prouctData["price"].toString();
    if (widget.prouctData["images"].isNotEmpty) {
      images = widget.prouctData["images"][0] ??
          'https://cdn.dribbble.com/users/3512533/screenshots/14168376/web_1280___8_4x.jpg';
    }
    categoryId = widget.prouctData["category"];
    subCategoryId = widget.prouctData["subCategory"];
  }

  Widget buildProductImage(BuildContext context) {
    return Consumer<UserViewModel>(builder: (context, c, child) {
      return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onTap: () {
              c.getProductImage();
            },
            child: SizedBox(
              height: MediaQuery.of(context).size.width * 0.45,
              width: MediaQuery.of(context).size.width,
              child: c.productImage == null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(images!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(
                                placeholderProduct,
                                fit: BoxFit.cover,
                              )))
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.file(
                        c.productImage!,
                        fit: BoxFit.cover,
                      )),
            ),
          ),
          GestureDetector(
            onTap: () {
              c.getProductImage();
            },
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                border: Border.all(color: white, width: 2),
                shape: BoxShape.circle,
                color: transparentColor,
              ),
              child: const Center(
                child: Icon(
                  Icons.camera_alt,
                  color: white,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget buildTextFormField({
    required String label,
    required TextEditingController controller,
    String? hintText,
    TextInputType keyboardType = TextInputType.text,
    int? maxLines,
    int? maxLength,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text(
          label,
          fontSize: textSizeSMedium,
        ).paddingTop(spacing_standard_new),
        CustomTextFormField(
          context,
          fontSize: textSizeSMedium,
          controller: controller,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $label';
            }
            return null;
          },
          obscureText: false,
          hintText: hintText,
          keyboardType: keyboardType,
          maxLines: maxLines,
          maxLength: maxLength,
        ).paddingTop(spacing_middle),
      ],
    );
  }

  Widget _buildCategoryDropdown(BuildContext context) {
    return FutureBuilder<GetAllCatagriesModel>(
      future: HomeViewModel().getAllCatagires(context),
      builder:
          (BuildContext context, AsyncSnapshot<GetAllCatagriesModel> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerDropdown("Choose category");
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        } else {
          return StatefulBuilder(
            builder: (context, changeState) {
              return Consumer<UserViewModel>(
                builder: (context, userViewModel, child) {
                  if (snapshot.data != null) {
                    for (var category in snapshot.data!.data!) {
                      if (category.id == categoryId) {
                        userViewModel.selectedCatagory = category.title!;
                        // print(userViewModel.selectedCatagory);
                        // print(userViewModel.selectedCatagory);
                        break;
                      }
                    }
                  }
                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            // color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 24,
                                  offset: const Offset(0, 4),
                                  spreadRadius: 0,
                                  color:
                                      const Color(0xff000000).withOpacity(.1))
                            ]),
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            fillColor: white,
                            filled: true,
                            border: InputBorder.none,
                          ),
                          borderRadius: BorderRadius.circular(15),
                          isExpanded: true,
                          hint: text(
                            userViewModel.selectedCatagory ??
                                "Select the category",
                            fontSize: textSizeSMedium,
                            color: black,
                          ),
                          items: snapshot.data!.data!
                              .map<DropdownMenuItem<String>>((e) {
                            return DropdownMenuItem(
                              onTap: () {
                                changeState(() {
                                  categoryId = e.id.toString();
                                });
                              },
                              value: e.title.toString(),
                              child: text(e.title.toString()),
                            );
                          }).toList(),
                          validator: (value) {
                            if (userViewModel.selectedCatagory == null) {
                              return 'Please select the category';
                            }
                            return null;
                          },
                          onChanged: (val) {
                            userViewModel.selectedSubsCatagory = null;

                            userViewModel.setSelectedCatagory(val!);
                          },
                        ),
                      ),
                      _buildSubCategoryDropdown(context),
                    ],
                  );
                },
              );
            },
          );
        }
      },
    );
  }

  Widget _buildSubCategoryDropdown(BuildContext context) {
    if (categoryId.toString().isEmpty) {
      return const SizedBox();
    }

    return FutureBuilder<GetSubCatByCatagoryModel>(
      future:
          HomeViewModel().getSubCatByCatagory(categoryId.toString(), context),
      builder: (BuildContext context,
          AsyncSnapshot<GetSubCatByCatagoryModel> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerDropdown("Choose sub-category");
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        } else if (snapshot.data!.data!.isEmpty) {
          return text(
            "No sub-categories found against the category",
            fontSize: textSizeSMedium,
            color: redColor,
          ).paddingTop(spacing_middle);
        } else {
          return StatefulBuilder(
            builder: (context, changeState) {
              return Consumer<UserViewModel>(
                builder: (context, userViewModel, child) {
                  for (var subcategory in snapshot.data!.data!) {
                    if (subcategory.id == subCategoryId) {
                      userViewModel.selectedSubsCatagory = subcategory.title!;
                      // print(userViewModel.selectedSubsCatagory);
                      // print(userViewModel.selectedSubsCatagory);
                      break;
                    }
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text(
                        "Sub Category",
                        fontSize: textSizeSMedium,
                      ).paddingTop(spacing_middle),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 24,
                                  offset: const Offset(0, 4),
                                  spreadRadius: 0,
                                  color:
                                      const Color(0xff000000).withOpacity(.1))
                            ]),
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          isExpanded: true,
                          borderRadius: BorderRadius.circular(10),
                          hint: text(
                            userViewModel.selectedSubsCatagory ??
                                "Select the sub-categories",
                            fontSize: textSizeSMedium,
                            color: black,
                          ).paddingLeft(10),
                          items: snapshot.data!.data!
                              .map<DropdownMenuItem<String>>((e) {
                            return DropdownMenuItem(
                              onTap: () {
                                changeState(() {
                                  subCategoryId = e.id;
                                });
                              },
                              value: e.title.toString(),
                              child: text(e.title.toString(),
                                  fontSize: textSizeSMedium),
                            );
                          }).toList(),
                          validator: (value) {
                            if (userViewModel.selectedSubsCatagory == null) {
                              return 'Please select the sub-category';
                            }
                            return null;
                          },
                          onChanged: (val) {
                            userViewModel.setSelectedSubsCatagory(val!);
                          },
                        ),
                      ),
                    ],
                  );
                },
              ).paddingTop(spacing_middle);
            },
          );
        }
      },
    );
  }

  Widget _buildShimmerDropdown(String hint) {
    return Shimmer.fromColors(
      baseColor: colorPrimary,
      highlightColor: colorPrimary2,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: spacing_middle),
        height: 50,
        width: double.infinity,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            hint: text(hint, fontSize: textSizeMedium, color: black),
            items: const [],
            onChanged: (value) {},
          ),
        ),
      ),
    ).paddingTop(spacing_middle);
  }

  Widget buildFeatureCheckbox() {
    return Consumer<UserViewModel>(
      builder: (context, checkboxModel, _) {
        return Row(
          children: [
            Checkbox(
              value: checkboxModel.isCheckedFutureProduct,
              onChanged: (bool? value) {
                checkboxModel.toggleisCheckedFutureProduct(value!);
              },
            ),
            text(
              feature,
              fontSize: textSizeSMedium,
            )
          ],
        ).paddingBottom(15.0);
      },
    );
  }

  Widget buildUpdateButton(BuildContext context) {
    return elevatedButton(
      context,
      child: text(
        "Update Product",
        fontWeight: FontWeight.bold,
        color: white,
        fontSize: textSizeMedium,
      ),
      onPress: () {
        if (formkey.currentState!.validate()) {
          Map<String, String> data = {
            'name': productNameController.text.trim(),
            'description': descriptionController.text.trim(),
            'category': categoryId.toString(),
            'subCategory': subCategoryId!,
            'price': priceController.text.trim(),
            'featureProduct': Provider.of<UserViewModel>(context, listen: false)
                .isCheckedFutureProduct
                .toString(),
          };
          HomeViewModel().updateProductAPI(
              data, widget.prouctData["_id"].toString(), context);
        }
      },
    ).paddingBottom(20.0);
  }
}
