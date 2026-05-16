abstract class PropertiesEvent {
  const PropertiesEvent();
}

class PropertiesStarted extends PropertiesEvent {
  const PropertiesStarted({this.page = 0, this.perPage = 20});

  final int page;
  final int perPage;
}

class PropertiesRefreshed extends PropertiesEvent {
  const PropertiesRefreshed({this.page = 0, this.perPage = 20});

  final int page;
  final int perPage;
}
