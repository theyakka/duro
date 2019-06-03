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
import 'parameters.dart';

/// Function that will execute when a route is matched. If your route contains
/// named parameters or query parameters (via a query string) then those values
/// will be present in the [context] (see [Context.parameters]).
///
/// The following built-in parameters will be present:
///  - [contextKeyPath]: the path value that was matched (what you navigated
///  to).
///  - [contextKeyParameters]: the [Parameters] object (see above).
@optionalTypeArgs
typedef HandlerFunc<T> = T Function(Context context);
