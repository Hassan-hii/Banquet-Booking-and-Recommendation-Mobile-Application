import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:banquet/gen/assets.gen.dart';
import 'package:banquet/modules/banquet/controllers/banquet_dashboard_controller.dart';
import 'package:banquet/utils/constants.dart';
import 'package:banquet/utils/frequent_utils.dart';
import 'package:banquet/utils/validator.dart';
import 'package:banquet/widgets/custom_text_form_field_widget.dart';
import 'package:banquet/widgets/menu_section_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class BanquetProfileScreen extends StatefulWidget {
  const BanquetProfileScreen({super.key});

  @override
  State<BanquetProfileScreen> createState() => _BanquetProfileScreenState();
}

class _BanquetProfileScreenState extends State<BanquetProfileScreen> {
  final BanquetDashboardController _controller =
      Get.find<BanquetDashboardController>();

  // Initial Selected Value
  String selectedValue = 'Banquet';

  // List of items in our dropdown menu
  List<String> items = [
    'Banquet',
    'Marquee',
    'Hall',
    'Outdoor',
    'Others',
  ];

  File? _pickedImage;

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _pickedImage = File(pickedImage.path);
      });
    } else {
      print('No image selected.');
    }
  }

  @override
  void initState() {
    debugPrint('BanquetProfile initState');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('BanquetProfile build');
    return SingleChildScrollView(
      child: Obx(() {
        if (_controller.isBanquetFetching.isTrue) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.brown,
            ),
          );
        } else if (_controller.map.value.isNotEmpty) {
          return _banquetProfileDetails();
        }
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Form(
            key: _controller.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextFormFieldWidget(
                  controller: _controller.brand.value,
                  labelText: "Brand Name",
                  textCapitalization: TextCapitalization.words,
                  validator: Validator.checkStringIsNotEmpty,
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Venue type', // Add a label for the dropdown
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  value: selectedValue,
                  isExpanded: true,
                  validator: Validator.checkStringIsNotEmpty,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue = newValue!;
                    });
                    _controller.setVenueType = newValue!;
                  },
                  items: items.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(value),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                CustomTextFormFieldWidget(
                  controller: _controller.personCapacity.value,
                  labelText: "Person Capacity",
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  maxLength: 4,
                  validator: Validator.checkParkingCapacity,
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormFieldWidget(
                        controller: _controller.parkingCapacity.value,
                        labelText: "Parking Capacity",
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        maxLength: 4,
                        validator: Validator.checkParkingCapacity,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: CustomTextFormFieldWidget(
                        controller: _controller.bPrice.value,
                        labelText: "Booking Price",
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        maxLength: 6,
                        validator: Validator.checkBookingPrice,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                CustomTextFormFieldWidget(
                  controller: _controller.facilities.value,
                  labelText: "Facilites",
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                  validator: Validator.checkStringIsNotEmpty,
                ),
                SizedBox(height: 20),
                CustomTextFormFieldWidget(
                  controller: _controller.location.value,
                  labelText: "Location",
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  validator: Validator.checkStringIsNotEmpty,
                ),
                SizedBox(height: 20),
                CustomTextFormFieldWidget(
                  controller: _controller.description.value,
                  labelText: "Description",
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: null,
                  validator: Validator.checkStringIsNotEmpty,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _pickImageFromGallery,
                  child: Text('Pick Image'),
                ),
                SizedBox(height: 20),
                if (_pickedImage != null)
                  Flexible(
                    child: Container(
                      width: Get.width,
                      height: 150,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: Image.file(
                        _pickedImage!,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  )
                else
                  Text('No image selected'),
                SizedBox(height: 20),
                SizedBox(
                  width: Get.width,
                  height: 50,
                  child: Obx(
                    () => ElevatedButton(
                      onPressed: () {
                        if (_pickedImage == null) {
                          FrequentUtils.getFailureSnackBar(
                              'Alert', 'Please select banquet image');
                          return;
                        }
                        if ((_controller.formKey.currentState?.validate())!) {
                          _controller.setPickedImage = _pickedImage!;
                          _controller.addBanquet();
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.brown),
                        // padding: EdgeInsets.all(10),
                      ),
                      child: _controller.isLoading.value
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              'Add Banquet',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _banquetProfileDetails() {
    return Column(
      children: [
        Container(
          width: Get.width,
          height: Get.height * 0.3,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: MemoryImage(
                Uint8List.fromList(
                    base64Decode(_controller.banquetModel.image)),
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text('Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _customTile(
                      image: Assets.images.type.image(),
                      title: "Type",
                      subTitle: _controller.banquetModel.venueType),
                  _customTile(
                      image: Assets.images.parking.image(),
                      title: "Parking",
                      subTitle: _controller.banquetModel.parkingCapacity),
                  _customTile(
                      image: Assets.images.capacity.image(),
                      title: "Capacity",
                      subTitle: _controller.banquetModel.personCapacity),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: _customTile(
                        image: Assets.images.priceTag.image(),
                        title: "Booking Price",
                        subTitle: _controller.banquetModel.bookingPrice),
                  ),
                  Expanded(
                    child: _customTile(
                        image: null,
                        title: "Facilities",
                        subTitle: _controller.banquetModel.facilities),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // TODO: Menu list should be added here
              if (_controller.menus.isEmpty)
                noWidget
              else
                ListView.builder(
                    itemCount: _controller.menus.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final menu = _controller.menus[index];
                      return Card(
                        child: ExpansionTile(
                          title: Text(menu.pkgName ?? '', style: TextStyle(fontWeight: FontWeight.bold),),
                          subtitle: Text('Rs ${menu.menuPrice}/- per person' ?? ''),
                          maintainState: true,
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          childrenPadding: EdgeInsets.symmetric(horizontal: 20),
                          shape: const Border(),
                          initiallyExpanded: true,
                          children: [
                            Column(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MenuSectionWidget(
                                    image: Assets.images.mainCourse
                                        .image(height: 14),
                                    title: 'Main Course',
                                    subTitle: menu.mainCourse ?? ''),
                                MenuSectionWidget(
                                    image:
                                        Assets.images.dessert.image(height: 14),
                                    title: 'Desserts',
                                    subTitle: menu.desserts ?? ''),
                                MenuSectionWidget(
                                    image:
                                        Assets.images.drinks.image(height: 14),
                                    title: 'Drinks',
                                    subTitle: menu.drinks ?? ''),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await _displayTextInputDialog(context);
                  },
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Add Menu',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _customTile(
      {Image? image, required String title, required String subTitle}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (image != null) SizedBox(height: 20, child: image),
            const SizedBox(width: 15),
            Text(title,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 10),
        Text(subTitle,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent)),
      ],
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            title: Text(
              'Please add your menu',
              textAlign: TextAlign.center,
            ),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: SizedBox(
              width: Get.width * 0.9,
              child: Form(
                key: _controller.menuKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextFormFieldWidget(
                            controller: _controller.pkgName.value,
                            labelText: "Package Name",
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            validator: Validator.checkStringIsNotEmpty,
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: CustomTextFormFieldWidget(
                            controller: _controller.pkgPrice.value,
                            labelText: "Price",
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            maxLength: 4,
                            validator: Validator.checkMenuPrice,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    CustomTextFormFieldWidget(
                      controller: _controller.mainCourse.value,
                      labelText: "Main Course",
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: null,
                      validator: Validator.checkStringIsNotEmpty,
                    ),
                    SizedBox(height: 20),
                    CustomTextFormFieldWidget(
                      controller: _controller.desserts.value,
                      labelText: "Desserts",
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: null,
                      validator: Validator.checkStringIsNotEmpty,
                    ),
                    SizedBox(height: 20),
                    CustomTextFormFieldWidget(
                      controller: _controller.drinks.value,
                      labelText: "Drinks",
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: null,
                      validator: Validator.checkStringIsNotEmpty,
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('Cancel'),
                shape: OutlineInputBorder(),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Obx(() {
                return MaterialButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  child: _controller.isLoading.value
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text('Add'),
                  shape: OutlineInputBorder(),
                  onPressed: _controller.isLoading.value
                      ? null
                      : () {
                          if (_controller.menuKey.currentState!.validate()) {
                            _controller.addMenuToBanquet();
                          }
                        },
                );
              }),
            ],
          );
        });
  }
}
