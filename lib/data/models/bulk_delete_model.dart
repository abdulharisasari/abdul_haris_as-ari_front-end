class BulkDeleteRequest {
  final List<int> ids;

  BulkDeleteRequest({required this.ids});

  Map<String, dynamic> toJson() {
    return {
      "ids": ids,
    };
  }
}
