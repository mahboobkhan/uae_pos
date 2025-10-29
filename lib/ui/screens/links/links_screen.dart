import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/app_colors.dart';
import '../../../ui/dialogs/custom_dialoges.dart';
import '../../../ui/dialogs/custom_fields.dart';

class LinksScreen extends StatefulWidget {
  const LinksScreen({super.key});

  @override
  State<LinksScreen> createState() => _LinksScreenState();
}

class _LinksScreenState extends State<LinksScreen> {
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  // Dummy data for links
  List<Map<String, dynamic>> _dummyLinks = [
    {
      'id': '1',
      'title': 'Sample Link 1',
      'description': 'This is a sample description for the first link',
      'url': 'https://example.com',
    },
    {
      'id': '2',
      'title': 'Sample Link 2',
      'description': 'This is a sample description for the second link',
      'url': 'https://flutter.dev',
    },
    {
      'id': '3',
      'title': 'Sample Link 3',
      'description': 'This is a sample description for the third link',
      'url': 'https://dart.dev',
    },
  ];

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }

  bool _isHovering = false;

  void _editLink(Map<String, dynamic> link) {
    _showEditLinkDialog(link);
  }

  void _deleteLink(Map<String, dynamic> link) {
    setState(() {
      _dummyLinks.removeWhere((item) => item['id'] == link['id']);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Link "${link['title']}" deleted successfully')),
    );
  }

  Future<void> _openLink(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open link')),
      );
    }
  }

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
                  boxShadow: _isHovering
                      ? [
                          BoxShadow(
                            color: Colors.blue,
                            blurRadius: 4,
                            spreadRadius: 0.1,
                            offset: const Offset(0, 1),
                          )
                        ]
                      : [],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: []),
                      ),
                    ),
                    Row(
                      children: [
                        // Refresh Button
                        Card(
                          elevation: 4,
                          color: Colors.green,
                          shape: const CircleBorder(),
                          child: Tooltip(
                            message: 'Refresh',
                            waitDuration: const Duration(milliseconds: 2),
                            child: GestureDetector(
                              onTap: () {
                                // TODO: Implement refresh
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                decoration: const BoxDecoration(shape: BoxShape.circle),
                                child: const Center(
                                  child: Icon(Icons.refresh, color: Colors.white, size: 20),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Add Link Button
                        Card(
                          elevation: 8,
                          color: Colors.blue,
                          shape: const CircleBorder(),
                          child: Tooltip(
                            message: 'Add Link',
                            waitDuration: const Duration(milliseconds: 2),
                            child: GestureDetector(
                              onTap: () {
                                _showAddLinkDialog();
                              },
                              child: const SizedBox(
                                width: 30,
                                height: 30,
                                child: Center(child: Icon(Icons.add, color: Colors.white, size: 20)),
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
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
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
                                0: FlexColumnWidth(0.5),
                                1: FlexColumnWidth(1),
                                2: FlexColumnWidth(2),
                                3: FlexColumnWidth(1.5),
                                4: FlexColumnWidth(0.8),
                              },
                              children: [
                                TableRow(
                                  decoration: BoxDecoration(color: Colors.red.shade50),
                                  children: [
                                    _buildHeader("Link ID"),
                                    _buildHeader("Title"),
                                    _buildHeader("Description"),
                                    _buildHeader("Open Link"),
                                    _buildHeader("Actions"),
                                  ],
                                ),
                                ..._dummyLinks.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final link = entry.value;
                                    return TableRow(
                                      decoration: BoxDecoration(
                                        color: index.isEven ? Colors.grey.shade200 : Colors.grey.shade100,
                                      ),
                                      children: [
                                      _buildCell(link['id'] ?? 'N/A'),
                                      _buildCell(link['title'] ?? 'N/A'),
                                      _buildCell(link['description'] ?? 'N/A'),
                                      _buildLinkCell(link['url'] ?? ''),
                                        _buildActionCell(
                                        onEdit: () => _editLink(link),
                                        onDelete: () => _deleteLink(link),
                                        ),
                                      ],
                                    );
                                }),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
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
          style: const TextStyle(color: AppColors.redColor, fontWeight: FontWeight.bold, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildCell(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildLinkCell(String url) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: GestureDetector(
        onTap: () => _openLink(url),
        child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
            Flexible(
              child: Text(
                url,
                style: const TextStyle(fontSize: 12, color: Colors.blue, decoration: TextDecoration.underline),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.open_in_new, size: 14, color: Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCell({VoidCallback? onEdit, VoidCallback? onDelete}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.edit, size: 20, color: Colors.green),
          tooltip: 'Edit',
          onPressed: onEdit ?? () {},
        ),
        IconButton(
          icon: const Icon(Icons.delete, size: 20, color: AppColors.redColor),
          tooltip: 'Delete',
          onPressed: onDelete ?? () {},
        ),
      ],
    );
  }

  void _showAddLinkDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController urlController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: SizedBox(
          width: 200,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Add Link',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        titleController.dispose();
                        descriptionController.dispose();
                        urlController.dispose();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Form Fields
                CustomTextField(
                  label: "Title",
                  controller: titleController,
                  hintText: "Enter title",
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: "Description",
                  controller: descriptionController,
                  hintText: "Enter description",
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: "Link",
                  controller: urlController,
                  hintText: "Enter URL (e.g., https://example.com)",
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 20),
                // Action Buttons
                Row(
                  children: [
                    CustomButton(
                      text: "Cancel",
                      backgroundColor: Colors.grey,
                      onPressed: () {
                        titleController.dispose();
                        descriptionController.dispose();
                        urlController.dispose();
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(width: 10),
                    CustomButton(
                      text: "Add",
                      backgroundColor: Colors.green,
                      onPressed: () {
                        if (titleController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter title')),
                          );
                          return;
                        }
                        if (descriptionController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter description')),
                          );
                          return;
                        }
                        if (urlController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter link URL')),
                          );
                          return;
                        }

                        // Generate new ID
                        int maxId = 0;
                        for (var link in _dummyLinks) {
                          final id = int.tryParse(link['id'].toString()) ?? 0;
                          if (id > maxId) {
                            maxId = id;
                          }
                        }
                        final newId = (maxId + 1).toString();

                        setState(() {
                          _dummyLinks.add({
                            'id': newId,
                            'title': titleController.text.trim(),
                            'description': descriptionController.text.trim(),
                            'url': urlController.text.trim(),
                          });
                        });

                        titleController.dispose();
                        descriptionController.dispose();
                        urlController.dispose();
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Link added successfully')),
                        );
                      },
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

  void _showEditLinkDialog(Map<String, dynamic> link) {
    final TextEditingController idController =
        TextEditingController(text: link['id'] ?? '');
    final TextEditingController titleController =
        TextEditingController(text: link['title'] ?? '');
    final TextEditingController descriptionController =
        TextEditingController(text: link['description'] ?? '');
    final TextEditingController urlController =
        TextEditingController(text: link['url'] ?? '');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: SizedBox(
          width: 150,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Edit Link',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        idController.dispose();
                        titleController.dispose();
                        descriptionController.dispose();
                        urlController.dispose();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Form Fields
                CustomTextField(
                  label: "Link ID",
                  controller: idController,
                  hintText: "Link ID",
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: "Title",
                  controller: titleController,
                  hintText: "Enter title",
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: "Description",
                  controller: descriptionController,
                  hintText: "Enter description",
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: "Link",
                  controller: urlController,
                  hintText: "Enter URL (e.g., https://example.com)",
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 20),
                // Action Buttons
                Row(
                  children: [
                    CustomButton(
                      text: "Cancel",
                      backgroundColor: Colors.grey,
                      onPressed: () {
                        idController.dispose();
                        titleController.dispose();
                        descriptionController.dispose();
                        urlController.dispose();
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(width: 10),
                    CustomButton(
                      text: "Submit",
                      backgroundColor: Colors.blue,
                      onPressed: () {
                        if (titleController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter title')),
                          );
                          return;
                        }
                        if (descriptionController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter description')),
                          );
                          return;
                        }
                        if (urlController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter link URL')),
                          );
                          return;
                        }

                        setState(() {
                          final index =
                              _dummyLinks.indexWhere((item) => item['id'] == link['id']);
                          if (index != -1) {
                            _dummyLinks[index] = {
                              'id': idController.text.trim(),
                              'title': titleController.text.trim(),
                              'description': descriptionController.text.trim(),
                              'url': urlController.text.trim(),
                            };
                          }
                        });

                        idController.dispose();
                        titleController.dispose();
                        descriptionController.dispose();
                        urlController.dispose();
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Link updated successfully')),
                        );
                      },
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
