import 'package:abc_consultant/widgets/half_color_border.dart';
import 'package:abc_consultant/widgets/issue_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddIndividualProfile extends StatefulWidget {
  const AddIndividualProfile({super.key});

  @override
  State<AddIndividualProfile> createState() => _AddIndividualProfileState();
}

class _AddIndividualProfileState extends State<AddIndividualProfile> {
  DateTime selectedDateTime = DateTime.now();
  DateTime? _startTime;
  DateTime? _endTime;
  DateTime? _partnerStartTime;
  DateTime? _partnerEndTime;
  String? companyDropDownType;
  final List<String> companyTypeDropDown = ["Regular", "Walking"];
  String? partnerType;
  String? partnerPosition;
  final List<String> partnerTypeDropDown = [
    "Partner",
    "Employee",
    "Other Records",
  ];
  final List<String> partnerPositionDropDown = ["Dropdown", "Save"];

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

    return Scaffold(
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              border: Border.all(color: Colors.red, width: height * 0.01),
            ),
            height: height * .70,
            width: width * .95,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(width: width * 0.02),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Individual Profile Profile",
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
                SizedBox(height: height * 0.03),
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
                          "Emirate I'd",
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
                    //4th  Feild
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
                    //5th Feild
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Contact Number - 2",
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

                //**
                //ADD SPACE
                //
                //
                //
                // */
                SizedBox(height: height * 0.02),
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
                //**ADD SPACE HERE
                //
                //
                // */
                SizedBox(height: height * 0.02),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: width * 0.05),
                    //Note Extra Feild
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Note/Extra",
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
                //**ADD SPACE HERE
                //
                //
                // */
                SizedBox(height: height * 0.02),
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
                          "Advance Payment TiD",
                          style: TextStyle(
                            fontSize: width * 0.008,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SmoothGradientBorderContainer(
                          width: width * 0.10,
                          color: Colors.green,
                          child: TextField(
                            style: TextStyle(
                              fontSize: 10,

                              fontWeight: FontWeight.bold,
                            ),
                            cursorHeight: height * 0.02,
                            decoration: InputDecoration(
                              hintText: "xxxxxx",
                              hintStyle: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
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
                //**ADD SPACE HERE
                //
                //
                // */
                SizedBox(height: height * 0.02),
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
                          "Pending Payment TiD",
                          style: TextStyle(
                            fontSize: width * 0.008,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SmoothGradientBorderContainer(
                          color: Colors.green,
                          child: TextField(
                            style: TextStyle(
                              fontSize: 10,

                              fontWeight: FontWeight.bold,
                            ),
                            cursorHeight: height * 0.02,
                            decoration: InputDecoration(
                              hintText: "10000",
                              hintStyle: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
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
                    SizedBox(width: width * 0.05),
                    //6th Feild
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Advance Payment TiD",
                          style: TextStyle(
                            fontSize: width * 0.008,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SmoothGradientBorderContainer(
                          color: Colors.green,
                          child: TextField(
                            style: TextStyle(
                              fontSize: 10,

                              fontWeight: FontWeight.bold,
                            ),
                            cursorHeight: height * 0.02,
                            decoration: InputDecoration(
                              hintText: "xxxxxx",
                              hintStyle: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
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
                        SizedBox(height: height * 0.015),
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
                              _partnerStartTime = dateTime;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: width * 0.03),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: height * 0.015),
                        Text(
                          "Expiry Date Notification",
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
                              _partnerEndTime = dateTime;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: width * 0.02),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: height * 0.034),
                        //tick icon
                        Icon(
                          Icons.check,
                          color: Colors.green.shade800,
                          size: width * 0.02,
                        ),
                      ],
                    ),
                    SizedBox(width: width * 0.005),
                    //upload button
                    Column(
                      children: [
                        SizedBox(height: height * 0.026),
                        MaterialButton(
                          onPressed: () {},
                          color: Colors.green.shade800,
                          height: height * 0.06,
                          minWidth: width * 0.08,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                            children: [
                              Text(
                                "Upload File",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: width * 0.007,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.white,
                                ),
                              ),
                              Icon(
                                Icons.upload_file,
                                size: 14,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                //**ADD SPACE HERE
                //
                //
                // */
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: width * 0.05),
                    Text(
                      "Projects",
                      style: TextStyle(
                        color: Colors.purple.shade600,
                        fontSize: width * 0.008,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                //**ADD SPACE HERE
                //
                //
                // */
                SizedBox(height: height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: width * 0.05),
                    MaterialButton(
                      minWidth: width * 0.09,
                      onPressed: () {},
                      color: Colors.blue.shade900,
                      child: Text(
                        "Editing",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          fontSize: width * 0.01,
                        ),
                      ),
                    ),
                    SizedBox(width: width * 0.02),
                    MaterialButton(
                      minWidth: width * 0.09,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: Colors.red,
                      child: Text(
                        "Submit",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          fontSize: width * 0.01,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void showAddIndividualProfileDialogue(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: AddIndividualProfile(), // Embed your widget here
      );
    },
  );
}

Widget _buildDropdown(
  String? selectedValue,
  String hintText,
  List<String> items,
  ValueChanged<String?> onChanged, {
  Icon icon = const Icon(Icons.arrow_drop_down),
}) {
  return Padding(
    padding: const EdgeInsets.only(left: 12),
    child: CustomPaint(
      painter: SmoothGradientBorderPainter(), // ⬅️ Your custom border painter
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          0,
        ), // ⬅️ Match the painter's border radius
        child: Container(
          width: 140,
          height: 25,
          color: Colors.white, // ⬅️ White background inside border
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue,
              icon: icon,
              hint: Text(hintText, style: const TextStyle(color: Colors.black)),
              style: const TextStyle(fontSize: 10),
              onChanged: onChanged,
              isExpanded: true,
              items:
                  items.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ),
      ),
    ),
  );
}
