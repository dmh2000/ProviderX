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
      home: ChangeNotifierProvider(
        // instantiate a counter object
        // listen to it for changes
        // propagate changes down the widget tree
        // dispose the counter when done
        builder: (context) => Counter(),
        child: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

// a widget inherting the model
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
              'You have pushed the button this many times:',
            ),
            Text(
              // use the value from the counter model
              '${counter.value}',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // use the increment method from the Counter instead of local state
        onPressed: counter.incrementCount,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

// a model extending ChangeNotifier and exposing a 'value' of some sort
class Counter extends ChangeNotifier {
  int value;

  Counter() : value = 0;

  void incrementCount() {
    ++value;
    notifyListeners();
  }

  dispose() {
    super.dispose();
    print('counter disposed');
  }
}
