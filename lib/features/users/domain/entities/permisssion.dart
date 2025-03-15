class Permission {
  final String permission;

  Permission({required this.permission});

  int toId() {
    return idToPermissionCode.entries
        .firstWhere(
          (entry) => entry.value == permission,
          orElse: () => MapEntry(-1, ''),
        )
        .key;
  }

  Map<int, String> idToPermissionCode = {1: "read", 2: "issue", 3: "write"};
}
