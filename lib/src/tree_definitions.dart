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
  ///
  RouteTreeNodeMatch({@required RouteTreeNode node, Parameters parameters})
      : _node = node,
        _parameters = parameters ?? Parameters();
  // Fields
  final RouteTreeNode _node;
  final Parameters _parameters;

  /// The node instance that was matched
  RouteTreeNode get node => _node;

  /// The parameters for the matched node.
  Parameters get parameters => _parameters;
}

///
class RouteTreeNode {
  RouteTreeNode(this.part, this.type);
  RouteTreeNode.component(this.part) : type = RouteTreeNodeType.component;
  RouteTreeNode.parameter(this.part) : type = RouteTreeNodeType.parameter;
  RouteTreeNode.wildcard(this.part) : type = RouteTreeNodeType.wildcard;

  String part;
  RouteTreeNodeType type;
  List<RouteDefinition> routes = <RouteDefinition>[];
  List<RouteTreeNode> nodes = <RouteTreeNode>[];
  RouteTreeNode parent;

  bool get isParameter => type == RouteTreeNodeType.parameter;
  bool get isWildcard => type == RouteTreeNodeType.wildcard;
}
