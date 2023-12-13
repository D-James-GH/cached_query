import "package:devtools_app_shared/ui.dart";
import "package:devtools_extension/src/widgets/query_details.dart";
import "package:devtools_extension/src/widgets/query_list.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class CachedQueryExtension extends ConsumerWidget {
  const CachedQueryExtension({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final axis = Split.axisFor(context, 0.9);
    return Split(
      axis: axis,
      initialFractions: const [0.5, 0.5],
      children: const [
        RoundedOutlinedBorder(
          clip: true,
          child: QueryListWidget(),
        ),
        RoundedOutlinedBorder(
          clip: true,
          child: QueryDetailsWidget(),
        ),
      ],
    );
  }
}
