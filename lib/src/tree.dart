/*
 * Dazza
 * Created by Yakka
 * https://theyakka.com
 *
 * Copyright (c) 2019 Yakka LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:dazza/dazza.dart';

import 'context.dart';
import 'definitions.dart';
import 'handlers.dart';
import 'parameters.dart';
import 'tree_definitions.dart';

/// Used for storing and matching
/// TODO
class RouteTree {
  /// The current route tree nodes. These are created
  /// TODO
  final List<RouteTreeNode> _nodes = <RouteTreeNode>[];

  // Fields
  bool _hasDefaultRoute = false;

  ///
  MatchResult matchRouteAndHandle(String path,
      {HandlerFunc noMatchHandler, Context context}) {
    // check to see if there is a route that matches up to the provided path
    final match = matchRoute(path, context: context);
    dynamic result;
    if (match.wasMatched) {
      // execute the route handler and capture the result
      result = match.route.callback(match.context);
    } else if (noMatchHandler != null) {
      result = noMatchHandler(match.context);
    }
    match.result = result;
    return match;
  }

  ///
  MatchResult matchRoute(
    String path, {
    Context context,
  }) {
    // the parameter values. these will be populated, initially, from the
    // values of the query string attached to the path (if any). If no query
    // string is present, the parameters will be initially empty.
    final parameters = Parameters.fromString(path);

    // the context values
    var matchContext = context ?? Context.empty();
    // add the path to the context
    final queryIndex = path.indexOf(queryPrefix);
    var trimmedPath = queryIndex == -1 ? path : path.substring(0, queryIndex);
    matchContext = Context.withValue(matchContext, contextKeyPath, trimmedPath);

    // TODO - we can check for the root path immediately?

    // remove the initial slash from the path
    if (trimmedPath.startsWith(pathSeparator)) {
      trimmedPath = trimmedPath.substring(1);
    }
    // split the path into it's components
    var components = trimmedPath.split(pathSeparator);
    if (path == defaultRootPath) {
      components = <String>[pathSeparator];
    }

    RouteTreeNode matchedNode;
    var nodesToCheck = _nodes;
    for (final comp in components) {
      matchedNode = null;
      for (final node in nodesToCheck) {
        final isMatch =
            node.part == comp || node.isParameter || node.isWildcard;
        if (isMatch) {
          if (node.isParameter) {
            parameters.add(node.part.substring(1), comp);
          } else if (node.isWildcard) {
            parameters.add(paramKeyWildcard, comp);
          }
          matchedNode = node;
          nodesToCheck = node.nodes;
          break;
        }
      }
      if (matchedNode == null) {
        return MatchResult.noMatch(context: matchContext);
      }
    }

    if (matchedNode != null) {
      matchContext =
          Context.withValue(matchContext, contextKeyParameters, parameters);
      final route = matchedNode.routes.first;
      var finalContext = matchContext;
      if (route.context != null) {
        finalContext = Context.withContext(route.context, matchContext);
      }
      return MatchResult.matched(
        route: matchedNode.routes.first,
        context: finalContext,
      );
    }

    return MatchResult.noMatch(context: matchContext);
  }

  ///
  void printTree() => _printSubTree();

  void _printSubTree({RouteTreeNode parent, int level = 0}) {
    final nodes = parent != null ? parent.nodes : _nodes;
    for (final node in nodes) {
      var indent = '';
      for (var i = 0; i < level; i++) {
        indent += '    ';
      }
      print('$indent${node.part}: total routes=${node.routes.length}');
      if (node.nodes != null && node.nodes.length > 0) {
        _printSubTree(parent: node, level: level + 1);
      }
    }
  }

  RouteTreeNode _nodeForComponent(String component, RouteTreeNode parent) {
    var nodes = _nodes;
    if (parent != null) {
      // search parent for sub-node matches
      nodes = parent.nodes;
    }
    for (final node in nodes) {
      if (node.part == component) {
        return node;
      }
    }
    return null;
  }

  RouteTreeNodeType _typeForComponent(String component) {
    var type = RouteTreeNodeType.component;
    if (_isParameterComponent(component)) {
      type = RouteTreeNodeType.parameter;
    }
    return type;
  }

  /// Is the path component a parameter
  bool _isParameterComponent(String component) => component.startsWith(':');

  ///
  void addRoute(RouteDefinition route) {
    var path = route.path;
    // is root/default route, just add it
    if (path == defaultRootPath) {
      if (_hasDefaultRoute) {
        // throw an error because the internal consistency of the router
        // could be affected
        throw 'Default route was already defined';
      }
      final node = RouteTreeNode(
        path,
        RouteTreeNodeType.component,
      );
      node.routes = <RouteDefinition>[route];
      _nodes.add(node);
      _hasDefaultRoute = true;
      return;
    }
    if (path.startsWith(pathSeparator)) {
      path = path.substring(1); // trim the leading slash
    }
    final pathComponents = path.split(pathSeparator);
    RouteTreeNode parent;
    for (var i = 0; i < pathComponents.length; i++) {
      final component = pathComponents[i];
      var node = _nodeForComponent(component, parent);
      if (node == null) {
        final type = _typeForComponent(component);
        node = RouteTreeNode(component, type)..parent = parent;
        if (parent == null) {
          _nodes.add(node);
        } else {
          parent.nodes.add(node);
        }
      }
      if (i == pathComponents.length - 1) {
        if (node.routes == null) {
          node.routes = <RouteDefinition>[route];
        } else {
          node.routes.add(route);
        }
      }
      parent = node;
    }
  }
}
