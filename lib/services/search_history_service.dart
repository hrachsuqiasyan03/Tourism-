class SearchHistoryService {
  static final List<String> _history = [];

  static List<String> get history => List.unmodifiable(_history);

  static void addQuery(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    _history.removeWhere((item) => item.toLowerCase() == trimmed.toLowerCase());
    _history.insert(0, trimmed);
    if (_history.length > 20) {
      _history.removeLast();
    }
  }

  static void removeQuery(String query) {
    _history.removeWhere(
      (item) => item.toLowerCase() == query.trim().toLowerCase(),
    );
  }

  static void clearHistory() {
    _history.clear();
  }
}
