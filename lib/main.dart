import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartSaifu',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainPage(title: 'SmartSaifu'),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});
  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final textInputController = TextEditingController();
  List<int> expenses = [];

  @override
  void dispose() {
    textInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          textInputController.clear();

          final expense = await openDialog() ?? 0;
          if (expense == 0) return;

          setState(() {
            expenses.add(expense);
          });
        },
        child: const Icon(Icons.add),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            stretch: true,
            pinned: true,
            floating: true,
            stretchTriggerOffset: 300,
            expandedHeight: 300.0,
            title: Expanded(
              child: Center(
                child: Text(
                  widget.title,
                  style: const TextStyle(fontFamily: "Roboto", fontSize: 30.0),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Center(
                child: Text(
                  "${expenses.fold(0, (previousValue, element) => previousValue + element)}",
                  textScaler: const TextScaler.linear(5.0),
                ),
              ),
            ),
          ),
          SliverList.builder(
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Center(
                  child: Text(
                    "${expenses[index]}",
                    textScaler: const TextScaler.linear(3.0),
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      expenses.removeAt(index);
                    });
                  },
                ),
              );
            },
            itemCount: expenses.length,
          ),
        ],
      ),
    );
  }

  Future<int?> openDialog() => showDialog<int>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Add Expense"),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(hintText: "Enter the amount"),
            controller: textInputController,
          ),
          actions: [
            TextButton(
              onPressed: () {
                final value = int.tryParse(textInputController.text) ?? 0;
                Navigator.of(context).pop(value);
              },
              child: const Text("ADD"),
            ),
          ],
        ),
      );
}
