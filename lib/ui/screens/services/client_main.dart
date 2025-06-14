import 'package:abc_consultant/ui/screens/services/client_screen/comapny_profile_add.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClientMain extends StatefulWidget {
  const ClientMain({super.key});

  @override
  State<ClientMain> createState() => _ClientMainState();
}

class _ClientMainState extends State<ClientMain> {
  String? customerValue;
  String? tagValue;
  String? paymentValue;
  String? profileAddCategory;

  final List<String> customerType = ["Company", "Individual"];
  final List<String> tags = ["Tag 001", "Tag 002", "Sample Tag"];
  final List<String> paymentStatus = ["Pending", "Paid"];
  List<String> selectedCategory4 = [];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: height * 0.05),
                Row(
                  children: [
                    Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            // Dropdowns
                            _buildDropdown(
                              customerValue,
                              "Select Customer Type",
                              customerType,
                              (newValue) {
                                setState(() {
                                  customerValue = newValue!;
                                });
                              },
                            ),

                            _buildDropdown(tagValue, "Select Tags", tags, (
                              newValue,
                            ) {
                              setState(() {
                                tagValue = newValue!;
                              });
                            }),
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

                            const SizedBox(width: 280),
                            PopupMenuButton<String>(
                              onSelected: (String newValue) {
                                setState(() {
                                  profileAddCategory = newValue;
                                });
                                if (newValue == 'Add Company') {
                                  showAddCompanyProfileDialogue(
                                    context,
                                  ); // Call the dialog function here
                                } else if (newValue == 'Add Individual') {
                                  // Handle individual addition
                                }
                              },
                              itemBuilder:
                                  (BuildContext context) =>
                                      <PopupMenuEntry<String>>[
                                        const PopupMenuItem<String>(
                                          value: 'Add Company',
                                          child: Text('Add Company'),
                                        ),
                                        const PopupMenuItem<String>(
                                          value: 'Add Individual',
                                          child: Text('Add Individual'),
                                        ),
                                      ],
                              child: CircleAvatar(
                                backgroundColor: Colors.red,
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: width * 0.02),
                            Icon(Icons.edit_outlined, color: Colors.green),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.05),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection:
                          Axis.horizontal, // Enable horizontal scrolling
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Table(
                          border: TableBorder.all(color: Colors.white),
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          columnWidths: const {
                            0: FixedColumnWidth(130),
                            1: FixedColumnWidth(130),
                            2: FixedColumnWidth(130),
                            3: FixedColumnWidth(130),
                            4: FixedColumnWidth(130),
                            5: FixedColumnWidth(130),
                            6: FixedColumnWidth(130),
                            7: FixedColumnWidth(130),
                            8: FixedColumnWidth(130),
                          },
                          children: [
                            // Header Row
                            TableRow(
                              decoration: const BoxDecoration(
                                color: Color(0xFFEDEDED),
                              ),
                              children: [
                                _buildHeader("Client Type"),
                                _buildHeader("Customers\nRef I'd"),
                                _buildHeader("Tags Details"),
                                _buildHeader("Contact Number\nEmail I'd"),
                                _buildHeader("Project Status"),
                                _buildHeader("Payment\nPending"),
                                _buildHeader("Total Received"),
                                _buildHeader("Other Actions"),
                                // _buildHeader("Ref Id"),
                              ],
                            ),
                            // Sample Data Row
                            TableRow(
                              children: [
                                _buildCell("Company", context: context),
                                _buildCell(
                                  "Sample Customer\nxxxxxxxxx245",
                                  context: context,
                                  copyable: true,
                                ),
                                _buildTagsCell([
                                  "Sample Tags",
                                  "Sample",
                                  "Tages123",
                                ]),
                                _buildCell(
                                  "+971 123 4567\nsample@abc.com",
                                  context: context,
                                  copyable: true,
                                ),
                                _buildCell("0/3-Running", context: context),
                                _buildPriceWithAdd("300"),
                                _buildCell("900", context: context),
                                _buildCell(
                                  "Edit Profile - Orders History",
                                  color: Colors.blue,
                                  context: context,
                                ),
                                // _buildCell("xxxxxxxxx245"),
                              ],
                            ),
                          ],
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
    child: Text(
      text,
      style: const TextStyle(color: Colors.red),
      textAlign: TextAlign.center,
    ),
  );
}

// Widget _buildCell(String text, {Color color = Colors.black}) {
//   return Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: Text(text, style: TextStyle(fontSize: 13, color: color)),
//   );
// }

Widget _buildCell(
  String text, {
  required BuildContext context,
  Color color = Colors.black,
  bool copyable = false,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 13, color: color),
            overflow: TextOverflow.ellipsis,
            maxLines: 7,
          ),
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
              child: Icon(Icons.copy, size: 16, color: Colors.grey[700]),
            ),
          ),
      ],
    ),
  );
}

Widget _buildTagsCell(List<String> tags) {
  final colors = [Colors.purple, Colors.green, Colors.blue];
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: Wrap(
      spacing: 4,
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
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Row(
      children: [
        Text(price),
        const Spacer(),
        const Icon(Icons.add, size: 16, color: Colors.red),
      ],
    ),
  );
}
