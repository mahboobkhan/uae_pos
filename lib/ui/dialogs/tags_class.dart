import 'package:flutter/material.dart';
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
                    onDelete: () {
                      setState(() {
                        tags.removeAt(i);
                      });
                    },
                  ),
              ],
            ),
          ),
          Tooltip(
            message: 'Add Tag',
            child: GestureDetector(
              onTap: () async {
                final result = await showAddTagDialog(context);
                if (result != null &&
                    result['tag'].toString().trim().isNotEmpty) {
                  setState(() {
                    tags.add({
                      'tag': result['tag'],
                      'color': result['color'],
                    });
                  });
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
  final Color color;
  final VoidCallback onDelete;

  const _HoverableTag({
    Key? key,
    required this.tag,
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
                fontSize: 12,
              ),
            ),
          ),
          if (_hovering)
            Positioned(
              top: 2,
              right: 2,
              child: GestureDetector(
                onTap: widget.onDelete,
                child: Container(
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black,
                      width: 0.8,
                    ),
                    color: Colors.white,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 10,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
