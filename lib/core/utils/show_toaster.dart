import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

void showToast({
  required BuildContext context,
  required String desc,
  bool isDestructive = false,
}) {
  if (isDestructive) {
    ShadToaster.of(context).show(
      ShadToast.destructive(
        description: Text(desc),
        showCloseIconOnlyWhenHovered: false,
      ),
    );
  } else {
    ShadToaster.of(context).show(
      ShadToast(description: Text(desc), showCloseIconOnlyWhenHovered: false),
    );
  }
}
