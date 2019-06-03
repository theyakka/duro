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
import 'handlers.dart';

/// The default value for the root path.
final String defaultRootPath = '/';

/// The character that denotes the start of a query string.
final String queryPrefix = '?';

/// The character that separates the components of a path string.
final String pathSeparator = '/';

/// Define a route for matching. The [path] value defines how your route will
/// be matched and [handler] is the object that will respond if a match is
/// found.
class RouteDefinition<T> {
  ///
  RouteDefinition(this.path, {@required this.callback, this.context})
      : nestedDefinitions = <RouteDefinition>[];

  ///
  RouteDefinition.withCallback(
    this.path, {
    @required this.callback,
    this.context,
  }) : nestedDefinitions = <RouteDefinition>[];

  /// the route path format you want to match against
  String path;

  /// the handler that will respond if a url matches the path format
  HandlerFunc callback;

  /// any nested route definitions
  List<RouteDefinition> nestedDefinitions;

  /// Global context values attached to the route. These values will be passed
  /// to the callback every time the route is executed.
  Context context;
}

///
class MatchResult {
  ///
  MatchResult({
    @required this.route,
    this.matchStatus = MatchStatus.match,
    this.statusMessage,
    Context context,
    this.result,
  }) : context = context ?? Context.empty();

  MatchResult.matched({
    Context context,
    @required this.route,
    this.result,
  })  : matchStatus = MatchStatus.match,
        statusMessage = null,
        context = context ?? Context.empty();

  ///
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

/// Whether the matching operation found a match or not. This is not a simple
/// [bool] because we may want to extend the matcher in the future to deal with
/// other match types.
enum MatchStatus {
  /// There was a match
  match,

  /// There was no match
  noMatch,
}

/// The type of node in the route tree
enum RouteTreeNodeType {
  /// The node is a path component
  component,

  /// The node is a named parameter
  parameter,

  /// The node is a wildcard component
  wildcard,
}
