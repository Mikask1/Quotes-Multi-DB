# Quotes App

Cloned from https://github.com/iamshaunjp/flutter-beginners-tutorial/tree/lesson-21

## Author
Name: Darren Prasetya

NRP: 5025211162

Database: SQFLite

## Programming Steps
1. Add sqflite and path to dependencies
2. Run `flutter pub get`
3. Add `toMap` and `fromMap` to Quote Model class to integrate with the database
4. Start implenting a Database Singleton
    - Create a `DatabaseHelper` class with private constructor to enforce singleton behaviour
    - Create a instance attribute so the codebase can access the database through this instance
    - Implement database getter with lazy initialization
    - Create an init method to get db or create one if it doesn't exist
    - Implement create db method
    - Implement close connection method
5.  Implement CRUD operations on DB Class
    - Create (`insertQuote`)
    - Read (`getQuote`)
    - Read All (`getAllQuotes`)
    - Update (`updateQuote`)
    - Delete (`deleteQuote`)
7. Initialize state by loading quotes from db
    - If no quotes exist, then insert a sample quote
8. Implement `isLoading` state and to show loading icon (`CircularProgressIndicator`) while the data from the db is loading
9. Update the quote CRUD operations on `main.dart` to reflect on the database.
10. Add `_showErrorSnackBar` to show error feedback# Quotes-Multi-DB
