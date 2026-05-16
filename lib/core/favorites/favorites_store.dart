import 'package:flutter/foundation.dart';

import 'package:statefulclickcounter/core/di/injection.dart';
import 'package:statefulclickcounter/features/customer/favorites/data/models/favorite_models.dart';
import 'package:statefulclickcounter/features/customer/favorites/domain/repositories/favorites_repository.dart';

/// In-memory cache of the user's favorites, kept in sync with the backend.
///
/// IDs that don't match the UUID format are treated as local-only (legacy mock
/// screens that still use synthetic identifiers like `fav-<name>-<location>`).
class FavoritesStore {
  FavoritesStore._();

  static final FavoritesStore instance = FavoritesStore._();

  static final RegExp _uuidRegex = RegExp(
    r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
    caseSensitive: false,
  );

  final ValueNotifier<Set<String>> favorites = ValueNotifier<Set<String>>(<String>{});

  FavoritesRepository get _repo => getIt<FavoritesRepository>();

  bool isFavorite(String id) => favorites.value.contains(id);

  bool _isRemoteId(String id) => _uuidRegex.hasMatch(id);

  void _setLocal(String id, bool add) {
    final next = Set<String>.of(favorites.value);
    if (add) {
      next.add(id);
    } else {
      next.remove(id);
    }
    favorites.value = next;
  }

  /// Optimistic toggle. For UUID-shaped IDs, syncs with the backend and reverts
  /// the local cache if the call fails.
  Future<void> toggle(String id) async {
    final wasFav = favorites.value.contains(id);
    _setLocal(id, !wasFav);

    if (!_isRemoteId(id)) return;

    try {
      if (wasFav) {
        await _repo.removeFavorite(id);
      } else {
        await _repo.addFavorite(id);
      }
    } catch (_) {
      _setLocal(id, wasFav);
      rethrow;
    }
  }

  /// Pulls the authoritative list from the backend and seeds the local cache
  /// with the returned property IDs. Returns the full page for screens that
  /// want to render details (title, price, cover…).
  Future<FavoritesPage> refresh({int page = 0, int size = 20}) async {
    final result = await _repo.getMine(page: page, size: size);
    final remoteIds = result.content.map((e) => e.id).toSet();
    final next = Set<String>.of(favorites.value)
      ..removeWhere(_isRemoteId)
      ..addAll(remoteIds);
    favorites.value = next;
    return result;
  }

  void clear() {
    favorites.value = <String>{};
  }
}
