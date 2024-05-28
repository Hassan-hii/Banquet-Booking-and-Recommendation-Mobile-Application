import 'dart:convert';
import 'dart:typed_data';
import 'package:banquet/enum/day.dart';
import 'package:banquet/modules/customer/controller/search_banquet_controller.dart';
import 'package:banquet/utils/constants.dart';
import 'package:banquet/utils/validator.dart';
import 'package:banquet/widgets/custom_text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class BanquetBookingRequestScreen2 extends StatelessWidget {
  BanquetBookingRequestScreen2({super.key});

  final _controller = Get.find<SearchAndBookBanquetController>();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Continue Banquet Booking'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: Get.width,
              height: Get.height * 0.3,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: MemoryImage(
                    Uint8List.fromList(
                        base64Decode(_controller.getSelectedBanquet.image)),
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text('Select Date',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 20),
                  Obx((){
                      return Column(
                        children: [
                          TableCalendar(
                            firstDay: kFirstDay,
                            lastDay: kLastDay,
                            currentDay: DateTime.now(),
                            focusedDay: _controller.focusedDay.value,
                            calendarFormat: CalendarFormat.twoWeeks,
                            selectedDayPredicate: (day) {
                              return isSameDay(_controller.getSelectedDay, day);
                            },
                            onDaySelected: (selectedDay, focusedDay) {
                              _controller.setSelectedDay = selectedDay;
                              _controller.focusedDay.value = focusedDay;
                            },
                            onPageChanged: (focusedDay) {
                              _controller.focusedDay.value = focusedDay;
                            },
                          ),
                          SizedBox(height: 10),
                        ],
                      );
                    }
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: DropdownMenu<Day>(
                          controller: _controller.partOfTheDayController,
                          requestFocusOnTap: false,
                          leadingIcon: const Icon(Icons.search),
                          label: const Text('Shift'),
                          inputDecorationTheme: const InputDecorationTheme(
                            filled: true,
                          ),
                          onSelected: (Day? day) {
                            _controller.selectedPartOfTheDay.value = day!;
                          },
                          dropdownMenuEntries:
                          Day.values.map<DropdownMenuEntry<Day>>(
                                (Day day) {
                              return DropdownMenuEntry<Day>(
                                value: day,
                                label: (day.partOfTheDay),
                                leadingIcon: Icon(day.icon),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                      SizedBox(width: 40),
                      Flexible(
                        child: Form(
                          key: _formKey,
                          child: CustomTextFormFieldWidget(
                            controller: _controller.guestController,
                            labelText: "No. of Guest",
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            maxLength: 4,
                            validator: (val){
                              int guestsAllowed = int.parse(_controller.getSelectedBanquet.personCapacity);
                              int value = int.parse(val!);
                              if(value > guestsAllowed){
                                return 'No capacity';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  CustomTextFormFieldWidget(
                    controller: _controller.addNotesController,
                    labelText: "Add Notes:",
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: null,
                    // validator: Validator.checkStringIsNotEmpty,
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Obx(() {
                          return ElevatedButton(
                            onPressed: _controller.isLoading.value ? null : () {
                              if(_formKey.currentState!.validate()){
                                _controller.addBooking();
                              }
                            },
                            child: _controller.isLoading.value ? CircularProgressIndicator(
                              color: Colors.white,
                            ): Text('Continue Booking'),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(primaryColor),
                            ),
                          );
                        }
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
