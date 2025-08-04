import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../dialogs/custom_dialoges.dart';
import 'banking_dialoges/add_payment_method.dart';

class BankPaymentScreen extends StatefulWidget {
  const BankPaymentScreen({super.key});

  @override
  State<BankPaymentScreen> createState() => _BankPaymentScreenState();
}

class _BankPaymentScreenState extends State<BankPaymentScreen> {
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  bool _isHovering = false;
  final GlobalKey _plusKey = GlobalKey();


  final List<String> categories = [
    'All',
    'New',
    'Pending',
    'Completed',
    'Stop',
  ];
  String? selectedCategory;
  final List<String> categories1 = [
    'No Tags',
    'Tag 001',
    'Tag 002',
    'Sample Tag',
  ];
  String? selectedCategory1;
  final List<String> categories2 = ['All', 'Pending', 'Paid'];
  String? selectedCategory2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MouseRegion(
              onEnter: (_) => setState(() => _isHovering = true),
              onExit: (_) => setState(() => _isHovering = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 45,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(2),
                  boxShadow:
                  _isHovering
                      ? [
                    BoxShadow(
                      color: Colors.blue,
                      blurRadius: 4,
                      spreadRadius: 0.1,
                      offset: const Offset(0, 1),
                    ),
                  ]
                      : [],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            CustomDropdown(
                              hintText: "Status",
                              selectedValue: selectedCategory,
                              onChanged:
                                  (newValue) => setState(
                                    () => selectedCategory = newValue!,
                              ),
                              items: categories,
                            ),
                            CustomDropdown(
                              hintText: "Select Tags",
                              selectedValue: selectedCategory1,
                              onChanged:
                                  (newValue) => setState(
                                    () => selectedCategory1 = newValue!,
                              ),
                              items: categories1,
                            ),
                            CustomDropdown(
                              hintText: "Payment Status",
                              selectedValue: selectedCategory2,
                              onChanged:
                                  (newValue) => setState(
                                    () => selectedCategory2 = newValue!,
                              ),
                              items: categories2,
                            ),

                          ],
                        ),
                      ),
                    ),

                    Row(
                      children: [
                        /// Plus Button with Menu
                        Card(
                          elevation: 8,
                          color: Colors.blue,
                          shape: const CircleBorder(),
                          child: Builder(
                            builder:
                                (context) => Tooltip(
                              message: 'Show menu',
                              waitDuration: const Duration(milliseconds: 2),
                              child: GestureDetector(
                                key: _plusKey,
                                onTap: () {
                                  showAddPaymentMethodDialog(context);
                                },
                                child: const SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: Center(
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding
              (
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                height: 400,
                child: ScrollbarTheme(
                  data: ScrollbarThemeData(
                    thumbVisibility: MaterialStateProperty.all(true),
                    thumbColor: MaterialStateProperty.all(Colors.grey),
                    thickness: MaterialStateProperty.all(8),
                    radius: const Radius.circular(4),
                  ),
                  child: Scrollbar(
                    controller: _verticalController,
                    thumbVisibility: true,
                    child: Scrollbar(
                      controller: _horizontalController,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        controller: _horizontalController,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          controller: _verticalController,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(minWidth: 1180),
                            child: Table(
                              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                              columnWidths: const {
                                0: FlexColumnWidth(1),
                                1: FlexColumnWidth(0.8),
                                2: FlexColumnWidth(0.8),
                                3: FlexColumnWidth(1),
                                4: FlexColumnWidth(1),
                                5: FlexColumnWidth(1),
                              },
                              children: [
                                TableRow(
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                  ),
                                  children: [
                                    _buildHeader("Date"),
                                    _buildHeader("Bank Name"),
                                    _buildHeader("Title Name"),
                                    _buildHeader("Account No/IBN"),
                                    _buildHeader("Mobile/Email"),
                                    _buildHeader("Other Actions"),

                                  ],
                                ),
                                for (int i = 0; i < 20; i++)
                                  TableRow(
                                    decoration: BoxDecoration(
                                      color: i.isEven
                                          ? Colors.grey.shade200
                                          : Colors.grey.shade100,
                                    ),
                                    children: [
                                      _buildCell("xxxxx3667", copyable: true),
                                      _buildCell("UDC Bank"),
                                      _buildCell('xxxxxx'),
                                      _buildCell2(
                                        "ACC xxxxxxxx345",
                                        "IBN xxxxxxx345",
                                        copyable: true,
                                      ),
                                      _buildCell2("0626626626", "@gmail.com"),
                                      _buildActionCell(
                                        onEdit: () {},
                                        onDelete: () {},
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
  Widget _buildHeader(String text) {
    return Container(
      height: 40,
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
  Widget _buildCell(String text, {bool copyable = false}) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
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
                padding: const EdgeInsets.only(left: 4),
                child: Icon(Icons.copy, size: 10, color: Colors.blue[700]),
              ),
            ),
        ],
      ),
    );
  }
  Widget _buildCell2(
      String text1,
      String text2, {
        bool copyable = false,
        bool centerText2 = false,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text1, style: const TextStyle(fontSize: 12)),
          centerText2
              ? Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  text2,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.black54,
                  ),
                ),
                if (copyable)
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(text: "$text1\n$text2"),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Copied to clipboard'),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Icon(
                        Icons.copy,
                        size: 14,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
              ],
            ),
          )
              : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  text2,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.black54,
                  ),
                ),
              ),
              if (copyable)
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(text: "$text1\n$text2"),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied to clipboard')),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Icon(
                      Icons.copy,
                      size: 8,
                      color: Colors.blue[700],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildActionCell({
    VoidCallback? onEdit,
    VoidCallback? onDelete,
    VoidCallback? onDraft,
  }) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.delete, size: 20, color: Colors.red),
          tooltip: 'Delete',
          onPressed: onDelete ?? () {},
        ),
        IconButton(
          icon: const Icon(Icons.edit, size: 20, color: Colors.green),
          tooltip: 'Edit',
          onPressed: onEdit ?? () {},
        ),

        /*IconButton(
          icon: Image.asset(
            'assets/icons/img_3.png',
            width: 20,
            height: 20,
            color: Colors.red,
          ),
          tooltip: 'Draft',
          onPressed: onDraft ?? () {},
        ),*/
      ],
    );
  }


}
