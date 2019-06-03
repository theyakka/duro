/*
 * Dazza
 * Created by Yakka
 * https://theyakka.com
 *
 * Copyright (c) 2019 Yakka LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:dazza/dazza.dart';
import 'package:meta/meta.dart';

import 'definitions.dart';
import 'handlers.dart';
import 'observers.dart';
import 'tree.dart';

///
class Router {
  /// Creates a new [Router] instance
  Router({this.noMatchHandler});

  final RouteTree _tree = RouteTree();
  final List<LifecycleObserver> _lifecycleObservers = <LifecycleObserver>[];

  /// The [Handler] that will be executed when a passed path cannot be matched
  /// to any defined routes.
  final HandlerFunc noMatchHandler;

  /// Defines a new [RouteDefinition] via a [HandlerFunc]
  @optionalTypeArgs
  RouteDefinition defineFunc<RT>(String path, HandlerFunc<RT> handlerFunc) {
    final definition = RouteDefinition<RT>(path, callback: handlerFunc);
    addRoute(definition);
    return definition;
  }

  /// Defines a new [RouteDefinition] via a [Handler]
  @optionalTypeArgs
  RouteDefinition defineHandler<RT>(String path, HandlerFunc<RT> callback) {
    final definition = RouteDefinition<RT>(path, callback: callback);
    addRoute(definition);
    return definition;
  }

  /// Adds a [RouteDefinition] for matching.
  void addRoute(RouteDefinition definition) => _tree.addRoute(definition);

  /// Execute the route matcher and then call its defined [Handler] if [path]
  /// matches a defined [RouteDefinition]. If you pass a [context] value then
  /// it will be passed along to the handler and any global [Handler.context]
  /// value will be ignored.
  MatchResult handle(String path, {Context context}) =>
      _tree.matchRouteAndHandle(
        path,
        context: context,
        noMatchHandler: noMatchHandler,
      );

  /// Call the route matcher directly. This is useful if you're building your
  /// own custom routing logic otherwise you probably won't use it.
  MatchResult match(String path, {Context context}) => _tree.matchRoute(
        path,
        context: context,
      );

  /// Registers a lifecycle observer
  void addLifecycleObserver(LifecycleObserver observer) =>
      _lifecycleObservers.add(observer);

  /// Unregisters a lifecycle observer
  void removeLifecycleObserver(LifecycleObserver observer) =>
      _lifecycleObservers.remove(observer);

  /// Prints debugging information about the [RouteTree]
  void printTree() => _tree.printTree();
}
