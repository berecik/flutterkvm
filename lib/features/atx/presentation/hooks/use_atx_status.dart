import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutterkvm/features/atx/data/atx_repository.dart';
import 'package:flutterkvm/features/atx/domain/atx_status.dart';

AsyncSnapshot<AtxStatus> useAtxStatus(AtxRepository repo) {
  final stream = useMemoized(
    () => Stream.periodic(const Duration(seconds: 2))
        .asyncMap((_) => repo.getStatus())
        .startWith(repo.getStatus()),
    [repo],
  );
  return useStream(stream);
}

extension StreamExtension<T> on Stream<T> {
  Stream<T> startWith(Future<T> initial) async* {
    yield await initial;
    yield* this;
  }
}
