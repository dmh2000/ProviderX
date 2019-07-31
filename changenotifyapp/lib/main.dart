import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // wrap widget tree with ChangeNotifierProvider
      home: ChangeNotifierProvider(
        // builder instantiates a Counter object
        // the provider listens for changes from Counter
        // and propagates changes down the widget tree
        builder: (context) => Counter(),
        child: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

// a widget inheriting the model
class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({this.title});

  @override
  Widget build(BuildContext context) {
    // get a reference to the counter using the 'of' syntax
    Counter counter = Provider.of<Counter>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              // use a method from the model to set the text
              counter.isActive() ? 'click to stop' : 'click to start',
              style: Theme.of(context).textTheme.display1,
            ),
            Text(
              // show the value from the counter model
              '${counter.value}',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // start and stop counting by accessing a method in the model
        onPressed: counter.startCount,
        tooltip: counter.isActive() ? 'Stop' : 'Start',
        child: Icon(Icons.add),
      ),
    );
  }
}

// a model extending ChangeNotifier and exposing a 'value' of some sort
class Counter extends ChangeNotifier {
  int value;
  Timer t;
  Counter() : value = 0;

  // start and stop a periodic timer that changes the value
  // and calls notifyListeners
  void startCount() {
    if (t != null) {
      // stop counting
      // cancel the timer
      t.cancel();
      t = null;
    } else {
      // start counting once per second
      t = Timer.periodic(Duration(seconds: 1), (timer) {
        // increment the value
        ++value;
        // notify the provider to rebuild its widget tree
        notifyListeners();
      });
    }
    // notify here to get update of isActive
    notifyListeners();
  }

  bool isActive() {
    return t != null;
  }

  @override
  dispose() {
    super.dispose();

    // cancel the timer on dispose
    if (t != null) {
      t.cancel();
    }
  }
}
