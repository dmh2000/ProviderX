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
      home: MyHomePage(title: 'Provider Example Home Page'),
    );
  }
}

// define whatever value model you need
// doesn't have to be a new class, could be a String or other type
class Value {
  final String text = 'value from provider';
  Value();

  // handle dispose as needed
  dispose() {}
}

class MyHomePage extends StatelessWidget {
  final String title;
  final Value value = Value();

  MyHomePage({this.title});
  @override
  Widget build(BuildContext context) {
    // an instance of the mode needs to come from somewhere
    // in this case a new Value is instantiated when the widget is constructed
    // wrap an upper level widget with Provider
    return Provider(
      // builder sets the value to be propagated down the widget tree
      // it can do whatever needed to initialize the value
      // in this case its just a final member of the object
      builder: (context) => value,
      // add a disposer. dispose is not automatic with Provider
      dispose: (context, value) => value.dispose(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MyWidget1(),
              MyWidget2(),
            ],
          ),
        ),
      ),
    );
  }
}

// a widget somewhere down the widget tree can get a
// reference to the model from the Provider using the 'of' syntax
class MyWidget1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // get the instance of Model from the provder
    Value value = Provider.of<Value>(context);
    return Container(
      child: Text(
        // use it
        value.text,
      ),
    );
  }
}

// a widget somewhere down the widget tree can get a
// reference to the model from the Provider by
// wrapping with the Consumer widget
class MyWidget2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // wrap with the Consumer
    return Consumer<Value>(
      // builder gets the value reference and constructs the subtree
      builder: (context, value, child) {
        return Column(
          children: <Widget>[
            Text(value.text),
            child // child from below, doesn't depend on value
          ],
        );
      },
      // this child is passed to the builder
      // used when a subtree doesn't depend on the value
      // avoids rebuilds of non-dependent subtree
      child: Text("I don't depend on the value"),
    );
  }
}
