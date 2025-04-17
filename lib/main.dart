import 'package:flutter/material.dart';
import 'package:my_first_app/empty_quote.dart';
import 'quote.dart';
import 'user.dart';
import 'quote_card.dart';
import 'quote_dialog.dart';
import 'user_list.dart';
import 'package:uuid/uuid.dart';
import 'database_helper.dart';

void main() => runApp(MaterialApp(home: QuoteList()));

class QuoteList extends StatefulWidget {
  const QuoteList({super.key});

  @override
  _QuoteListState createState() => _QuoteListState();
}

class _QuoteListState extends State<QuoteList> {
  static final _uuid = Uuid();
  late List<Quote> quotes = [];
  late List<User> users = [];
  final dbHelper = DatabaseHelper.instance;
  bool isLoading = true;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _resetAndLoadData();
  }
  
  Future<void> _resetAndLoadData() async {
    setState(() {
      isLoading = true;
    });
    
    try {
      await dbHelper.close();
      await dbHelper.deleteDatabase();
      await _loadData();
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Error resetting database: ${e.toString()}');
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });
    
    await _loadUsersFromDB();
    await _loadQuotesFromDB();
    
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _loadUsersFromDB() async {
    try {
      final allUsers = await dbHelper.getAllUsers();
      if (mounted) {
        setState(() {
          users = allUsers;
        });
      }
    } catch (e) {
      _showErrorSnackBar('Failed to load users');
    }
  }

  Future<void> _loadQuotesFromDB() async {
    try {
      final allQuotes = await dbHelper.getAllQuotes();

      if (mounted) {
        setState(() {
          quotes = allQuotes;
        });
      }
    } catch (e) {
      _showErrorSnackBar('Failed to load quotes');
    }
  }

  Future<void> _addUser(String name, int age, String gender, String? profilePicture) async {
    try {
      final user = User(
        id: _uuid.v4(),
        name: name,
        age: age,
        gender: gender,
        profilePicture: profilePicture,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await dbHelper.insertUser(user);
      await _loadUsersFromDB();
    } catch (e) {
      _showErrorSnackBar(e.toString());
    }
  }

  Future<void> _deleteUser(String userId) async {
    try {
      await dbHelper.deleteUser(userId);
      await _loadUsersFromDB();
    } catch (e) {
      _showErrorSnackBar('Failed to delete user');
    }
  }

  Future<void> _addQuote(String text, String userId, String? imagePath) async {
    try {
      final quote = Quote(
        text: text,
        id: _uuid.v4(),
        userId: userId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        imagePath: imagePath,
      );

      await dbHelper.insertQuote(quote);
      await _loadQuotesFromDB();
    } catch (e) {
      _showErrorSnackBar('Failed to add quote');
    }
  }

  Future<void> _updateQuote(
    Quote quote,
    String newText,
    String userId,
    String? newImagePath,
  ) async {
    try {
      final updatedQuote = Quote(
        text: newText,
        id: quote.id,
        userId: userId,
        createdAt: quote.createdAt,
        updatedAt: DateTime.now(),
        imagePath: newImagePath,
      );

      await dbHelper.updateQuote(updatedQuote);
      await _loadQuotesFromDB();
    } catch (e) {
      _showErrorSnackBar('Failed to update quote');
    }
  }

  Future<void> _deleteQuote(Quote quote) async {
    try {
      await dbHelper.deleteQuote(quote.id);
      await _loadQuotesFromDB();
    } catch (e) {
      _showErrorSnackBar('Failed to delete quote');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          'Awesome Quotes',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade300,
        actions: <Widget>[
          if (_currentTabIndex == 0)
            IconButton(
              icon: Icon(Icons.add, color: Colors.white),
              onPressed: () {
                if (users.isEmpty) {
                  _showErrorSnackBar('Please add a user first before creating a quote');
                  return;
                }
                
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return QuoteDialog(
                      users: users,
                      onSubmit: (text, userId, imagePath) {
                        _addQuote(text, userId, imagePath);
                      },
                    );
                  },
                );
              },
              tooltip: 'Create Quote',
            ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: (index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.format_quote),
            label: 'Quotes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Users',
          ),
        ],
      ),
    );
  }
  
  Widget _buildBody() {
    if (_currentTabIndex == 0) {
      return _buildQuotesList();
    } else if (_currentTabIndex == 1) {
      return _buildUsersList();
    } else {
      return Container();
    }
  }
  
  Widget _buildQuotesList() {
    return quotes.isEmpty
        ? EmptyQuote(hasUsers: users.isNotEmpty)
        : ListView.builder(
            itemCount: quotes.length,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemBuilder: (context, index) {
              return QuoteCard(
                quote: quotes[index],
                update: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return QuoteDialog(
                        quote: quotes[index],
                        users: users,
                        onSubmit: (newText, userId, newImagePath) {
                          _updateQuote(
                            quotes[index],
                            newText,
                            userId,
                            newImagePath,
                          );
                        },
                      );
                    },
                  );
                },
                delete: () {
                  _deleteQuote(quotes[index]);
                },
              );
            },
          );
  }
  
  Widget _buildUsersList() {
    return SingleChildScrollView(
      child: UserList(
        users: users,
        addUser: _addUser,
        deleteUser: (index) => _deleteUser(users[index].id),
      ),
    );
  }
}
