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
      home: MyHomePage(title: 'FutureProvider Example'),
    );
  }
}

// do something to generate a future
Future<String> getFuture() async {
  // use a delayed , could be an http request, any async operation
  return Future<String>.delayed(Duration(seconds: 5), () {
    // do some work here?

    // return the value
    return 'Future has completed';
  });
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({this.title});

  @override
  Widget build(BuildContext context) {
    // wrap with the FutureProvider
    return FutureProvider(
      // builder is called provides the future to the FutureProvider
      // FutureProvider waits for it to resolve or reject
      builder: (context) => getFuture(),
      // its important to always have a catchError if the future can reject
      catchError: (context, error) => 'Future Rejected',
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // a widget that depends on the Future
              MyWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

// a widget that uses the value provided by the future
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // get the value from the Provider using 'of' syntax
    String value = Provider.of<String>(context);

    return Container(
      // if the value is null, the Future is pending
      // if the value is not null, use it in a widget
      child: (value == null) ? CircularProgressIndicator() : Text(value),
    );
  }
}
