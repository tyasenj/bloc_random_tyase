import 'dart:async';
import 'dart:math';

class RandomNumberBloc {
  // StreamController untuk input event
  final _generateRandomController = StreamController<void>();
  // StreamController untuk output random number
  final _randomNumberController = StreamController<int>();

  // Sink untuk mengirimkan event generateRandom
  Sink<void> get generateRandom => _generateRandomController.sink;

  // Stream untuk mendengarkan angka acak
  Stream<int> get randomNumber => _randomNumberController.stream;

  // Constructor yang mendengarkan stream dan menghasilkan angka acak
  RandomNumberBloc() {
    _generateRandomController.stream.listen((_) {
      final random = Random().nextInt(10); // Angka acak antara 0 dan 9
      _randomNumberController.sink.add(
        random,
      ); // Menambahkan angka acak ke stream
    });
  }

  // Method untuk menutup StreamControllers
  void dispose() {
    _generateRandomController.close();
    _randomNumberController.close();
  }
}
