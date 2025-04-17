import 'package:flutter/material.dart';

class QuoteMenu extends StatelessWidget {
  final Function onDelete;
  final Function onUpdate;

  const QuoteMenu({
    super.key,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: Colors.grey[600]),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'update',
          child: Row(
            children: [
              Icon(
                Icons.edit_outlined,
                color: Colors.blue.shade700,
              ),
              SizedBox(width: 8.0),
              Text('Update'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Icon(
                Icons.delete_outline,
                color: Colors.red.shade700,
              ),
              SizedBox(width: 8.0),
              Text('Delete'),
            ],
          ),
        ),
      ],
      onSelected: (String value) {
        if (value == 'delete') {
          onDelete();
        } else if (value == 'update') {
          onUpdate();
        }
      },
    );
  }
} 