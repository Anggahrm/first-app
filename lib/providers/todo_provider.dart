import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/todo.dart';

class TodoProvider extends ChangeNotifier {
  List<Todo> _todos = [];
  final Uuid _uuid = const Uuid();
  static const String _storageKey = 'todos';

  List<Todo> get todos => _todos;
  List<Todo> get completedTodos => _todos.where((t) => t.isCompleted).toList();
  List<Todo> get activeTodos => _todos.where((t) => !t.isCompleted).toList();
  int get totalCount => _todos.length;
  int get completedCount => completedTodos.length;
  int get activeCount => activeTodos.length;

  Future<void> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? todosJson = prefs.getString(_storageKey);
    if (todosJson != null) {
      final List<dynamic> decoded = jsonDecode(todosJson);
      _todos = decoded.map((json) => Todo.fromJson(json)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String todosJson = jsonEncode(_todos.map((t) => t.toJson()).toList());
    await prefs.setString(_storageKey, todosJson);
  }

  Future<void> addTodo(String title) async {
    final todo = Todo(
      id: _uuid.v4(),
      title: title.trim(),
    );
    _todos.insert(0, todo);
    await _saveTodos();
    notifyListeners();
  }

  Future<void> toggleTodo(String id) async {
    final index = _todos.indexWhere((t) => t.id == id);
    if (index != -1) {
      _todos[index] = _todos[index].copyWith(
        isCompleted: !_todos[index].isCompleted,
      );
      await _saveTodos();
      notifyListeners();
    }
  }

  Future<void> deleteTodo(String id) async {
    _todos.removeWhere((t) => t.id == id);
    await _saveTodos();
    notifyListeners();
  }

  Future<void> editTodo(String id, String newTitle) async {
    final index = _todos.indexWhere((t) => t.id == id);
    if (index != -1) {
      _todos[index] = _todos[index].copyWith(title: newTitle.trim());
      await _saveTodos();
      notifyListeners();
    }
  }

  Future<void> clearCompleted() async {
    _todos.removeWhere((t) => t.isCompleted);
    await _saveTodos();
    notifyListeners();
  }
}
