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

          if (expense != null) {
            setState(() {
              expenses.add(expense);
            });
          }
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
              final icon = getCategoryIcon(expenses[index].category);

              return Card(
                //surfaceTintColor: Theme.of(context).colorScheme.background,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor:
                        Theme.of(context).colorScheme.inversePrimary,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          icon,
                          color: Theme.of(context).colorScheme.onInverseSurface,
                          size: 50.0,
                        ),
                      ),
                    ),
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

  IconData getCategoryIcon(String category) {
    switch (category) {
      case "food":
        return Icons.restaurant;
      case "travel":
        return Icons.flight;
      case "movie":
        return Icons.theaters;
      case "shopping":
        return Icons.shopping_cart;
      case "taxi":
        return Icons.local_taxi;
      case "sports":
        return Icons.sports_soccer;
      case "game":
        return Icons.sports_esports;
      case "plane":
        return Icons.flight;
      case "bus":
      case "train":
        return Icons.train;
      case "electricity":
        return Icons.bolt;
      case "fuel":
        return Icons.local_gas_station;
      case "rent":
        return Icons.home;
      case "tv":
      case "cable":
        return Icons.tv;
      case "intenet":
        return Icons.wifi;
      case "water":
        return Icons.water_drop;
      case "mobile":
        return Icons.smartphone;
      case "medical":
      case "health":
      case "hospital":
      case "doctor":
        return Icons.local_hospital;
      case "gift":
        return Icons.redeem;
      case "liquor":
      case "drinks":
        return Icons.liquor;
      case "smoking":
      case "cigarette":
      case "smoke":
        return Icons.smoking_rooms;
      case "gas":
        return Icons.local_fire_department;
      default:
        return Icons.receipt;
    }
  }

  Future<Expense?> openDialog() => showDialog<Expense?>(
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
                keyboardType: TextInputType.number,
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
                final title = titleInputController.text;
                final category = categoryInputController.text.toLowerCase();

                if (amount == 0 || title.isEmpty || category.isEmpty) {
                  return;
                }
                final expense = Expense(
                  title: title,
                  category: category,
                  amount: amount,
                );

                Navigator.of(context).pop(expense);
              },
              child: const Text("ADD"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("CANCEL"),
            ),
          ],
        ),
      );
}
