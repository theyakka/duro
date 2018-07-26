
<img src="https://storage.googleapis.com/product-logos/logo_dazza.png" align="center" width="160">

Dazza is a general routing framework for Dart applications. It is designed to
be fast, yet flexible.

[![Build Status](https://travis-ci.org/theyakka/dazza.svg?branch=master)](https://travis-ci.org/theyakka/dazza)
[![Dart Version](https://img.shields.io/badge/Dart-2.0+-lightgrey.svg)](https://dartlang.org/)
[![Coverage](https://codecov.io/gh/theyakka/dazza/branch/master/graph/badge.svg)](https://codecov.io/gh/theyakka/dazza)

# Features

Dazza has only the coolest features:
- Wildcard / named route parameters (e.g.: `/users/:id`)
- Query string parameter support
- Pass custom parameters when evaluating routes
- Global context for route handlers (allows for immutable, shared values to be passed to each invocation)
- Result value for handler calls
- Easily extended for custom routing needs

# Installing

**Dazza require Dart 2.0+.** Dart 2.0 is awesome.

To install, add the following line to the `dependencies` section of your `pubspec.yaml` file:

```yaml
dependencies:
  ...
  dazza: ^1.0.0

```

You can then import dazza using:

```dart
import 'package:dazza/dazza.dart';
```

# Getting started

To define routes you need a `Router` instance:

```dart
final router = Router(
  noMatchHandler: Handler(callback: noMatchCallback),
);
```

**NOTE:** Your `Router` instance should be stored somewhere where you can easily access it in multiple places as you will probably only ever want one `Router` instance per application.

Now you can define your routes. Routes can take the form of regular routes or can contained named parameters. Named parameters start with a colon (:). For example, `/users/:id`. To define your routes:

```dart
router.addRoute(RouteDefinition.withCallback("/users/:id", callback: usersRouteCallback));
```

Route callbacks are defined as functions, such as:

```dart
dynamic usersRouteCallback(Parameters parameters, dynamic context) {
  int userId = parameters.firstInt("id");
  ...
  return userId;
}
```

Or you can define them in-line if you need:

```dart
router.addRoute(
  RouteDefinition.withCallback("/users/:id",
      callback: (Parameters parameters, dynamic context) {
    int userId = parameters.firstInt("id");
    ...
    return userId;
  }),
);
```

# FAQ

## Why should I use this and not ____?

We prefer you use whatever you want. Dazza is, most likely, no better or worse than the alternatives.

Dazza was designed from the ground up to serve as a generic routing mechanism based on our experience with Dart usage on the web and in Flutter. Dazza is what we wanted out of a good routing framework, not a copy of any specific framework or best practices. It has the features we think are important, and is architected in a way that we think makes managing all this stuff super simple.

Give it a try and if you like it, let us know! Either way, we love feedback.

## Has it been tested in production? Can I use it in production?

The code here is derived from the code that was written for Fluro (https://github.com/goposse/fluro). Fluro has been battle tested in the hamilton app in production and is used by millions of people. Dazza is also in use serving Firebase Functions in other apps. That said, code is always evolving. We plan to keep on using it in production but we also plan to keep on improving it. If you find a bug, let us know!

## What are some projects that use this?

The following projects use dazza:
- Cumulus: Firebase logic made easy (by Yakka). [Link](https://github.com/theyakka/cumulus)

# Outro

## Credits

Dazza is sponsored, owned and maintained by [Yakka LLC](http://theyakka.com). Feel free to reach out with suggestions, ideas or to say hey.

### Security

If you believe you have identified a serious security vulnerability or issue with Dazza, please report it as soon as possible to apps@theyakka.com. Please refrain from posting it to the public issue tracker so that we have a chance to address it and notify everyone accordingly.

## License

Dazza is released under a modified MIT license. See LICENSE for details.

<img src="https://storage.googleapis.com/yakka-logos/logo_wordmark.png" align="center" width="70">
