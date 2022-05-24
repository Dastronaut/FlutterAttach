import 'package:flutter/material.dart';

class DrawerListTile extends StatefulWidget {
  const DrawerListTile({
    Key? key,
    required this.icon,
    required this.title,
  }) : super(key: key);

  final Icon icon;

  final title;

  @override
  State<DrawerListTile> createState() => _DrawerListTileState();
}

class _DrawerListTileState extends State<DrawerListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      
      leading: widget.icon,
      trailing: const Icon(Icons.keyboard_arrow_right),
      title: Text(
        widget.title,
        style: const TextStyle(fontSize: 15, fontFamily: "Roboto"),
      ),
      onTap: () {},
    );
  }
}
