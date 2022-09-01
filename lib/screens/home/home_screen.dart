import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:todo_flutter_firebase/models/todo.dart';
import 'package:todo_flutter_firebase/screens/root/root_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userId;

  const HomeScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  final TextEditingController _textEditingController = TextEditingController();

  List<Todo> _todoList = [];

  late Query _todoQuery;

  late StreamSubscription<DatabaseEvent> _onTodoAddSubcription;
  late StreamSubscription<DatabaseEvent> _onTodoChangeSubcription;

  @override
  void initState() {
    super.initState();

    _todoList = [];

    _todoQuery = _database
        .ref()
        .child('todo')
        .orderByChild('userId')
        .equalTo(widget.userId);

    _onTodoAddSubcription = _todoQuery.onChildAdded.listen(onEntryAdd);

    _onTodoChangeSubcription = _todoQuery.onChildChanged.listen(onEntryChanged);
  }

  @override
  void dispose() {
    _onTodoAddSubcription.cancel();
    _onTodoChangeSubcription.cancel();
    super.dispose();
  }

  onEntryAdd(DatabaseEvent event) {
    setState(() {
      _todoList.add(Todo.fromSnapshot(event.snapshot));
    });
  }

  onEntryChanged(DatabaseEvent event) {
    var currentTodo =
        _todoList.singleWhere((entry) => entry.key == event.snapshot.key);

    setState(() {
      _todoList[_todoList.indexOf(currentTodo)] =
          Todo.fromSnapshot(event.snapshot);
    });
  }

  void signOut() async {
    try {
      await _auth.signOut();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const RootScreen(),
        ),
      );
    } catch (e) {
      print('Error e');
    }
  }

  addNewTodo(String todoItem) {
    if (todoItem.isNotEmpty) {
      Todo todo = Todo(todoItem, false, widget.userId);
      _database.ref().child('todo').push().set(todo.toJson());
      _textEditingController.text = '';
    }
  }

  updateTodo(Todo todo) {
    todo.completed = !todo.completed;

    if (todo.key != null) {
      _database.ref().child('todo').child(todo.key!).set(todo.toJson());
    }
  }

  deleteTodo(Todo todo) {
    _database.ref().child('todo').child(todo.key!).remove();
  }

  showAddTodoDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Agregar TODO',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: _textEditingController,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'TODO'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              addNewTodo(_textEditingController.text.toString());
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        actions: [
          IconButton(
            onPressed: signOut,
            icon: const Icon(
              Icons.logout,
            ),
          )
        ],
      ),
      body: showTodoList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddTodoDialog(context);
        },
        tooltip: 'Agregar TODO',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget showTodoList() {
    if (_todoList.isNotEmpty) {
      return ListView.builder(
        itemCount: _todoList.length,
        itemBuilder: (BuildContext context, int index) {
          Todo todo = _todoList[index];
          return Dismissible(
            key: Key(todo.key!),
            background: Container(
              color: Colors.red,
            ),
            onDismissed: (direction) {
              deleteTodo(todo);
            },
            child: ListTile(
              title: Text(todo.subject),
              trailing: IconButton(
                icon: todo.completed
                    ? const Icon(
                        Icons.done_outline,
                        color: Colors.green,
                        size: 20.0,
                      )
                    : const Icon(
                        Icons.done,
                        color: Colors.grey,
                        size: 20.0,
                      ),
                onPressed: () {
                  updateTodo(todo);
                },
              ),
            ),
          );
        },
      );
    } else {
      return const Center(
        child: Text(
          'No tienes tareas',
          style: TextStyle(fontSize: 35.0),
        ),
      );
    }
  }
}
