class Pagination {
  int total;
  int currentPage;
  int lastPage;
  int perPage;

  Pagination({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        currentPage: json["currentPage"],
        total: json["total"],
        perPage: json["perPage"],
        lastPage: json["lastPage"],
      );
}
