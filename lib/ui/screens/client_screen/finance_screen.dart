import 'package:abc_consultant/ui/screens/client_screen/add_individual_profile.dart';
import 'package:abc_consultant/ui/screens/client_screen/add_comapny_profile.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  String? customerValue;
  String? serviceProjectValue;
  String? paymentValue;
  String? dateValue;
  String? profileAddCategory;

  final List<String> customerType = ["All", "Company", "Individual"];
  final List<String> servicesProjects = [
    "All",
    "Passport",
    "Visa Renewal",
    "E ID Renewal",
  ];
  final List<String> paymentStatus = ["Pending", "Paid"];
  final List<String> dates = [
    "All",
    "Today",
    "Yesterday",
    "Last 7 days",
    "Last Month",
    "Select an Calender",
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ---- Stats Boxes ----
                const SizedBox(height: 20),

                /// ---- Filters Row ----
                Container(
                  height: 45,
                  width: size.width,
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Row(
                    children: [
                      _buildDropdown(
                        customerValue,
                        "Individual Type",
                        customerType,
                        (newValue) {
                          setState(() {
                            customerValue = newValue!;
                          });
                        },
                      ),
                      _buildDropdown(
                        serviceProjectValue,
                        "Services/Project",
                        servicesProjects,
                        (newValue) {
                          setState(() {
                            serviceProjectValue = newValue!;
                          });
                        },
                      ),
                      _buildDropdown(
                        paymentValue,
                        "Payment Status",
                        paymentStatus,
                        (newValue) {
                          setState(() {
                            paymentValue = newValue!;
                          });
                        },
                      ),
                      _buildDropdown(
                        dateValue,
                        "Dates",
                        dates,
                        (newValue) {
                          setState(() {
                            dateValue = newValue!;
                          });
                        },
                        icon: const Icon(Icons.calendar_month, size: 18),
                      ),
                      SizedBox(width: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.11,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: Colors.red, width: 1.5),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: const TextField(
                              style: TextStyle(fontSize: 12),
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                hintText: 'Search...',
                                hintStyle: TextStyle(fontSize: 12),
                                border: InputBorder.none,
                                isCollapsed: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),

                      // /// ---- Profile Add Menu ----
                      // PopupMenuButton<String>(
                      //   onSelected: (String newValue) {
                      //     setState(() {
                      //       profileAddCategory = newValue;
                      //     });
                      //     if (newValue == 'Company') {
                      //       showAddCompanyProfileDialogue(context);
                      //     } else {
                      //       showAddIndividualProfileDialogue(context);
                      //     }
                      //   },
                      //   itemBuilder:
                      //       (BuildContext context) => <PopupMenuEntry<String>>[
                      //         const PopupMenuItem<String>(
                      //           value: 'Company',
                      //           child: Text('Add Company Profile'),
                      //         ),
                      //         const PopupMenuItem<String>(
                      //           value: 'Individual',
                      //           child: Text('Add Individual'),
                      //         ),
                      //       ],
                      //   child: Container(
                      //     width: 35,
                      //     height: 35,
                      //     margin: const EdgeInsets.symmetric(horizontal: 10),
                      //     decoration: const BoxDecoration(
                      //       color: Colors.red,
                      //       shape: BoxShape.circle,
                      //     ),
                      //     child: const Center(
                      //       child: Icon(
                      //         Icons.add,
                      //         color: Colors.white,
                      //         size: 20,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      const Icon(Icons.edit_outlined, color: Colors.green),
                      const SizedBox(width: 20),
                    ],
                  ),
                ),

                /// ---- Table Data ----
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Table(
                      border: TableBorder.all(color: Colors.white),
                      defaultVerticalAlignment: TableCellVerticalAlignment.top,
                      columnWidths: const {
                        0: IntrinsicColumnWidth(),
                        1: IntrinsicColumnWidth(),
                        2: IntrinsicColumnWidth(),
                        3: IntrinsicColumnWidth(),
                        4: IntrinsicColumnWidth(),
                        5: IntrinsicColumnWidth(),
                        6: IntrinsicColumnWidth(),
                        7: IntrinsicColumnWidth(),
                        8: IntrinsicColumnWidth(),
                      },
                      children: [
                        /// Client Header Row
                        TableRow(
                          decoration: const BoxDecoration(
                            color: Color(0xFFEDEDED),
                          ),
                          children: [
                            _buildHeader("Date"),
                            _buildHeader("Clients Name"),
                            _buildHeader("Type"),
                            _buildHeader("Payment Mode"),
                            _buildHeader("Expanses"),
                            _buildHeader("Advance"),
                            _buildHeader("Pending"),
                            _buildHeader("Total"),
                            _buildHeader("Other Actions/Tag"),
                          ],
                        ),

                        /// Sample Client Data Row
                        TableRow(
                          children: [
                            _buildCell("12/02/2025\n02:59pm", context: context),
                            _buildCell(
                              "Client Imran",
                              context: context,
                              copyable: true,
                            ),
                            _buildCell(
                              context: context,
                              "Company",
                              color: Colors.purple,
                            ),
                            _buildCell(
                              "Multiple",
                              context: context,
                              copyable: false,
                            ),
                            _buildCell("1000", context: context),
                            _buildCell("300", context: context),
                            _buildCell("N/A", context: context),
                            _buildCell("1400", context: context),
                            _buildCell(
                              "N/A - Projects List",
                              context: context,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
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
    child: Container(
      width: 140,
      height: 25,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          icon: icon,
          hint: Text(hintText, style: TextStyle(color: Colors.black)),

          style: TextStyle(fontSize: 10),
          onChanged: onChanged,
          items:
              items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Container(
                    padding: EdgeInsets.zero,
                    child: Text(value, style: TextStyle(color: Colors.red)),
                  ),
                );
              }).toList(),
        ),
      ),
    ),
  );
}

