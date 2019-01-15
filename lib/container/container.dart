// for holding inherited variables

import 'package:flutter/material.dart';

class User {
  String optional;

  User(this.optional);
}

class StateContainer extends StatefulWidget {
  final Widget child;
  final User user;

  StateContainer({
    @required this.child,
    this.user,
  });

  static StateContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedStateContainer)
    as _InheritedStateContainer)
        .data;
  }

  @override
  StateContainerState createState() => new StateContainerState();
}

class StateContainerState extends State<StateContainer> {
  Map inherited;
  Map _inherited;
  var session;
  var _session;

  void updateSession(var obj){
    setState((){
      _session = obj;
    });
  }

  Object getSession(){
    return _session;
  }

  void setValue(String key, String value){
    setState((){
      _inherited.update(key, (dynamic val) => value, ifAbsent: () => value);
    });
  }

  String getValue(String key){

    if (_inherited[key] != null) {
      return  _inherited[key];
    }
    else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return new _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }
}

class _InheritedStateContainer extends InheritedWidget {
  final StateContainerState data;

  _InheritedStateContainer({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedStateContainer old) => true;
}