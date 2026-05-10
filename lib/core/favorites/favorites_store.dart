import 'package:flutter/foundation.dart';

class FavoritesStore {
  FavoritesStore._();

  static final FavoritesStore instance = FavoritesStore._();

  final ValueNotifier<Set<String>> favorites = ValueNotifier<Set<String>>(<String>{});

  bool isFavorite(String id) => favorites.value.contains(id);

  void toggle(String id) {
    final next = Set<String>.of(favorites.value);
    if (next.contains(id)) {
      next.remove(id);
    } else {
      next.add(id);
    }
    favorites.value = next;
  }
}
