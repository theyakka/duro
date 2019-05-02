/*
 * Dazza
 * Created by Yakka
 * https://theyakka.com
 *
 * Copyright (c) 2019 Yakka LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:meta/meta.dart';

import 'definitions.dart';
import 'parameters.dart';

///
class RouteTreeNodeMatch {
  RouteTreeNodeMatch({@required this.node, this.parameters});
  final RouteTreeNode node;
  Parameters parameters = Parameters();
}

///
class RouteTreeNode {
  RouteTreeNode(this.part, this.type);

  String part;
  RouteTreeNodeType type;
  List<RouteDefinition> routes = <RouteDefinition>[];
  List<RouteTreeNode> nodes = <RouteTreeNode>[];
  RouteTreeNode parent;

  bool get isParameter => type == RouteTreeNodeType.parameter;
}

/// Used for storing and matching
class RouteTree {
  final List<RouteTreeNode> _nodes = <RouteTreeNode>[];
  final String rootPath = '/';
  bool _hasDefaultRoute = false;

  ///
  void addRoute(RouteDefinition route) {
    String path = route.path;
    // is root/default route, just add it
    if (path == rootPath) {
      if (_hasDefaultRoute) {
        // throw an error because the internal consistency of the router
        // could be affected
        throw 'Default route was already defined';
      }
      final RouteTreeNode node =
          RouteTreeNode(path, RouteTreeNodeType.component);
      node.routes = <RouteDefinition>[route];
      _nodes.add(node);
      _hasDefaultRoute = true;
      return;
    }
    if (path.startsWith('/')) {
      path = path.substring(1);
    }
    final List<String> pathComponents = path.split('/');
    RouteTreeNode parent;
    for (int i = 0; i < pathComponents.length; i++) {
      final String component = pathComponents[i];
      RouteTreeNode node = _nodeForComponent(component, parent);
      if (node == null) {
        final RouteTreeNodeType type = _typeForComponent(component);
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

  MatchResult matchRouteAndHandle(String path,
      {Parameters parameters, Handler noMatchHandler, dynamic context}) {
    final MatchResult match =
        matchRoute(path, parameters: parameters, context: context);
    dynamic result;
    if (match.wasMatched) {
      result = match.route.handler.callback(match.context);
    } else if (noMatchHandler != null) {
      result = noMatchHandler.callback(match.context);
    }
    match.result = result;
    return match;
  }

  MatchResult matchRoute(String path,
      {Parameters parameters, dynamic context}) {
    String usePath = path;
    if (usePath.startsWith('/')) {
      usePath = path.substring(1);
    }
    List<String> components = usePath.split('/');
    if (path == rootPath) {
      components = <String>['/'];
    }

    Map<RouteTreeNode, RouteTreeNodeMatch> nodeMatches =
        <RouteTreeNode, RouteTreeNodeMatch>{};
    List<RouteTreeNode> nodesToCheck = _nodes;
    for (String checkComponent in components) {
      Map<RouteTreeNode, RouteTreeNodeMatch> currentMatches =
          <RouteTreeNode, RouteTreeNodeMatch>{};
      List<RouteTreeNode> nextNodes = <RouteTreeNode>[];
      for (RouteTreeNode node in nodesToCheck) {
        String pathPart = checkComponent;
        Map<String, List<String>> queryMap;
        if (checkComponent.contains('?')) {
          final List<String> splitParam = checkComponent.split('?');
          pathPart = splitParam[0];
          queryMap = parseQueryString(splitParam[1]);
        }
        final bool isMatch = node.part == pathPart || node.isParameter;
        if (isMatch) {
          final RouteTreeNodeMatch parentMatch = nodeMatches[node.parent];
          final Parameters params = parentMatch?.parameters ?? Parameters();
          final RouteTreeNodeMatch match =
              RouteTreeNodeMatch(node: node, parameters: params);
          if (node.isParameter) {
            final String paramKey = node.part.substring(1);
            match.parameters.add(paramKey, pathPart);
          }
          if (queryMap != null) {
            match.parameters.addMap(queryMap);
          }
          currentMatches[node] = match;
          if (node.nodes != null) {
            nextNodes.addAll(node.nodes);
          }
        }
      }
      nodeMatches = currentMatches;
      nodesToCheck = nextNodes;
      if (currentMatches.values.isEmpty) {
        return MatchResult.noMatch(parameters: parameters, context: context);
      }
    }
    List<RouteTreeNodeMatch> matches = nodeMatches.values.toList();
    if (matches.length > 0) {
      RouteTreeNodeMatch match = matches.first;
      RouteTreeNode nodeToUse = match.node;
      if (nodeToUse != null &&
          nodeToUse.routes != null &&
          nodeToUse.routes.length > 0) {
        List<RouteDefinition> routes = nodeToUse.routes;
        RouteDefinition firstMatchedRoute = routes[0];
        MatchResult routeMatch = MatchResult(
          route: firstMatchedRoute,
          parameters: match.parameters,
          context: context ?? firstMatchedRoute.handler.context,
        );
        routeMatch.parameters.addAll(parameters);
        return routeMatch;
      }
    }
    return MatchResult.noMatch(context: context);
  }

  void printTree() => _printSubTree();

  void _printSubTree({RouteTreeNode parent, int level = 0}) {
    List<RouteTreeNode> nodes = parent != null ? parent.nodes : _nodes;
    for (RouteTreeNode node in nodes) {
      String indent = "";
      for (int i = 0; i < level; i++) {
        indent += "    ";
      }
      print("$indent${node.part}: total routes=${node.routes.length}");
      if (node.nodes != null && node.nodes.length > 0) {
        _printSubTree(parent: node, level: level + 1);
      }
    }
  }

  RouteTreeNode _nodeForComponent(String component, RouteTreeNode parent) {
    List<RouteTreeNode> nodes = _nodes;
    if (parent != null) {
      // search parent for sub-node matches
      nodes = parent.nodes;
    }
    for (RouteTreeNode node in nodes) {
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
  bool _isParameterComponent(String component) => component.startsWith(":");

  String _decode(String s) => Uri.decodeComponent(s.replaceAll('+', ' '));

  Map<String, List<String>> parseQueryString(String query) {
    final RegExp search = RegExp('([^&=]+)=?([^&]*)');
    final Map<String, List<String>> params = <String, List<String>>{};
    if (query.startsWith('?')) {
      query = query.substring(1);
    }
    for (Match match in search.allMatches(query)) {
      final String key = _decode(match.group(1));
      final String value = _decode(match.group(2));
      if (params.containsKey(key)) {
        params[key].add(value);
      } else {
        params[key] = <String>[value];
      }
    }
    return params;
  }
}
