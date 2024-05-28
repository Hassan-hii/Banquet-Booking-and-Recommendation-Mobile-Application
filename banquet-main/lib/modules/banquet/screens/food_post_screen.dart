
import 'package:banquet/enum/user_type.dart';
import 'package:banquet/modules/banquet/controllers/food_controller.dart';
import 'package:banquet/modules/banquet/models/food_model.dart';
import 'package:banquet/utils/constants.dart';
import 'package:banquet/utils/validator.dart';
import 'package:banquet/widgets/custom_drawer_widget.dart';
import 'package:banquet/widgets/custom_text_form_field_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class FoodPostScreen extends StatelessWidget {
  FoodPostScreen({super.key});

  final FoodController _controller = Get.put(FoodController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Food Posts'),
        centerTitle: true,
      ),
      drawer: const CustomDrawerWidget(userType: UserType.banquetOwner),
      body: SingleChildScrollView(
        child: Obx((){
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                children: [
                  Form(
                    key: _controller.formKey,
                    child: Column(
                      children: [
                        CustomTextFormFieldWidget(
                          controller: _controller.foodName.value,
                          labelText: "Food Name",
                          textCapitalization: TextCapitalization.words,
                          validator: Validator.checkStringIsNotEmpty,
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(height: 20),
                        CustomTextFormFieldWidget(
                          controller: _controller.foodDetails.value,
                          labelText: "Food Details",
                          textCapitalization: TextCapitalization.sentences,
                          validator: Validator.checkStringIsNotEmpty,
                          maxLines: null,
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          width: Get.width,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              if ((_controller.formKey.currentState?.validate())!) {
                                _controller.addFood();
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(primaryColor),
                              // padding: EdgeInsets.all(10),
                            ),
                            child:  _controller.isLoading.value
                                ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                                :
                                Text(
                              'Post Food',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Divider(),
                  SizedBox(height: 20),
                  ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _controller.children.length,
                    itemBuilder: (context, index){
                      return _listItem(_controller.children[index]);
                    },
                  ),
                ],
              ),
            );
          }
        ),
      ),
    );
  }

  Widget _listItem(FoodModel model){
    return Container(
      height: 100,
      width: Get.width,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.brown.shade50,
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              width: 160,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(model.foodName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  SizedBox(height: 2),
                  Text(model.foodDetails, maxLines: 5,
                    softWrap: true, overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, height: 1),),
                ],
              ),
            ),
          ),
          SizedBox(width: 10),
          SizedBox(
            width: 40,
            child: Text(model.foodDate,maxLines: 3,
            softWrap: true, textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
        ],
      ),
    );
  }
}
