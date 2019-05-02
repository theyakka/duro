/*
 * Dazza
 * Created by Yakka
 * https://theyakka.com
 *
 * Copyright (c) 2019 Yakka LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:meta/meta.dart';

import 'context.dart';

/// The responder when a route is matched by the router. When a match is successfully
/// made, the [callback] handler function will be executed. [context] is an optional,
/// global variable where you can store a value that will be passed to the handler any
/// time it is executed. [context] is defined  (one time) when you define your route
/// definition so you shouldn't use it for values that need to change between invocations.
class Handler {
  final HandlerFunc callback;
  final Context context;
  Handler({@required this.callback, this.context});
}

/// Function that will execute when a route is matched. If your route contains named
/// parameters or query parameters (via a query string) then those values will be
/// present in the parameters map. Parameters values will always be returned as a [List].
///
/// The following built-in parameters will be present:
///  - [RouteParameter.path]: the path value that was matched (what you navigated to)
///  - [RouteParameter.routePath]: the path that was assigned to the [RouteDefinition]
typedef dynamic HandlerFunc(Context context);

/// Define a route for matching. The [path] value defines how your route will be matched
/// and [handler] is the object that will respond when a match is found.
class RouteDefinition {
  RouteDefinition(this.path, {@required this.handler})
      : nestedDefinitions = <RouteDefinition>[];

  RouteDefinition.withCallback(
    this.path, {
    @required HandlerFunc callback,
    Context context,
  })  : handler = Handler(callback: callback, context: context),
        nestedDefinitions = <RouteDefinition>[];

  // the route path format you want to match against
  String path;
  // the handler that will respond if a url matches the path format
  Handler handler;
  // any nested route definitions
  List<RouteDefinition> nestedDefinitions;
}

///
class MatchResult {
  MatchResult({
    @required this.route,
    this.matchStatus = MatchStatus.match,
    this.statusMessage,
    Context context,
    this.result,
  }) : context = context ?? Context.empty();

  MatchResult.noMatch({
    Context context,
    this.result,
  })  : matchStatus = MatchStatus.noMatch,
        statusMessage = 'Unable to match route.',
        route = null,
        context = context ?? Context.empty();

  final MatchStatus matchStatus;
  final String statusMessage;
  final RouteDefinition route;
  final Context context;
  dynamic result;

  bool get wasMatched => matchStatus == MatchStatus.match;
  bool get wasNotMatched => matchStatus != MatchStatus.match;
}

/// Whether the matching operation found a match or not. This is not a simple boolean
/// because we may want to extend the matcher in the future to deal with other match
/// types.
enum MatchStatus {
  match,
  noMatch,
}

enum RouteTreeNodeType {
  component,
  parameter,
}
