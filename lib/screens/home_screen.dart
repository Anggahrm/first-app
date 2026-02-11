import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';
import 'add_todo_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
        actions: [
          Consumer<TodoProvider>(
            builder: (_, provider, __) {
              if (provider.completedCount == 0) return const SizedBox.shrink();
              return TextButton(
                onPressed: () => _showClearDialog(context, provider),
                child: Text(
                  'Clear (${provider.completedCount})',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<TodoProvider>(
        builder: (_, provider, __) {
          if (provider.todos.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.checklist_rounded, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No todos yet!',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap + to add your first todo',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              _buildStatsBar(provider, context),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: provider.todos.length,
                  itemBuilder: (context, index) {
                    final todo = provider.todos[index];
                    return _TodoTile(todo: todo);
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addTodo(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatsBar(TodoProvider provider, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            label: 'Total',
            count: provider.totalCount,
            icon: Icons.list_rounded,
          ),
          _StatItem(
            label: 'Active',
            count: provider.activeCount,
            icon: Icons.pending_actions_rounded,
          ),
          _StatItem(
            label: 'Done',
            count: provider.completedCount,
            icon: Icons.task_alt_rounded,
          ),
        ],
      ),
    );
  }

  void _addTodo(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddTodoScreen()),
    );
  }

  void _showClearDialog(BuildContext context, TodoProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Completed'),
        content: Text('Delete ${provider.completedCount} completed todos?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.clearCompleted();
              Navigator.pop(ctx);
            },
            child: Text(
              'Clear',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final int count;
  final IconData icon;

  const _StatItem({
    required this.label,
    required this.count,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20),
        const SizedBox(height: 4),
        Text(
          '$count',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class _TodoTile extends StatelessWidget {
  final Todo todo;

  const _TodoTile({required this.todo});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(todo.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        context.read<TodoProvider>().deleteTodo(todo.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Todo deleted'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                context.read<TodoProvider>().addTodo(todo.title);
              },
            ),
          ),
        );
      },
      child: ListTile(
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (_) {
            context.read<TodoProvider>().toggleTodo(todo.id);
          },
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
            color: todo.isCompleted ? Colors.grey : null,
          ),
        ),
        onTap: () => _editTodo(context),
      ),
    );
  }

  void _editTodo(BuildContext context) {
    final controller = TextEditingController(text: todo.title);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Todo'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Enter todo title'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                context.read<TodoProvider>().editTodo(todo.id, controller.text);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
