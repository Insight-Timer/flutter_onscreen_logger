import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_onscreen_logger/flutter_onscreen_logger.dart';
import 'package:word_generator/word_generator.dart';

void main() {
  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();

    runApp(const MyApp());
  }, (error, stack) {
    OnScreenLog.onError();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: const MyHomePage(title: 'Flutter Demo Home Page'),
          ),
          LoggerOverlayWidget(),
        ],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  ///A method that will generate few random log items with different types
  Future<void> _generateRandomLogItems({int numberOfItems = 20}) async {
    final wordGenerator = WordGenerator();
    for (int i = 0; i < numberOfItems; i++) {
      Random random = Random();
      await Future.delayed(
        const Duration(
          milliseconds: 800,
        ),
      );
      switch (i % 4) {
        case 0:
          {
            ///adds info log message
            OnScreenLog.i(
              title: wordGenerator.randomSentence(random.nextInt(5) + 5),
              message: wordGenerator.randomSentence(random.nextInt(50) + 50),
            );
          }
        case 1:
          {
            ///adds error log message
            OnScreenLog.e(
              title: wordGenerator.randomSentence(random.nextInt(5) + 5),
              message: wordGenerator.randomSentence(random.nextInt(50) + 50),
            );
          }
        case 2:
          {
            ///adds warning log message
            OnScreenLog.w(
              title: wordGenerator.randomSentence(random.nextInt(5) + 5),
              message: wordGenerator.randomSentence(random.nextInt(50) + 50),
            );
          }
        case 3:
          {
            ///adds success log message
            OnScreenLog.s(
              title: wordGenerator.randomSentence(random.nextInt(5) + 5),
              message: wordGenerator.randomSentence(random.nextInt(50) + 50),
            );
          }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _generateRandomLogItems(numberOfItems: 10);
          },
          child: const Text('Generate Example Log Messages'),
        ),
      ),
    );
  }
}
