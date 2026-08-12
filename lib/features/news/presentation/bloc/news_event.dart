sealed class NewsEvent {}

class NewsFetched extends NewsEvent {}

class NewsNextPageFetched extends NewsEvent {}

class NewsSearchChanged extends NewsEvent {
  NewsSearchChanged(this.query);
  final String query;
}
