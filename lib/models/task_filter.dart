import 'package:flutter/cupertino.dart';
import 'package:task_manager/l10n/l10n.dart';

enum TaskFilter { All, Completed, Remaining }

extension TaskFilterExtension on TaskFilter {
  String nameLocalization(BuildContext context) {
    if(this == TaskFilter.All) return context.l10n.enum_taskFilter_all;
    if(this == TaskFilter.Completed) return context.l10n.enum_taskFilter_completed;
    if(this == TaskFilter.Remaining) return context.l10n.enum_taskFilter_remaining;
    return "Unknown";
  }
}