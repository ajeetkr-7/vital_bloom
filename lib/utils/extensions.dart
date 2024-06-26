import 'dart:core';

extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }
}

extension DoubleArithmeticExtensions on Iterable<double> {
  double get sum => length == 0 ? 0 : reduce((a, b) => a + b);
}
