class RepositoryState {
  final bool attempted;
  final bool isLoading;

  RepositoryState(this.attempted, this.isLoading);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RepositoryState &&
          runtimeType == other.runtimeType &&
          attempted == other.attempted &&
          isLoading == other.isLoading;

  @override
  int get hashCode => attempted.hashCode ^ isLoading.hashCode;
}
