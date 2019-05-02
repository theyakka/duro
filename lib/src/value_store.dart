/*
 * Dazza
 * Created by Yakka
 * https://theyakka.com
 *
 * Copyright (c) 2019 Yakka LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

class ValueStore<KT, VT> {
  ValueStore();
  ValueStore.initial(KT key, VT value)
      : assert(key != null),
        assert(value != null) {
    _values[key] = value;
  }
  Map<KT, VT> _values;

  Map<KT, VT> get values => _values;

  VT operator [](KT key) => _values[key];
  VT value(KT key) => _values[key];

  /// Checks to see if the parameter exists.
  bool has(String key) => _values.containsKey(key);

  /// Will return true if no parameters have been set
  bool get isEmpty => _values.isEmpty;

  /// Will return true if one or more parameters have been set
  bool get isNotEmpty => _values.isNotEmpty;

  void operator []=(KT key, VT value) => _values[key] = value;
  void set(KT key, VT value) => _values[key] = value;
  void setAll(ValueStore<KT, VT> otherStore) {
    if (otherStore != null) {
      otherStore._values.addAll(otherStore._values);
    }
  }

  void setMap(Map<KT, VT> valueMap) => _values.addAll(valueMap);

  void remove(KT key) => _values.remove(key);

  void clear() => _values.clear();

  @override
  String toString() => _values.toString();
}
