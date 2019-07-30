# ProviderX

In the Flutter ecosphere, the [Provider package](https://pub.dev/packages/provider), created by [Remi Rousselet](https://github.com/rrousselGit) and maintained by him and the Flutter team, 
has been put adopted by Google as one of the best approaches to practical state 
management for Flutter applications. The Provider package is now used internally 
by the Google Flutter group as well as many other developers and teams. 
This article attempts to provide examples of basic Provider usage and app architecture. 

This article attempts to provide simple, straightfoward examples of the major
 features of Provider and how to use them. There are other examples online but I found
 most of them to be a bit complex, hiding the gist of how to use the Provider(s). 
 
 I am a relatively recent (and enthusiastic) adopter of Flutter for mobile apps. If the examples 
 I present are not canonical, missing something, or just plain wrong, 
 then please raise an issue so I can correct it.

## Basics

The Provider package is a dependency injection system for Flutter widgets. It allows a Widget to expose state 
that becomes available from that Widget to any Widget further down the widget tree. It builds on
InheritedWidget and simplifies the use cases. It contains several variations that support UI updates
when the data changes. With all that it becomes an alternative state manangment tool to 
StatefulWidget, BLOC, Redux, Rx and others. 


The [Provider API](https://pub.dev/documentation/provider/latest/) documents six different providers that
are used depending on the situation and use case. A lot of the following is paraphrased from the API docs.

In the following sections, 'value' is used generically. It could be an atomic value such as a string or int, 
but it could be a complex object. The Provider documentation refers to 'value' and 'model' kind of
interchangeably.

Each of the following sections has a link to a complete example app. The 'Usage' section is 
just an outline of how to use and might not be complete. See the complete example app for
a working solution.

## Provider<T> Widget

This widget provides a value to the widget tree, and manages the value's lifecycle. It intends to eliminate
the need for a StatefulWidget by providing a way to instantiate a value, provide it to the Widget tree and dispose
it when the Widget is removed.  It doesn't provide a way to update based on changes in the value. It is really
a pure dependency injection of a static (but maybe complex) model.

This provider is a one-shot. It provides the value to the widget tree once.

### Complete Example App

[Basic Provider Example](https://github.com/dmh2000/ProviderX/tree/master/providerapp)

### Usage (straight from the API doc)

```dart
class Model {
  // if the model needs a dispose method
  void dispose() {}
}

class Stateless extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<Model>(
      // instantiate the model
      builder: (context) =>  Model(),
      // dispose it when the widget is removed
      dispose: (context, value) => value.dispose(),
      child: ...,
    );
  }
}
```


## ChangeNotifierProvider<T>

This widget exposes a 'value' to the widget tree, allows them to listen for changes and rebuild when
notified of a change. It automatically disposes the value when removed from the tree.  A good 
video demonstrating usage of ChangeNotifierProvider is in the middle third of  [Pragmatic State Management in Flutter (Google I/O'19)](https://youtu.be/d_m5csmrf7I).

The following example is a modified version of the flutter sample app. Its the most simplistic usage of ChangeNotifierProvider. ChangeNotifierProvider could be used for more complex scenarios such as
a model that is updated by a network request.  This version of Provider seems like it is enough to 
do almost anything that a Provider needs to do, which is expose the model and react to changes. However there are a couple of other Providers that make it a bit simpler when dealing with Futures or Streams.

This provider can update whenever the model changes. So it can be used for things that update periodically.

### Usage 

#### Complete Example App

[Counter App Using ChangeNotifyProvider](https://github.com/dmh2000/ProviderX/tree/master/changenotifyapp)

#### Outline of Usage

** this is a summary. check out the example for a working app **  

```dart
// the model must extend ChangeNotifier
class Model extends ChangeNotifier{
  int counter;

  Model() : counter = 0;

  // model exposes a method to update 
  void changeSomething() {
    // ... change something in the model
    ++counter;

    // notify listeners to rebuild
    NotifyListeners();
  }

  // if the model needs a dispose method
  void dispose() {}
}

class Stateless extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Model>(
      // instantiate the model 
      // listens to the Model for changes
      // Model is automatically disposed
      builder: (context) =>  Model(),
      child: Dependent(),
    );
  }
}

class Dependent extends StatelessWidget {
  // dependent is rebuilt when the model is changed
  @override
  Widget build(BuildContext context) {
    // get a reference to the model
    Model model = Provider.of<Model>(context);

    // return a widget that uses the model data
    return Column(
      children: [
        Text(model.counter.toString()),
        Button(
          onPressed: model.changeSomething
        )
      ]
    )
  }
}
```

## FutureProvider<T>

This widget exposes a Future to the widget tree. In this case suppose you
do something to create a Future that will resolve asynchronously. This widget
will rebuild when the Future resolves, and can use the value from the
Future to do something.

An example could be a Future generated from an HTTP request to a REST api. For
this example a Future is generated by a time delay. It could be anything
that creates a Future to wait on. 

This is a one-shot. Once the future completes the value is there. 
### Usage 

#### Complete Example App

[App Using FutureProvider](https://github.com/dmh2000/ProviderX/tree/master/futureproviderapp)

#### Outline of Usage

** this is a summary. check out the example for a working app **  

```dart

// do something to generate a future
Future<Model> getFuture() async {
  // do something that generates a Future.
  // return the future
  // ...
  return Future<Model> model;
}

// ... stateless widget build method
class MyWidget extends StatelessWidget {
  // in this example the Future is produced in the build method so
  // you will get a new one every time this widget rebuilds
  Widget build(BuildContext context) {
    // wrap with the FutureProvider
    return FutureProvider(
      // builder provides the future to the FutureProvider
      // FutureProvider waits for it to resolve or reject
      // the value produced is null when the future is pending,
      // the value is from the future when it resolves
      // the value is from catchError if the future rejects
      builder: (context) => getFuture(),
      // its important to always have a catchError if the future can reject
      catchError: (context, error) => 'Future Rejected',
      // value is now available in the subtree
      child: WidgetThatDependsOnTheFuture(),
    );
  }
}

// a widget that uses the value provided by the future
class WidgetThatDependsOnTheFuture extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // get the value from the Provider using 'of' syntax
    Model value = Provider.of<Model>(context);

    return Container(
      // if the value is null, the Future is pending, show something indicating that
      // if the value is not null, use it in a widget
      child: (value == null) ? CircularProgressIndicator() : Text(value.toString()),
    );
  }
}
```