import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stateful Lab',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CounterWidget(),
    );
  }
}

class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter = 0;

  final TextEditingController _controller = TextEditingController();
  final List<int> history = [];

  // ---------- helper ----------
  void saveHistory() {
    history.add(_counter);
  }

  Color get counterColor {
    if (_counter == 0) return Colors.red;
    if (_counter > 50) return Colors.green;
    return Colors.black;
  }

  // ---------- actions ----------
  void increment() {
    if (_counter < 100) {
      setState(() {
        saveHistory();
        _counter++;
      });
    }
  }

  void decrement() {
    if (_counter > 0) {
      setState(() {
        saveHistory();
        _counter--;
      });
    }
  }

  void reset() {
    setState(() {
      saveHistory();
      _counter = 0;
    });
  }

  void undo() {
    if (history.isNotEmpty) {
      setState(() {
        _counter = history.removeLast();
      });
    }
  }

  void setCustomValue() {
    int? value = int.tryParse(_controller.text);

    if (value == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter a valid number")));
      return;
    }

    if (value > 100) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Limit Reached! Max = 100")));
      return;
    }

    if (value < 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Cannot be negative")));
      return;
    }

    setState(() {
      saveHistory();
      _counter = value;
    });
  }

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Interactive Counter Dashboard')),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // COUNTER DISPLAY
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$_counter',
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: counterColor,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // SLIDER
            Slider(
              min: 0,
              max: 100,
              value: _counter.toDouble(),
              onChanged: (double value) {
                setState(() {
                  saveHistory();
                  _counter = value.toInt();
                });
              },
            ),

            const SizedBox(height: 15),

            // BUTTONS ROW
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(onPressed: decrement, child: const Text("-1")),
                ElevatedButton(onPressed: increment, child: const Text("+1")),
                ElevatedButton(onPressed: reset, child: const Text("Reset")),
                ElevatedButton(onPressed: undo, child: const Text("Undo")),
              ],
            ),

            const SizedBox(height: 25),

            // TEXTFIELD
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter custom value (0 - 100)",
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: setCustomValue,
              child: const Text("Set Value"),
            ),
          ],
        ),
      ),
    );
  }
}
