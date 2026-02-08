import 'package:flutter/foundation.dart';
import '../models/expense.dart';
import '../models/expense_category.dart';
import '../models/tag.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:convert';

class ExpenseProvider with ChangeNotifier {
  final LocalStorage storage;
  // List of expenses
  List<Expense> _expenses = [];

  // List of categories
  final List<ExpenseCategory> _categories = [
    ExpenseCategory(id: '1', name: 'Project Food', isDefault: true),
    ExpenseCategory(id: '2', name: 'Project Transport', isDefault: true),
    ExpenseCategory(id: '3', name: 'Project Entertainment', isDefault: true),
    ExpenseCategory(id: '4', name: 'Project Office', isDefault: true),
    ExpenseCategory(id: '5', name: 'Project Gym', isDefault: true),
  ];

  // List of tags
  final List<Tag> _tags = [
    Tag(id: '1', name: 'Task A'),
    Tag(id: '2', name: 'Task B'),
    Tag(id: '3', name: 'Task C'),
  ];

  // Getters
  List<Expense> get expenses => _expenses;
  List<ExpenseCategory> get categories => _categories;
  List<Tag> get tags => _tags;

  ExpenseProvider(this.storage) {
    _loadExpensesFromStorage();
  }

  void _loadExpensesFromStorage() async {
    // await storage.ready;
    var storedExpenses = storage.getItem('expenses');
    if (storedExpenses != null) {
      _expenses = List<Expense>.from(
        (storedExpenses as List).map((item) => Expense.fromJson(item)),
      );
      notifyListeners();
    }
  }

  // Add an expense
  void addExpense(Expense expense) {
    _expenses.add(expense);
    _saveExpensesToStorage();
    notifyListeners();
  }

  void _saveExpensesToStorage() {
    storage.setItem(
      'expenses',
      jsonEncode(_expenses.map((e) => e.toJson()).toList()),
    );
  }

  void addOrUpdateExpense(Expense expense) {
    int index = _expenses.indexWhere((e) => e.id == expense.id);
    if (index != -1) {
      // Update existing expense
      _expenses[index] = expense;
    } else {
      // Add new expense
      _expenses.add(expense);
    }
    _saveExpensesToStorage(); // Save the updated list to local storage
    notifyListeners();
  }

  // Delete an expense
  void deleteExpense(String id) {
    _expenses.removeWhere((expense) => expense.id == id);
    _saveExpensesToStorage(); // Save the updated list to local storage
    notifyListeners();
  }

  // Add a category
  void addCategory(ExpenseCategory category) {
    if (!_categories.any((cat) => cat.name == category.name)) {
      _categories.add(category);
      notifyListeners();
    }
  }

  // Delete a category
  void deleteCategory(String id) {
    _categories.removeWhere((category) => category.id == id);
    notifyListeners();
  }

  // Add a tag
  void addTag(Tag tag) {
    if (!_tags.any((t) => t.name == tag.name)) {
      _tags.add(tag);
      notifyListeners();
    }
  }

  // Delete a tag
  void deleteTag(String id) {
    _tags.removeWhere((tag) => tag.id == id);
    notifyListeners();
  }

  void removeExpense(String id) {
    _expenses.removeWhere((expense) => expense.id == id);
    _saveExpensesToStorage(); // Save the updated list to local storage
    notifyListeners();
  }
}
