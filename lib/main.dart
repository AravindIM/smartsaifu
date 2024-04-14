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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: openDialog,
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
            flexibleSpace: const FlexibleSpaceBar(
              background: Center(
                child: Text(
                  "2100",
                  textScaler: TextScaler.linear(5.0),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return ListTile(
                  title: Center(
                    child: Text(
                      "${index * 10 + 10}",
                      textScaler: const TextScaler.linear(3.0),
                    ),
                  ),
                );
              },
              childCount: 20,
            ),
          ),
        ],
      ),
    );
  }

  Future openDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Add Expense"),
          content: const TextField(
            autofocus: true,
            decoration: InputDecoration(hintText: "Enter the amount"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("ADD"),
            ),
          ],
        ),
      );
}
