import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/signup_provider.dart';
import 'custom_dialoges.dart';

class TagsCellWidget extends StatefulWidget {
  final List<Map<String, dynamic>> initialTags;

  const TagsCellWidget({Key? key, required this.initialTags}) : super(key: key);

  @override
  State<TagsCellWidget> createState() => _TagsCellWidgetState();
}

class _TagsCellWidgetState extends State<TagsCellWidget> {
  List<Map<String, dynamic>> tags = [
    {'tag': 'Tag1', 'color': Colors.red},
    {'tag': 'Tag2', 'color': Colors.orange},
  ];
  void _editTag(String oldTag, int index) async {
    final controller = TextEditingController(text: oldTag);

    final newTag = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          title: Text("Edit Tag",style: TextStyle(color: Colors.blue,),),
          content: TextFormField(
            cursorColor: Colors.blue,
            controller: controller,
            decoration: InputDecoration(hintText: "Enter new tag name",  focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 1), // active/focus line color
            ),),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel",style: TextStyle(color: Colors.grey),),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: Text("Update",style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );

    if (newTag != null && newTag.isNotEmpty && newTag != oldTag) {
      final provider = Provider.of<SignupProvider>(context, listen: false);
      final status = await provider.updateTag(
        userId: "user_123",
        oldTagName: oldTag,
        newTagName: newTag,
      );

      if (status == "success") {
        setState(() {
          tags[index]['tag'] = newTag;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Tag updated successfully")),
        );
      } else if (status == "exists") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Tag with this name already exists")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Something went wrong")),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                for (int i = 0; i < tags.length; i++)
                  _HoverableTag(
                    tag: tags[i]['tag'],
                    color: tags[i]['color'] ?? Colors.grey.shade200,
                    onDelete: () async {
                      final provider = Provider.of<SignupProvider>(context, listen: false);
                      final status = await provider.deleteTag(
                        userId: "user_123",
                        tagName: tags[i]['tag'],
                      );
                      if (status == "success") {
                        setState(() {
                          tags.removeAt(i);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Tag deleted successfully")),
                        );
                      } else if (status == "failed") {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Tag not found")),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Something went wrong")),
                        );
                      }
                    },
                    onEdit: () => _editTag(tags[i]['tag'], i),
                  ),

              ],
            ),
          ),
          Tooltip(
            message: 'Add Tag',
            child: GestureDetector(
              onTap: () async {
                final result = await showAddTagDialog(context);

                if (result != null && result['tag'].toString().trim().isNotEmpty) {
                  final tagText = result['tag'];
                  final tagColor = result['color'];

                  final provider = Provider.of<SignupProvider>(context, listen: false);

                  final status = await provider.createTag(
                    userId: "user_123", // or dynamically from auth
                    tagName: tagText,
                    createdBy: "admin", // or logged-in user
                  );

                  if (status == "success") {
                    setState(() {
                      tags.add({'tag': tagText, 'color': tagColor});
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tag added successfully')),
                    );
                  } else if (status == "exists") {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tag already exists')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Something went wrong')),
                    );
                  }
                }
              },
              child: Image.asset(
                'assets/icons/img_1.png',
                width: 14,
                height: 14,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HoverableTag extends StatefulWidget {
  final String tag;
  final VoidCallback? onEdit;
  final Color color;
  final VoidCallback onDelete;

  const _HoverableTag({
    Key? key,
    required this.tag,
    required this.onEdit,
    required this.color,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<_HoverableTag> createState() => _HoverableTagState();
}

class _HoverableTagState extends State<_HoverableTag> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final textColor =
        Colors.white;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            margin: const EdgeInsets.only(top: 4, right: 2),
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              widget.tag,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w500,
                fontSize: 10,
              ),
            ),
          ),
          if (_hovering)
            Positioned(
              bottom: 10,

              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: widget.onEdit, // <-- Edit tap
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      margin: const EdgeInsets.only(right: 2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 0.4),
                        color: Colors.white,
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 5,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onDelete,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 0.4),
                        color: Colors.white,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 5,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }


}
