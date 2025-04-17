import 'package:flutter/material.dart';

class EmptyQuote extends StatelessWidget {
  final bool hasUsers;
  
  const EmptyQuote({
    super.key,
    required this.hasUsers,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.format_quote, size: 70, color: Colors.grey[400]),
          SizedBox(height: 20),
          Text(
            'No quotes yet',
            style: TextStyle(fontSize: 20, color: Colors.grey[600]),
          ),
          SizedBox(height: 10),
          Text(
            hasUsers
                ? 'Add a user first, then create your first quote'
                : 'Create your first quote',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