Widget _buildHeader(String text) {
  return Container(
    height: 50, // 👈 Set your desired header height here
    alignment: Alignment.center,
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.red,
        fontSize: 12,
      ),
      textAlign: TextAlign.start,
    ),
  );
}

Widget _buildCell(
  String text, {
  Color color = Colors.black,
  bool copyable = false,
  required BuildContext context,
}) {
  return Container(
    alignment: Alignment.topLeft,
    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
    margin: const EdgeInsets.only(right: 8.0),
    child: Row(
      mainAxisSize: MainAxisSize.min, // <-- very important!
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text.replaceAll('\n', ' '), // remove newlines to force straight line
          style: TextStyle(fontSize: 13, color: color),
          softWrap: false,
        ),
        if (copyable)
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: text));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Copied to clipboard')),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Icon(
                Icons.copy,
                size: 16,
                color: const Color.fromARGB(255, 46, 43, 43),
              ),
            ),
          ),
      ],
    ),
  );
}

Widget _buildTagsCell(List<String> tags) {
  final colors = [Colors.purple, Colors.green, Colors.blue];

  return Container(
    alignment: Alignment.topLeft,
    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
    margin: const EdgeInsets.only(right: 8.0), // for column spacing
    child: Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        for (int i = 0; i < tags.length; i++)
          Text(
            tags[i],
            style: TextStyle(color: colors[i % colors.length], fontSize: 13),
          ),
        const Icon(Icons.add, size: 16, color: Colors.red),
      ],
    ),
  );
}

Widget _buildPriceWithAdd(String price) {
  return Container(
    alignment: Alignment.topLeft,
    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
    margin: const EdgeInsets.only(right: 8.0), // match column spacing
    child: Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween, // space between text and icon
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(price, style: const TextStyle(fontSize: 13, color: Colors.black)),
        const Icon(Icons.add, size: 16, color: Colors.red),
      ],
    ),
  );
}
