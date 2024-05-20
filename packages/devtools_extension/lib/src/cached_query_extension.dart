import "package:devtools_app_shared/ui.dart" as ui;
import "package:devtools_extension/src/widgets/query_details.dart";
import "package:devtools_extension/src/widgets/query_list.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class CachedQueryExtension extends ConsumerWidget {
  const CachedQueryExtension({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final axis = ui.SplitPane.axisFor(context, 0.9);
    return ui.SplitPane(
      axis: axis,
      initialFractions: const [0.5, 0.5],
      children: const [
        ui.RoundedOutlinedBorder(
          clip: true,
          child: QueryListWidget(),
        ),
        ui.RoundedOutlinedBorder(
          clip: true,
          child: QueryDetailsWidget(),
        ),
      ],
    );
  }
}
