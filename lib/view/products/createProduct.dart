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

class CreateProduct extends StatefulWidget {
  final String shopId;
  const CreateProduct({required this.shopId, Key? key}) : super(key: key);

  @override
  State<CreateProduct> createState() => _CreateProductState();
}

class _CreateProductState extends State<CreateProduct> {
  final formkey = GlobalKey<FormState>();
  final productNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();

  String? categoryId = '';
  String? subCategoryId = '';
  
  @override
  void initState() {
    var userViewModel=Provider.of<UserViewModel>(context,listen: false);
    userViewModel.selectedCatagory = null;
    userViewModel.productImage=null;

    print("InitSate");
    // TODO: implement initState
    super.initState();
  }
 @override
  void dispose() {
    productNameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: text(listing_product, fontWeight: FontWeight.bold),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: formkey,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: spacing_standard_new),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ProductImagePicker(),
                const SizedBox(height: spacing_standard_new),
                buildTextFormField(
                  context: context,
                  controller: productNameController,
                  label: "Product Name",
                  hint: "Enter the product name",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: spacing_middle),
                buildTextFormField(
                  context: context,
                  controller: priceController,
                  label: product_price,
                  hint: product_price,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: spacing_middle),
                text(
                  "Category",
                                      fontSize: textSizeSMedium,

                ).paddingTop(spacing_middle),
                _buildCategoryDropdown(context).paddingTop(spacing_middle),
                const SizedBox(height: spacing_middle),
                buildTextFormField(
                  context: context,
                  controller: descriptionController,
                  label: product_description,
                  hint: product_description,
                  maxLines: 5,
                  maxLength: 100,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please write a description here';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: spacing_middle),
                _buildFeatureCheckbox(),
                const SizedBox(height: spacing_middle),
                _buildUploadButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextFormField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    int maxLines = 1,
    int? maxLength,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text(
          label,
                     fontSize: textSizeSMedium,

        ).paddingTop(spacing_middle),
        CustomTextFormField(
          context,
          controller: controller,
          validator: validator,
          obscureText: obscureText,
          hintText: hint,
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
          return StatefulBuilder(builder: (context, changeState) {
            return    Consumer<UserViewModel>(
            builder: (context, userViewModel, child) {
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
                              color: const Color(0xff000000).withOpacity(.1))
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
                        userViewModel.selectedCatagory ?? "Select the category",
                        fontSize: textSizeSMedium,
                        color: black,
                      ),
                      items:
                          snapshot.data!.data!.map<DropdownMenuItem<String>>((e) {
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
                       userViewModel.selectedSubsCatagory=null;

                        userViewModel.setSelectedCatagory(val!);
                      },
                    ),
                  ),
                _buildSubCategoryDropdown(context),
               
                ],
              );
            },
          );
       
          },);
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
          return StatefulBuilder(builder: (context, changeState) {
            return  Consumer<UserViewModel>(
            builder: (context, userViewModel, child) {
              return Column(crossAxisAlignment: CrossAxisAlignment.start,
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
                              color: const Color(0xff000000).withOpacity(.1))
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
                      items: snapshot.data!.data!.map<DropdownMenuItem<String>>((e) {
                        return DropdownMenuItem(
                          onTap: () {
                            changeState(() {
                              subCategoryId = e.id;
                            });
                          },
                          value: e.title.toString(),
                          child: text(e.title.toString(),fontSize: textSizeSMedium),
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
       
          },);
          
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

  Widget _buildFeatureCheckbox() {
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
            ),
          ],
        ).paddingBottom(15.0);
      },
    );
  }

  Widget _buildUploadButton(BuildContext context) {
    return elevatedButton(
      context,
      child: text(
        "Upload",
        fontWeight: FontWeight.bold,
        color: white,
        fontSize: textSizeMedium,
      ),
      onPress: () {
        var userViewModel = Provider.of<UserViewModel>(context, listen: false);
        if (userViewModel.productImage == null) {
          utils().flushBar(context, "Pick the Product Image");
        } else if (formkey.currentState!.validate()) {
          Map<String, String> data = {
            'name': productNameController.text.trim(),
            'description': descriptionController.text.trim(),
            'category': categoryId!,
            'subCategory': subCategoryId!,
            'shopId': widget.shopId,
            'price': priceController.text.trim(),
            'featureProduct': userViewModel.isCheckedFutureProduct.toString(),
            'position': '1',
          };
          HomeViewModel().createProductsAPI(data, context);
        }
      },
    ).paddingBottom(20.0);
  }
}

class ProductImagePicker extends StatelessWidget {
  const ProductImagePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (context, userViewModel, child) {
        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            GestureDetector(
              onTap: () {
                userViewModel.getProductImage();
              },
              child: SizedBox(
                height: MediaQuery.of(context).size.width * 0.45,
                width: MediaQuery.of(context).size.width,
                child: userViewModel.productImage == null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          store,
                          fit: BoxFit.cover,
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.file(
                          userViewModel.productImage!,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
            GestureDetector(
              onTap: () {
                userViewModel.getProductImage();
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
      },
    );
  }
}
