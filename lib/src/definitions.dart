/*
 * Dazza
 * Created by Yakka
 * http://theyakka.com
 *
 * Copyright (c) 2018 Yakka, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:meta/meta.dart';

import 'parameters.dart';

/// The responder when a route is matched by the router. When a match is successfully
/// made, the [callback] handler function will be executed. [context] is an optional,
/// global variable where you can store a value that will be passed to the handler any
/// time it is executed. [context] is defined  (one time) when you define your route
/// definition so you shouldn't use it for values that need to change between invocations.
class Handler {
  final HandlerFunc callback;
  final dynamic context;
  Handler({@required this.callback, this.context});
}

/// Function that will execute when a route is matched. If your route contains named
/// parameters or query parameters (via a query string) then those values will be
/// present in the parameters map. Parameters values will always be returned as a [List].
///
/// The following built-in parameters will be present:
///  - [RouteParameter.path]: the path value that was matched (what you navigated to)
///  - [RouteParameter.routePath]: the path that was assigned to the [RouteDefinition]
typedef dynamic HandlerFunc(Parameters parameters, dynamic context);

/// Define a route for matching. The [path] value defines how your route will be matched
/// and [handler] is the object that will respond when a match is found.
class RouteDefinition {
  // the route path format you want to match against
  String path;
  // the handler that will respond if a url matches the path format
  Handler handler;

  RouteDefinition(this.path, {@required this.handler});
  RouteDefinition.withCallback(
    this.path, {
    @required HandlerFunc callback,
    dynamic context,
  }) : handler = Handler(callback: callback, context: context);
}

///
class MatchResult {
  final MatchStatus matchType;
  final String statusMessage;
  final RouteDefinition route;
  final Parameters parameters;
  final dynamic context;
  dynamic result;

  MatchResult({
    @required this.route,
    this.matchType = MatchStatus.match,
    this.statusMessage,
    Parameters parameters,
    this.context,
  }) : this.parameters = parameters ?? Parameters();
  MatchResult.noMatch({Parameters parameters, dynamic context})
      : this.matchType = MatchStatus.noMatch,
        this.statusMessage = "Unable to match route.",
        this.route = null,
        this.parameters = parameters ?? Parameters(),
        this.context = context;

  bool get wasMatched => matchType == MatchStatus.match;
  bool get wasNotMatched => matchType != MatchStatus.match;
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
