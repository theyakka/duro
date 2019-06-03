/*
 * Dazza
 * Created by Yakka
 * https://theyakka.com
 *
 * Copyright (c) 2019 Yakka LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

/// Extensible key + value storage. Even though you could use a simple map, we
/// want some generic convenience methods that we can share across classes that
/// act like more sophisticated key + value collections.
class ValueStore<KT, VT> {
  /// Create an empty value store.
  ValueStore();

  /// Create a value store with an initial value for a key.
  ValueStore.initial(KT key, VT value)
      : assert(key != null),
        assert(value != null) {
    _values[key] = value;
  }

  // The raw values.
  final Map<KT, VT> _values = <KT, VT>{};

  /// Get the raw values as a map.
  Map<KT, VT> get values => _values;

  /// Literal accessor to get the value for a key.
  VT operator [](KT key) => _values[key];

  /// Literal setter to set the value for a key
  void operator []=(KT key, VT value) => _values[key] = value;

  /// Accessor to get the value for a key.
  VT value(KT key) => _values[key];

  /// Checks to see if a value exists for the key.
  bool has(String key) => _values.containsKey(key);

  /// Will return true if no values have been set
  bool get isEmpty => _values.isEmpty;

  /// Will return true if one or more values have been set
  bool get isNotEmpty => _values.isNotEmpty;

  /// Overwrite the value for a key.
  void set(KT key, VT value) => _values[key] = value;

  /// Overwrite all of the values with the values from another [ValueStore].
  void setAll(ValueStore<KT, VT> otherStore) {
    if (otherStore != null) {
      _values.addAll(otherStore._values);
    }
  }

  /// Overwrite all of the values with the values from a [Map].
  void setMap(Map<KT, VT> valueMap) => _values.addAll(valueMap);

  /// Remove the value for a key.
  void remove(KT key) => _values.remove(key);

  /// Clear all values.
  void clear() => _values.clear();

  @override
  String toString() => _values.toString();
}
