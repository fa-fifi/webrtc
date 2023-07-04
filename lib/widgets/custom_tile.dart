import 'package:flutter/material.dart';
import 'package:webrtc/widgets/flat_button.dart';

class CustomTile extends StatefulWidget {
  final Function(TextEditingController) onPressed;
  final String title;
  final String subtitle;
  final String label;

  const CustomTile(
      {super.key,
      required this.onPressed,
      required this.title,
      required this.subtitle,
      required this.label});

  @override
  State<CustomTile> createState() => _CustomTileState();
}

class _CustomTileState extends State<CustomTile> {
  final TextEditingController textEditingController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    textEditingController.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          ListTile(
              title: Text(widget.title),
              subtitle: Text(widget.subtitle),
              trailing: FlatButton(
                  onPressed: () => textEditingController.text.trim().isEmpty
                      ? null
                      : widget.onPressed(textEditingController),
                  label: widget.label)),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              minLines: 1,
              maxLines: 3,
              controller: textEditingController,
              focusNode: focusNode,
              keyboardType: TextInputType.multiline,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                filled: true,
                fillColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.1),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary),
                    borderRadius: BorderRadius.circular(5)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(5)),
              ),
            ),
          ),
        ],
      );
}
