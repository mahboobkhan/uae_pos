import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/client_profile_provider.dart';

import 'calender.dart';
import 'custom_dialoges.dart';
import 'custom_fields.dart';

Future<void> showCompanyProfileDialog(BuildContext context, {Map<String, dynamic>? clientData}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder:
        (context) => Dialog(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: CompanyProfile(clientData: clientData),
        ),
  );
}

class CompanyProfile extends StatefulWidget {
  final Map<String, dynamic>? clientData;
  const CompanyProfile({super.key, this.clientData});

  @override
  State<StatefulWidget> createState() => CompanyProfileState();
}

class CompanyProfileState extends State<CompanyProfile> {
  void _pickDateTime2() {
    showDialog(
      context: context,
      builder: (context) {
        DateTime selectedDate = DateTime.now();

        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          content: CustomCupertinoCalendar(
            onDateTimeChanged: (date) {
              selectedDate = date;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
              },
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                _issueDateController.text =
                    "${selectedDate.day}-${selectedDate.month}-${selectedDate.year} "
                    "${selectedDate.hour}:${selectedDate.minute.toString().padLeft(2, '0')}";
                Navigator.pop(context); // close dialog
              },
              child: const Text("OK", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController tradeLicenseController = TextEditingController();
  final TextEditingController companyCodeController = TextEditingController();
  final TextEditingController establishmentNumberController =
      TextEditingController();
  final TextEditingController extraNoteController = TextEditingController();
  final TextEditingController emailId2Controller = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController contactNumber2Controller =
      TextEditingController();
  final TextEditingController physicalAddressController =
      TextEditingController();
  final TextEditingController channelNameController = TextEditingController();
  final TextEditingController channelLoginController = TextEditingController();
  final TextEditingController channelPasswordController =
      TextEditingController();
  final TextEditingController documentNameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emiratesIdController = TextEditingController();
  final TextEditingController workPermitNumberController =
      TextEditingController();
  final TextEditingController emailId1Controller = TextEditingController();
  final TextEditingController contactNumber3Controller =
      TextEditingController();
  final TextEditingController docName2 = TextEditingController();
  final TextEditingController advancePayment = TextEditingController();
  final TextEditingController _issueDateController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();

  String? selectedPlatform;
  List<String> platformList = ['Bank', 'Violet', 'Other'];
  String? selectedJobType3;
  String? selectedJobType4;
  final TextEditingController _dateTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Prefill on edit
    final data = widget.clientData;
    if (data != null) {
      companyNameController.text = (data['name'] ?? '').toString();
      tradeLicenseController.text = (data['trade_license_no'] ?? '').toString();
      companyCodeController.text = (data['company_code'] ?? '').toString();
      establishmentNumberController.text = (data['establishment_no'] ?? '').toString();
      extraNoteController.text = (data['extra_note'] ?? '').toString();
      emailId2Controller.text = (data['email'] ?? '').toString();
      contactNumberController.text = (data['phone1'] ?? '').toString();
      contactNumber2Controller.text = (data['phone2'] ?? '').toString();
      physicalAddressController.text = (data['physical_address'] ?? '').toString();
      channelNameController.text = (data['echannel_name'] ?? '').toString();
      channelLoginController.text = (data['echannel_id'] ?? '').toString();
      channelPasswordController.text = (data['echannel_password'] ?? '').toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SizedBox(
        width: 950,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Company Profile',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 160,
                        child: SmallDropdownField(
                          label: "Employee type",
                          options: ['Cleaning', 'Consultining', 'Reparing'],
                          selectedValue: selectedJobType3,
                          onChanged: (value) {
                            setState(() {
                              selectedJobType3 = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        DateFormat('dd-MM-yyyy').format(DateTime.now()),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () async {
                          final shouldClose = await showDialog<bool>(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  backgroundColor: Colors.white,
                                  title: const Text("Are you sure?"),
                                  content: const Text(
                                    "Do you want to close this form? Unsaved changes may be lost.",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () =>
                                              Navigator.of(context).pop(false),
                                      child: const Text(
                                        "Keep Changes ",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.of(context).pop(true),
                                      child: const Text(
                                        "Close",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                          );

                          if (shouldClose == true) {
                            Navigator.of(context).pop(); // close the dialog
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                'ORN.0001-0000002', // Static example ID
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  CustomTextField(
                    label: "Company Name",
                    hintText: "xyz",
                    controller: companyNameController,
                  ),
                  CustomTextField(
                    label: "Trade Licence Number ",
                    controller: tradeLicenseController,
                    hintText: "1234",
                  ),
                  CustomTextField(
                    label: "Company Code ",
                    controller: companyCodeController,
                    hintText: "456",
                  ),
                  CustomTextField(
                    label: "Establishment Number ",
                    controller: establishmentNumberController,
                    hintText: "xxxxxxxxx",
                  ),
                ],
              ),
              SizedBox(height: 10),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  CustomTextField(
                    label: "Note Extra ",
                    controller: extraNoteController,
                    hintText: "xxxxxxxxx",
                  ),
                  CustomTextField(
                    label: "Email I'd ",
                    controller: emailId2Controller,
                    hintText: "@gmail.com",
                  ),
                  CustomTextField(
                    label: "Contact Number ",
                    controller: contactNumberController,
                    hintText: "+973xxxxxxxxxx",
                  ),
                  CustomTextField(
                    label: "Contact Number 2",
                    controller: contactNumber2Controller,
                    hintText: "+973xxxxxxxxxx",
                  ),
                  CustomTextField(
                    label: "Physical Address",
                    controller: physicalAddressController,
                    hintText: "Address,house,street,town,post code",
                  ),
                  CustomTextField(
                    label: "E- Channel Name",
                    controller: channelNameController,
                    hintText: "S.E.C.P",
                  ),
                  CustomTextField(
                    label: "E- Channel Login I'd",
                    controller: channelLoginController,
                    hintText: "S.E.C.P",
                  ),
                  CustomTextField(
                    label: "E- Channel Login Password",
                    controller: channelPasswordController,
                    hintText: "xxxxxxx",
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          CustomCompactTextField(
                            label: 'Doc Name',
                            hintText: '',
                            controller: documentNameController,
                          ),
                          CustomDateNotificationField(
                            label: "Issue Date Notifications",
                            controller: _issueDateController,
                            readOnly: true,
                            hintText: "dd-MM-yyyy HH:mm",
                            onTap: _pickDateTime2,
                          ),
                          CustomDateNotificationField(
                            label: "Expiry Date Notifications",
                            controller: _expiryDateController,
                            readOnly: true,
                            hintText: "dd-MM-yyyy HH:mm",
                            onTap: _pickDateTime2,
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              minimumSize: const Size(150, 38),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  4,
                                ), // Optional: slight rounding
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.upload_file,
                                  size: 16,
                                  color: Colors.white,
                                ), //
                                SizedBox(width: 6),
                                Text(
                                  'Upload File',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ), //
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  Text(
                    "Partner / Employee Records",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  CustomDropdownField(
                    label: "Employee",
                    options: ['Partner', 'Employee', 'Other Records'],
                    selectedValue: selectedJobType4,
                    onChanged: (value) {
                      setState(() {
                        selectedJobType4 = value;
                      });
                    },
                  ),
                  SizedBox(
                    width: 220,
                    // child: CustomDropdownWithRightAdd(
                    //   label: "Select Platform",
                    //   value: selectedPlatform,
                    //   items: platformList,
                    //   onChanged: (newValue) {
                    //     // Update selectedPlatform state in parent
                    //   },
                    //   onAddPressed: () {
                    //     showInstituteManagementDialog(context);
                    //   },
                    // ),
                  ),
                  CustomTextField(
                    label: " Name",
                    controller: nameController,
                    hintText: "Imran Khan",
                  ),
                  CustomTextField(
                    label: "Emirates IDs",
                    controller: emiratesIdController,
                    hintText: "S.E.C.P",
                  ),
                  CustomTextField(
                    label: "Work Permit No",
                    controller: workPermitNumberController,
                    hintText: "xxxxxxx",
                  ),
                  CustomTextField(
                    label: "Email I'd",
                    controller: emailId1Controller,
                    hintText: "xxxxxxx",
                  ),
                  CustomTextField(
                    label: "Contact No",
                    controller: contactNumber3Controller,
                    hintText: "xxxxxxx",
                  ),
                  CustomTextField(
                    label: "Advance Payment TID",
                    controller: advancePayment,
                    hintText: "*****",
                  ),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      InfoBox(
                        value: "Pending Payment",
                        label: "AED-3000",
                        color: Colors.blue.shade50,
                      ),
                      InfoBox(
                        value: "Advance Payment",
                        label: "AED-3000",
                        color: Colors.blue.shade50,
                      ),
                    ],
                  ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          CustomCompactTextField(
                            label: 'Doc Name',
                            hintText: '',
                            controller: docName2,
                          ),
                          CustomDateNotificationField(
                            label: "Issue Date Notifications",
                            controller: _issueDateController,
                            readOnly: true,
                            hintText: "dd-MM-yyyy HH:mm",
                            onTap: _pickDateTime,
                          ),
                          CustomDateNotificationField(
                            label: "Expiry Date Notifications",
                            controller: _expiryDateController,
                            readOnly: true,
                            hintText: "dd-MM-yyyy HH:mm",
                            onTap: _pickDateTime,
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              minimumSize: const Size(150, 38),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  4,
                                ), // Optional: slight rounding
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.upload_file,
                                  size: 16,
                                  color: Colors.white,
                                ), //
                                SizedBox(width: 6),
                                Text(
                                  'Upload File',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ), //
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  /*     Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "Add 2 more",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Add More Employee",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),*/
                  SizedBox(height: 10),
                  Row(
                    children: [
                      CustomButton(
                        text: "Editing",
                        backgroundColor: Colors.blue,
                        onPressed: () {},
                      ),
                      const SizedBox(width: 10),
                      CustomButton(
                        text: "Submit",
                        backgroundColor: Colors.green,
                        onPressed: () async {
                          final provider = context.read<ClientProfileProvider>();
                          final isEdit = widget.clientData != null && (widget.clientData!['client_ref_id']?.toString().isNotEmpty ?? false);

                          if (isEdit) {
                            await provider.updateClient(
                              clientRefId: widget.clientData!['client_ref_id'].toString(),
                              name: companyNameController.text.trim().isNotEmpty ? companyNameController.text.trim() : null,
                              email: emailId2Controller.text.trim().isNotEmpty ? emailId2Controller.text.trim() : null,
                              phone1: contactNumberController.text.trim().isNotEmpty ? contactNumberController.text.trim() : null,
                              phone2: contactNumber2Controller.text.trim().isNotEmpty ? contactNumber2Controller.text.trim() : null,
                              clientType: 'organization',
                              clientWork: (selectedJobType3 ?? 'Regular').toLowerCase(),
                              tradeLicenseNo: tradeLicenseController.text.trim().isNotEmpty ? tradeLicenseController.text.trim() : null,
                              companyCode: companyCodeController.text.trim().isNotEmpty ? companyCodeController.text.trim() : null,
                              establishmentNo: establishmentNumberController.text.trim().isNotEmpty ? establishmentNumberController.text.trim() : null,
                              physicalAddress: physicalAddressController.text.trim().isNotEmpty ? physicalAddressController.text.trim() : null,
                              echannelName: channelNameController.text.trim().isNotEmpty ? channelNameController.text.trim() : null,
                              echannelId: channelLoginController.text.trim().isNotEmpty ? channelLoginController.text.trim() : null,
                              echannelPassword: channelPasswordController.text.trim().isNotEmpty ? channelPasswordController.text.trim() : null,
                              extraNote: extraNoteController.text.trim().isNotEmpty ? extraNoteController.text.trim() : null,
                            );
                          } else {
                            await provider.addClient(
                              name: companyNameController.text.trim().isNotEmpty ? companyNameController.text.trim() : 'N/A',
                              clientType: 'organization',
                              clientWork: (selectedJobType3 ?? 'Regular').toLowerCase(),
                              email: emailId2Controller.text.trim().isNotEmpty ? emailId2Controller.text.trim() : 'no-email@example.com',
                              phone1: contactNumberController.text.trim().isNotEmpty ? contactNumberController.text.trim() : '+000000000',
                              phone2: contactNumber2Controller.text.trim().isNotEmpty ? contactNumber2Controller.text.trim() : null,
                              tradeLicenseNo: tradeLicenseController.text.trim().isNotEmpty ? tradeLicenseController.text.trim() : null,
                              companyCode: companyCodeController.text.trim().isNotEmpty ? companyCodeController.text.trim() : null,
                              establishmentNo: establishmentNumberController.text.trim().isNotEmpty ? establishmentNumberController.text.trim() : null,
                              physicalAddress: physicalAddressController.text.trim().isNotEmpty ? physicalAddressController.text.trim() : null,
                              echannelName: channelNameController.text.trim().isNotEmpty ? channelNameController.text.trim() : null,
                              echannelId: channelLoginController.text.trim().isNotEmpty ? channelLoginController.text.trim() : null,
                              echannelPassword: channelPasswordController.text.trim().isNotEmpty ? channelPasswordController.text.trim() : null,
                              extraNote: extraNoteController.text.trim().isNotEmpty ? extraNoteController.text.trim() : null,
                            );
                          }

                          if (provider.errorMessage == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(provider.successMessage ?? (isEdit ? 'Client updated' : 'Client created'))),
                            );
                            Navigator.of(context).pop();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(backgroundColor: Colors.red, content: Text(provider.errorMessage!)),
                            );
                          }
                        },
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

  void _pickDateTime() {
    showDialog(
      context: context,
      builder: (context) {
        DateTime selectedDate = DateTime.now();

        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          content: CustomCupertinoCalendar(
            onDateTimeChanged: (date) {
              selectedDate = date;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
              },
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                _issueDateController.text =
                    "${selectedDate.day}-${selectedDate.month}-${selectedDate.year} "
                    "${selectedDate.hour}:${selectedDate.minute.toString().padLeft(2, '0')}";
                Navigator.pop(context); // close dialog
              },
              child: const Text("OK", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}

void _showEditDialog(
  BuildContext context,
  StateSetter setState,
  List<String> institutes,
  int index,
  TextEditingController editController,
) {
  editController.text = institutes[index];
  showDialog(
    context: context,
    builder: (editContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.all(16),
        content: SizedBox(
          width: 250, // Smaller width
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                cursorColor: Colors.blue,
                controller: editController,
                decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1.5, color: Colors.blue),
                  ),
                  labelText: 'Edit institute',
                  labelStyle: TextStyle(color: Colors.blue),
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(editContext),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CustomButton(
                    backgroundColor: Colors.blue,
                    onPressed: () {
                      if (editController.text.trim().isNotEmpty) {
                        setState(() {
                          institutes[index] = editController.text.trim();
                        });
                        Navigator.pop(editContext);
                      }
                    },
                    text: 'Save',
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

void showInstituteManagementDialog(BuildContext context) {
  final List<String> institutes = [];
  final TextEditingController addController = TextEditingController();
  final TextEditingController editController = TextEditingController();
  int? editingIndex;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                12,
              ), // Slightly smaller radius
            ),
            contentPadding: const EdgeInsets.all(12), // Reduced padding
            insetPadding: const EdgeInsets.all(20), // Space around dialog
            content: SizedBox(
              width: 363,
              height: 305,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Compact header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Add Services',
                        style: TextStyle(
                          fontSize: 16, // Smaller font
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          size: 25,
                          color: Colors.red,
                        ),
                        // Smaller icon
                        padding: EdgeInsets.zero,
                        // Remove default padding
                        constraints: const BoxConstraints(),
                        // Remove minimum size
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Compact input field
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start, // align top
                    children: [
                      // TextField
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          alignment: Alignment.centerLeft,
                          child: TextField(
                            controller: addController,
                            cursorColor: Colors.blue,
                            style: const TextStyle(fontSize: 14),
                            decoration: const InputDecoration(
                              hintText: "Add institute...",
                              border: InputBorder.none, // remove double border
                              isDense: true,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Add Button
                      SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          onPressed: () {
                            if (addController.text.trim().isNotEmpty) {
                              setState(() {
                                institutes.add(addController.text.trim());
                                addController.clear();
                              });
                            }
                          },
                          child: const Text(
                            "Add",
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Compact list
                  Expanded(
                    child:
                        institutes.isEmpty
                            ? const Center(
                              child: Text(
                                'No institutes',
                                style: TextStyle(fontSize: 14),
                              ),
                            )
                            : ListView.builder(
                              shrinkWrap: true,
                              itemCount: institutes.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 4),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: ListTile(
                                    dense: true,
                                    // Makes tiles more compact
                                    visualDensity: VisualDensity.compact,
                                    // Even more compact
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    title: Text(
                                      institutes[index],
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    trailing: SizedBox(
                                      width:
                                          80, // Constrained width for buttons
                                      child: Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.edit,
                                              size: 18,
                                              color: Colors.green,
                                            ),
                                            padding: EdgeInsets.zero,
                                            onPressed:
                                                () => _showEditDialog(
                                                  context,
                                                  setState,
                                                  institutes,
                                                  index,
                                                  editController,
                                                ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              size: 18,
                                              color: Colors.red,
                                            ),
                                            padding: EdgeInsets.zero,
                                            onPressed: () {
                                              setState(() {
                                                institutes.removeAt(index);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

class CustomCompactInfoBox extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final Color borderColor;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  const CustomCompactInfoBox({
    Key? key,
    required this.title,
    required this.subtitle,
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.borderColor = Colors.grey,
    this.titleStyle,
    this.subtitleStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 6.5,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style:
                    titleStyle ??
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style:
                    subtitleStyle ??
                    const TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
