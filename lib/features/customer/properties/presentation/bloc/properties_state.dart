import '../../data/models/property_models.dart';

enum PropertiesStatus { initial, loading, loaded, error }

class PropertiesState {
  const PropertiesState({
    required this.status,
    this.items = const [],
    this.message,
  });

  final PropertiesStatus status;
  final List<PropertyItem> items;
  final String? message;

  const PropertiesState.initial() : this(status: PropertiesStatus.initial);

  PropertiesState copyWith({
    PropertiesStatus? status,
    List<PropertyItem>? items,
    String? message,
  }) {
    return PropertiesState(
      status: status ?? this.status,
      items: items ?? this.items,
      message: message,
    );
  }
}
