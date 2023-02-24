import 'package:discryptor/models/key_value_pair.dart';

extension Iterables<E extends KeyValuePair<int, int>> on Iterable<E> {
  Map<int, int> toMap() => fold(<int, int>{},
      (Map<int, int> map, E e) => map..putIfAbsent(e.key, () => e.value));
}
