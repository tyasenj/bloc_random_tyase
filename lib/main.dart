import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

// Class RandomNumberBloc yang sudah dibuat sebelumnya
class RandomNumberBloc {
  final _generateRandomController = StreamController<void>();
  final _randomNumberController = StreamController<int>();

  Sink<void> get generateRandom => _generateRandomController.sink;
  Stream<int> get randomNumber => _randomNumberController.stream;

  RandomNumberBloc() {
    _generateRandomController.stream.listen((_) {
      final random = Random().nextInt(10);
      _randomNumberController.sink.add(random);
    });
  }

  void dispose() {
    _generateRandomController.close();
    _randomNumberController.close();
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const RandomScreen(),
    );
  }
}

class RandomScreen extends StatefulWidget {
  const RandomScreen({super.key});

  @override
  State<RandomScreen> createState() => _RandomScreenState();
}

class _RandomScreenState extends State<RandomScreen> {
  late RandomNumberBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = RandomNumberBloc(); // Initialize the RandomNumberBloc
  }

  @override
  void dispose() {
    bloc.dispose(); // Dispose the bloc when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Random Number Generator')),
      body: Center(
        child: StreamBuilder<int>(
          stream: bloc.randomNumber, // Listen to the random number stream
          initialData: 0,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(
                snapshot.data.toString(),
                style: const TextStyle(fontSize: 50),
              );
            } else if (snapshot.hasError) {
              return const Text('Error generating random number');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          bloc.generateRandom.add(null); // Trigger the random number generation
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
