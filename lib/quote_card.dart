import 'package:flutter/material.dart';
import 'quote.dart';
import 'user.dart';
import 'quote_menu.dart';
import 'dart:io';
import 'database_helper.dart';

class QuoteCard extends StatefulWidget {
  final Quote quote;
  final Function delete;
  final Function update;
  const QuoteCard({
    super.key,
    required this.quote,
    required this.delete,
    required this.update,
  });

  @override
  State<QuoteCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard> {
  final dbHelper = DatabaseHelper.instance;
  User? user;
  bool isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadUser();
  }
  
  @override
  void didUpdateWidget(QuoteCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.quote.userId != widget.quote.userId) {
      setState(() {
        isLoading = true;
      });
      _loadUser();
    }
  }
  
  Future<void> _loadUser() async {
    try {
      user = await dbHelper.getUserByUserId(widget.quote.userId);
    } catch (e) {
      // Handle error
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.grey.shade50],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (isLoading)
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  else if (user != null)
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue.shade50,
                      ),
                      child: user!.profilePicture != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.file(
                                File(user!.profilePicture!),
                                fit: BoxFit.cover,
                              ),
                            )
                          : Icon(
                              Icons.person,
                              color: Colors.blue.shade300,
                            ),
                    )
                  else
                    SizedBox(width: 40.0),
                  QuoteMenu(
                    onDelete: widget.delete,
                    onUpdate: widget.update,
                  ),
                ],
              ),
              if (widget.quote.imagePath != null) ...[
                SizedBox(height: 16.0),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(widget.quote.imagePath!),
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
              SizedBox(height: 12.0),
              Text(
                "\"${widget.quote.text}\"",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  if (user != null)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'By: ${user!.name}',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 20.0),
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Created At\t\t: ${widget.quote.createdAt.toString().substring(0, 19)}",
                      style: TextStyle(fontSize: 10.0, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      "Updated At\t\t: ${widget.quote.updatedAt.toString().substring(0, 19)}",
                      style: TextStyle(fontSize: 10.0, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
