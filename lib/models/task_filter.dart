import 'package:flutter/cupertino.dart';
import 'package:task_manager/l10n/l10n.dart';

enum TaskFilter { all, completed, remaining }

extension TaskFilterExtension on TaskFilter {
  String nameLocalization(BuildContext context) {
    if(this == TaskFilter.all) return context.l10n.enum_taskFilter_all;
    if(this == TaskFilter.completed) return context.l10n.enum_taskFilter_completed;
    if(this == TaskFilter.remaining) return context.l10n.enum_taskFilter_remaining;
    return "Unknown";
  }
}