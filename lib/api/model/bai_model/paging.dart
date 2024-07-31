class Paging<T> {
  final T data;
  final int currentPage;
  final bool hasNextPage;

  Paging({
    required this.data,
    required this.currentPage,
    required this.hasNextPage,
  });
}
