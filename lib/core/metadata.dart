class Metadata {
  int? currentPage;
  int? pageSize;
  int? firstPage;
  int? lastPage;
  int? totalRecords;

  Metadata({
    required this.currentPage,
    required this.pageSize,
    required this.firstPage,
    required this.lastPage,
    required this.totalRecords,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      currentPage: json['current_page'],
      pageSize: json['page_size'],
      firstPage: json['first_page'],
      lastPage: json['last_page'],
      totalRecords: json['total_records'],
    );
  }

  bool isAnyNull() {
    return (currentPage == null ||
        pageSize == null ||
        firstPage == null ||
        lastPage == null ||
        totalRecords == null);
  }
}
