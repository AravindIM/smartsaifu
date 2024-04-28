import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Expense {
  final String title;
  final String category;
  final double amount;

  const Expense({
    required this.title,
    required this.category,
    required this.amount,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartSaifu',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
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
  final titleInputController = TextEditingController();
  final amountInputController = TextEditingController();
  final categoryInputController = TextEditingController();
  List<Expense> expenses = [];

  @override
  void dispose() {
    titleInputController.dispose();
    amountInputController.dispose();
    categoryInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          titleInputController.clear();
          amountInputController.clear();
          categoryInputController.clear();

          final expense = await openDialog();

          if (expense == null) return;

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
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "${expenses.fold(0.0, (previousValue, element) => previousValue + element.amount)}",
                      textScaler: const TextScaler.linear(5.0),
                      softWrap: false,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverList.builder(
            itemBuilder: (BuildContext context, int index) {
              return Card(
                //surfaceTintColor: Theme.of(context).colorScheme.background,
                child: ListTile(
                  leading: const Icon(
                    Icons.paid,
                    size: 50.0,
                  ),
                  title: Text(
                    overflow: TextOverflow.ellipsis,
                    expenses[index].title,
                  ),
                  subtitle: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${expenses[index].amount}",
                      textScaler: const TextScaler.linear(2.5),
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      size: 30.0,
                    ),
                    onPressed: () {
                      setState(() {
                        expenses.removeAt(index);
                      });
                    },
                  ),
                ),
              );
            },
            itemCount: expenses.length,
          ),
        ],
      ),
    );
  }

  Future<Expense?> openDialog() => showDialog<Expense>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Add Expense"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                decoration: const InputDecoration(hintText: "Title"),
                controller: titleInputController,
              ),
              TextField(
                autofocus: true,
                decoration: const InputDecoration(hintText: "Amount"),
                controller: amountInputController,
              ),
              TextField(
                autofocus: true,
                decoration: const InputDecoration(hintText: "Category"),
                controller: categoryInputController,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final amount =
                    double.tryParse(amountInputController.text) ?? 0.0;

                if (amount == 0) {
                  Navigator.of(context).pop();
                }

                final title = titleInputController.text;
                final category = categoryInputController.text;
                final expense = Expense(
                  title: title,
                  category: category,
                  amount: amount,
                );

                Navigator.of(context).pop(expense);
              },
              child: const Text("ADD"),
            ),
          ],
        ),
      );
}
