/*
 * Dazza
 * Created by Yakka
 * https://theyakka.com
 *
 * Copyright (c) 2019 Yakka LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'conversions.dart';
import 'value_store.dart';
import 'parameters.dart';

/// Built-in context keys that will be present in the [context] value of any
/// [HandlerFunc].
class HandlerContextKeys {
  static String path = '_dazza.__path';
  static String routePath = '_dazza.__routePath';
  static String parameters = '_dazza.__routeParameters';
}

/// Context is an immutable key/value store that is used to store artbitrary
/// values to be passed to routes.....
class Context {
  Context.empty();
  Context.initial(String key, dynamic value)
      : assert(key != null),
        assert(value != null) {
    _valueStore[key] = value;
  }
  Context.withValue(Context parent, String key, dynamic value)
      : assert(parent != null),
        assert(key != null),
        assert(value != null) {
    _valueStore.setAll(parent._valueStore);
    _valueStore[key] = value;
  }
  Context.withoutValue(Context parent, String key)
      : assert(parent != null),
        assert(key != null),
        assert(value != null) {
    _valueStore.setAll(parent._valueStore);
    _valueStore.remove(key);
  }

  final ValueStore<String, dynamic> _valueStore = ValueStore<String, dynamic>();

  Map<String, dynamic> get values => _valueStore.values;
  dynamic value(String key) => _valueStore[key];
  String stringValue(String key) => Conversion.stringValue(_valueStore[key]);
  bool boolValue(String key) => Conversion.boolValue(_valueStore[key]);
  int intValue(String key) => Conversion.intValue(_valueStore[key]);

  // convenience getter for the parameters value
  Parameters get parameters =>
      _valueStore[HandlerContextKeys.parameters] ?? Parameters();

  // resets the context values
  void reset() => _valueStore.clear();
}
