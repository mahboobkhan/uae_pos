import 'package:abc_consultant/widgets/half_color_border.dart';
import 'package:abc_consultant/widgets/issue_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddCompanyProfile extends StatefulWidget {
  const AddCompanyProfile({super.key});

  @override
  State<AddCompanyProfile> createState() => _AddCompanyProfileState();
}

class _AddCompanyProfileState extends State<AddCompanyProfile> {
  DateTime selectedDateTime = DateTime.now();
  DateTime? _startTime;
  String? companyDropDownType;
  final List<String> companyTypeDropDown = ["Regular", "Walking"];

  Future<void> _selectDateTime() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      );
      if (time != null) {
        setState(() {
          selectedDateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Widget _buildDateTimeField({double? width, double? height}) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 60,
      child: GestureDetector(
        onTap: _selectDateTime,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: "Date and Time *",
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.purple),
            ),
            suffixIcon: const Icon(Icons.calendar_today, color: Colors.red),
          ),
          child: Text(
            DateFormat("dd-MM-yyyy - hh:mm a").format(selectedDateTime),
            style: const TextStyle(fontSize: 14, color: Colors.red),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    final String formattedDate = DateFormat(
      'yyyy-MM-dd',
    ).format(DateTime.now());

    return SingleChildScrollView(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            border: Border.all(color: Colors.red, width: height * 0.01),
          ),
          height: height * 0.9,
          width: width * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.02),
              Row(
                children: [
                  SizedBox(width: width * 0.02),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Company Profile",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: width * 0.015,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "ORN. 000001-0000001",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: width * 0.01,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: width * 0.01),
                  Column(
                    children: [
                      SizedBox(
                        height: height * 0.05,
                        width: width * 0.15,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red),
                          ),
                          child: Container(
                            color: Colors.green,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: const Text(
                                  "   Walking/Regular",
                                  style: TextStyle(color: Colors.white),
                                ),
                                value: companyDropDownType,
                                items:
                                    companyTypeDropDown.map((type) {
                                      return DropdownMenuItem<String>(
                                        value: type,
                                        child: Text(type),
                                      );
                                    }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    companyDropDownType = value;
                                  });
                                },
                                style: TextStyle(
                                  fontSize: height * 0.02,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: width * 0.01),
                  Text(
                    'Date: $formattedDate',
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
              // Rest of your dialog code remains exactly the same...
              // ... [All your existing dialog content here] ...
              SizedBox(height: height * 0.04),

              // 2nd Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: width * 0.05),
                  //!st Feild
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Company Name",
                        style: TextStyle(
                          fontSize: width * 0.008,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SmoothGradientBorderContainer(
                        child: TextField(
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          cursorHeight: height * 0.02,
                          decoration: const InputDecoration(
                            hintText: "Xyz",
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: Colors.red,
                              fontWeight: FontWeight.normal,
                            ),
                            contentPadding: EdgeInsets.only(
                              left: 8,
                              bottom: 15,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: width * 0.03),
                  //2nd Feild
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Trade License Number",
                        style: TextStyle(
                          fontSize: width * 0.008,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SmoothGradientBorderContainer(
                        child: TextField(
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          cursorHeight: height * 0.02,
                          decoration: const InputDecoration(
                            hintText: "1234",
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: Colors.red,
                              fontWeight: FontWeight.normal,
                            ),
                            contentPadding: EdgeInsets.only(
                              left: 8,
                              bottom: 15,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: width * 0.03),
                  //3rd feild
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Company Code",
                        style: TextStyle(
                          fontSize: width * 0.008,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SmoothGradientBorderContainer(
                        child: TextField(
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          cursorHeight: height * 0.02,
                          decoration: const InputDecoration(
                            hintText: "4567",
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: Colors.red,
                              fontWeight: FontWeight.normal,
                            ),
                            contentPadding: EdgeInsets.only(
                              left: 8,
                              bottom: 15,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: width * 0.03),
                  //4th  Feild
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Establishment Number",
                        style: TextStyle(
                          fontSize: width * 0.008,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SmoothGradientBorderContainer(
                        child: TextField(
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          cursorHeight: height * 0.02,
                          decoration: const InputDecoration(
                            hintText: "xxxxxxx",
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: Colors.red,
                              fontWeight: FontWeight.normal,
                            ),
                            contentPadding: EdgeInsets.only(
                              left: 8,
                              bottom: 15,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: width * 0.03),
                  //5th Feild
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Note Extra",
                        style: TextStyle(
                          fontSize: width * 0.008,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SmoothGradientBorderContainer(
                        child: TextField(
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          cursorHeight: height * 0.02,
                          decoration: const InputDecoration(
                            hintText: "",
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: Colors.red,
                              fontWeight: FontWeight.normal,
                            ),
                            contentPadding: EdgeInsets.only(
                              left: 8,
                              bottom: 15,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: height * 0.03),
              //3rd Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: width * 0.05),
                  //6th Feild
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email I'd",
                        style: TextStyle(
                          fontSize: width * 0.008,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SmoothGradientBorderContainer(
                        child: TextField(
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          cursorHeight: height * 0.02,
                          decoration: const InputDecoration(
                            hintText: "abc@xyz.com",
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: Colors.red,
                              fontWeight: FontWeight.normal,
                            ),
                            contentPadding: EdgeInsets.only(
                              left: 8,
                              bottom: 15,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: width * 0.03),
                  //7th Feild
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Contact Number",
                        style: TextStyle(
                          fontSize: width * 0.008,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SmoothGradientBorderContainer(
                        child: TextField(
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          cursorHeight: height * 0.02,
                          decoration: const InputDecoration(
                            hintText: "+971",
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: Colors.red,
                              fontWeight: FontWeight.normal,
                            ),
                            contentPadding: EdgeInsets.only(
                              left: 8,
                              bottom: 15,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: width * 0.03),
                  //8th feild
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Contact Number -2",
                        style: TextStyle(
                          fontSize: width * 0.008,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SmoothGradientBorderContainer(
                        child: TextField(
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          cursorHeight: height * 0.02,
                          decoration: const InputDecoration(
                            hintText: "+971",
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: Colors.red,
                              fontWeight: FontWeight.normal,
                            ),
                            contentPadding: EdgeInsets.only(
                              left: 8,
                              bottom: 15,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: width * 0.03),
                  //9th  Feild
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Physical Address",
                        style: TextStyle(
                          fontSize: width * 0.008,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SmoothGradientBorderContainer(
                        width: width * 0.33,
                        child: TextField(
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          cursorHeight: height * 0.02,
                          decoration: const InputDecoration(
                            hintText:
                                "Address(House Street)    Town    City    Postal Code    Country",
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              fontWeight: FontWeight.normal,
                            ),
                            contentPadding: EdgeInsets.only(
                              left: 8,
                              bottom: 15,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: width * 0.03),
                ],
              ),

              //4th Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: width * 0.05),
                  //10th Feild
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.05),
                      Text(
                        "E- Channel Name (Website Link)",
                        style: TextStyle(
                          fontSize: width * 0.008,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SmoothGradientBorderContainer(
                        child: TextField(
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          cursorHeight: height * 0.02,
                          decoration: const InputDecoration(
                            hintText: "S.E.C.P",
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: Colors.red,
                              fontWeight: FontWeight.normal,
                            ),
                            contentPadding: EdgeInsets.only(
                              left: 8,
                              bottom: 15,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: width * 0.03),
                  //11th Feild
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.05),
                      Text(
                        "E-Channel Login i'd",
                        style: TextStyle(
                          fontSize: width * 0.008,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SmoothGradientBorderContainer(
                        child: TextField(
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          cursorHeight: height * 0.02,
                          decoration: const InputDecoration(
                            hintText: "abc@xyz.com",
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: Colors.red,
                              fontWeight: FontWeight.normal,
                            ),
                            contentPadding: EdgeInsets.only(
                              left: 8,
                              bottom: 15,
                            ),
                            border: InputBorder.none,
                            fillColor: Colors.transparent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: width * 0.03),
                  //12th feild
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.05),
                      Text(
                        "E- Channel Login Password",
                        style: TextStyle(
                          fontSize: width * 0.008,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SmoothGradientBorderContainer(
                        child: TextField(
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          cursorHeight: height * 0.02,
                          decoration: const InputDecoration(
                            hintText: "xxxxxxxxxx",
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: Colors.red,
                              fontWeight: FontWeight.normal,
                            ),
                            contentPadding: EdgeInsets.only(
                              left: 8,
                              bottom: 15,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: width * 0.03),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.060),
                      Text(
                        "Issue Date Notification",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SmoothGradientBorderContainer(
                        height: height * 0.03,
                        width: width * 0.1,
                        child: IssueDatePicker(
                          onDateTimeSelected: (dateTime) {
                            _startTime = dateTime;
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showAddCompanyProfileDialogue(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: AddCompanyProfile(), // Embed your widget here
      );
    },
  );
}
