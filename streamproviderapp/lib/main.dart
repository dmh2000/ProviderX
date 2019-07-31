import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StreamProvider',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // wrap the child with StreamProvider somewhere above the dependent widgets
      home: StreamProvider<String>(
          // return a Stream to the builder and StreamProvider listens on it
          // the Provider exposes the stream's value to the widget tree
          builder: (BuildContext context) => getStream(), // see function below
          // catchError exposes an error object if the Stream fails
          catchError: (BuildContext context, Object error) => error.toString(),
          // initialData is what is exposed before the stream starts
          initialData: '0',
          child: MyHomePage(title: 'StreamProvider Example')),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({this.title});

  @override
  Widget build(BuildContext context) {
    // the StreamProvider exposes the value it emits to the widget tree
    // in this case the value is a String, could be anything
    String value = Provider.of<String>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Count',
              style: Theme.of(context).textTheme.display1,
            ),
            Text(
              // use the value emitted by the stream
              value,
              style: Theme.of(context).textTheme.display1,
            )
          ],
        ),
      ),
    );
  }
}

// a function that creates a Stream and returns it, in this case a periodic stream.
// this is just an example.  it can be any type of stream created somewhere
// in the application
Stream<String> getStream() {
  // stream.periodic is a member of dart:async
  return Stream<String>.periodic(
    Duration(
      seconds: 1,
    ),
    // the periodic stream works by calling the callback with
    // integer count increasing by 1 every period
    (count) {
      // emit the count itself as a string, could be anything here
      return count.toString();
    },
  );
}
