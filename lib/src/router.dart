/*
 * Dazza
 * Created by Yakka
 * http://theyakka.com
 *
 * Copyright (c) 2018 Yakka, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'definitions.dart';
import 'parameters.dart';
import 'tree.dart';

class Router {
  static final String rootPath = "/";
  final RouteTree _tree = new RouteTree();

  /// The [Handler] that will be executed when a passed path cannot be matched to
  /// any defined routes.
  final Handler noMatchHandler;

  Router({this.noMatchHandler});

  /// Adds a [RouteDefinition] for matching.
  void addRoute(RouteDefinition definition) => _tree.addRoute(definition);

  /// Execute the route matcher and then call its defined [Handler] if [path]
  /// matches a defined [RouteDefinition]. If you pass a [context] value then
  /// it will be passed along to the handler and any global [Handler.context]
  /// value will be ignored.
  MatchResult handle(String path, {Parameters parameters, dynamic context}) =>
      _tree.matchRouteAndHandle(
        path,
        parameters: parameters,
        context: context,
        noMatchHandler: noMatchHandler,
      );

  /// Call the route matcher directly. This is useful if you're building your
  /// own custom routing logic otherwise you probably won't use it.
  MatchResult match(String path, {Parameters parameters, dynamic context}) =>
      _tree.matchRoute(
        path,
        parameters: parameters,
        context: context,
      );

  /// Prints debugging information about the [RouteTree]
  void printTree() => _tree.printTree();
}
