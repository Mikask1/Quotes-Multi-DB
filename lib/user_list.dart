import 'package:flutter/material.dart';
import 'package:my_first_app/empty_user.dart';
import 'user.dart';
import 'user_dialog.dart';
import 'dart:io';

class UserList extends StatelessWidget {
  final List<User> users;
  final Function(String name, int age, String gender, String? profilePicture)
  addUser;
  final Function(int index) deleteUser;

  const UserList({
    super.key,
    required this.users,
    required this.addUser,
    required this.deleteUser,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Users',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.person_add, color: Colors.white),
                label: Text('Add User', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return UserDialog(onSubmit: addUser);
                    },
                  );
                },
              ),
            ],
          ),
        ),
        users.isEmpty
            ? EmptyUser()
            : ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(12),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200],
                      ),
                      child:
                          user.profilePicture != null
                              ? ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: Image.file(
                                  File(user.profilePicture!),
                                  fit: BoxFit.cover,
                                ),
                              )
                              : Icon(
                                Icons.person,
                                size: 30,
                                color: Colors.grey[600],
                              ),
                    ),
                    title: Text(
                      user.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Age: ${user.age}'),
                        Text('Gender: ${user.gender}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red.shade100),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Delete User'),
                              content: Text(
                                'Are you sure you want to delete ${user.name}?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    deleteUser(index);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            ),
      ],
    );
  }
}
