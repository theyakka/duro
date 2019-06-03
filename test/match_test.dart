/*
 * Dazza
 * Created by Yakka
 * https://theyakka.com
 *
 * Copyright (c) 2019 Yakka, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:dazza/dazza.dart';
import 'package:test/test.dart';

const int _globalContextValue = 12345;

int testCallback(Context context) {
  return 0;
}

void main() {
  Router router;

  setUp(() {
    router = Router(noMatchHandler: _noMatchCallback);
    router.defineFunc<dynamic>('/users', _genericMatchCallback);
    router.defineFunc<dynamic>('/users/q', _genericParamsMatchCallback);
    router.defineFunc('/users/profile', _profileMatchCallback);
    router.defineFunc<dynamic>('/users/:id', _userMatchCallback);
    router.defineFunc<dynamic>('/users/list', _genericMatchCallback);
    router.addRoute(RouteDefinition<dynamic>.withCallback(
      '/gcontext',
      callback: _contextCallback,
      context: Context.initial('expectedResult', _globalContextValue),
    ));
    router.addRoute(RouteDefinition<dynamic>.withCallback(
      '/lcontext',
      callback: _contextCallback,
    ));
    router.addRoute(RouteDefinition<dynamic>.withCallback(
      '/empty',
      callback: _emptyCallback,
    ));
    router.addRoute(
      RouteDefinition<dynamic>.withCallback(
        '/test',
        callback: (context) {
          return 99;
        },
      ),
    );
  });

  test('Long form handler gets hit correctly', () {
    final expectedResult = 'abcdefg';
    final context = Context.initial('expectedResult', expectedResult);
    expect(
      router.handle('/users', context: context).result,
      equals(expectedResult),
    );
  });

  test('Handler matches non-wildcard route', () {
    final expectedResult = 200;
    final context = Context.initial('expectedResult', expectedResult);
    expect(router.handle('/users', context: context).result,
        equals(expectedResult));
  });

  test('Handler matches named param route', () {
    final userId = '55';
    expect(router.handle('/users/$userId').result, equals(userId));
  });

  test('Prioritize non-wildcard route over later defined wildcard one', () {
    expect(router.handle('/users/profile').result, equals('myProfile'));
  });

  test('Prioritize wildcard route over later defined non-wildcard one', () {
    final expectedResult = 'testList';
    final context = Context.initial('expectedResult', expectedResult);
    expect(router.handle("/users/list", context: context).result,
        isNot("testList"));
  });

  test("Match querystring parameter", () {
    final expectedResult = '750';
    expect(router.handle("/users/q?expectedResult=$expectedResult").result,
        equals(expectedResult));
  });

  test('Match result from in-line callback definition', () {
    final expectedResult = 99;
    expect(router.handle('/test').result, equals(expectedResult));
  });

  test('Handler receives global context correctly', () {
    final expectedResult = _globalContextValue;
    expect(router.handle('/gcontext').result, equals(expectedResult));
  });

  test('Handler receives local context correctly', () {
    final expectedResult = 'local value';
    final context = Context.initial('expectedResult', expectedResult);
    expect(router.handle('/lcontext', context: context).result,
        equals(expectedResult));
  });

  test('Handler hits the no match handler', () {
    final expectedResult = -1;
    expect(router.handle('/notavalidpath').result, equals(expectedResult));
  });

  test('Manual match fails to find non-defined route', () {
    final result = router.match('/doesnotexist');
    expect(result.matchStatus, equals(MatchStatus.noMatch));
  });

  test('Manual match finds defined route', () {
    final result = router.match('/lcontext');
    expect(result.matchStatus, equals(MatchStatus.match));
  });

  test('Manual match finds defined route with parameter', () {
    final result = router.match('/users/55');
    expect(result.matchStatus, equals(MatchStatus.match));
  });

  test('Manual match finds defined route and parameter is collected', () {
    final result = router.match('/users/55');
    final params = result.context.parameters;
    expect(params.firstString('id'), equals('55'));
  });

  test('Match result state indicates match correctly', () {
    final result = router.match('/users/55');
    expect(result.wasMatched, isTrue);
  });

  test('Match result state indicates non-match correctly', () {
    final result = router.match('/banana');
    expect(result.wasNotMatched, isTrue);
  });

  test('Match contains empty parameters value', () {
    final result = router.handle('/empty');
    final params = result.context.parameters;
    expect(params.isEmpty, isTrue);
  });

  test('Match contains non-empty context value', () {
    final context = Context.initial('something', 'a value');
    final result = router.handle(
      '/empty',
      context: context,
    );
    expect(result.context.has('something'), isTrue);
  });
}

dynamic _emptyCallback(Context context) {}

dynamic _genericMatchCallback(Context context) {
  // ignore: omit_local_variable_types
  final dynamic expectedResult = context.value('expectedResult');
  return expectedResult;
}

dynamic _genericParamsMatchCallback(Context context) {
  final params = context.parameters;
  // ignore: omit_local_variable_types
  final dynamic expectedResult = params.first('expectedResult');
  return expectedResult;
}

dynamic _userMatchCallback(Context context) {
  final parameters = context.parameters;
  return parameters.firstString('id');
}

String _profileMatchCallback(Context context) {
  return 'myProfile';
}

int _noMatchCallback(Context context) {
  return -1;
}

dynamic _contextCallback(Context context) {
  // ignore: omit_local_variable_types
  final dynamic expectedResult = context.value('expectedResult');
  return expectedResult;
}
