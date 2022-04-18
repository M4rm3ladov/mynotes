/// Extension method/function to return Stream<List<T>> with Function of argument(T) as argument
/// and use the condition to filter with List.where(condition).
extension Filter<T> on Stream<List<T>> {
  Stream<List<T>> filter(bool Function(T) where) =>
      map((items) => items.where(where).toList());
}
