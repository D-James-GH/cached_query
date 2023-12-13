import 'package:devtools_app_shared/ui.dart';
import 'package:devtools_extension/src/state/query.dart';
import 'package:devtools_extension/src/state/query_details.dart';
import 'package:devtools_extension/src/widgets/expandable_row.dart';
import 'package:devtools_extension/src/widgets/query_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'query_details.g.dart';

@riverpod
class DetailsExpanded extends _$DetailsExpanded {
  @override
  bool build() => false;

  void toggle() => state = !state;
}

class QueryDetailsWidget extends ConsumerStatefulWidget {
  const QueryDetailsWidget({super.key});

  @override
  ConsumerState<QueryDetailsWidget> createState() => _QueryDetailsWidgetState();
}

class _QueryDetailsWidgetState extends ConsumerState<QueryDetailsWidget> {
  final selectableFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final AsyncValue(value: listState) = ref.watch(queryListProvider);

    if (listState == null || listState.selectedKey == null) {
      return const _Empty();
    }
    final query = (listState as QueryListState)
        .queries
        .firstWhere((element) => element.key == listState.selectedKey);

    final queryDetails = ref.watch(queryDetailsProvider(query));
    final AsyncValue(value: details) = queryDetails;

    if (details == null) return const _Empty();

    return Column(
      children: [
        AreaPaneHeader(
          title: Consumer(
            builder: (context, ref, child) {
              final forceExpanded = ref.watch(detailsExpandedProvider);
              return Row(
                children: [
                  const Text("Query details"),
                  const Spacer(),
                  DevToolsTooltip(
                    message: forceExpanded
                        ? "Collapse query data"
                        : "Expand query data",
                    child: IconButton(
                      icon: Icon(
                        forceExpanded
                            ? Icons.unfold_more_rounded
                            : Icons.unfold_less_rounded,
                      ),
                      onPressed: () =>
                          ref.read(detailsExpandedProvider.notifier).toggle(),
                    ),
                  ),
                  DevToolsTooltip(
                    message: "Refresh query data",
                    child: IconButton(
                      icon: const Icon(Icons.refresh_rounded),
                      onPressed: () => ref
                          .read(queryDetailsProvider(query).notifier)
                          .refresh(),
                    ),
                  )
                ],
              );
            },
          ),
          includeTopBorder: false,
          includeBottomBorder: true,
          includeLeftBorder: false,
          includeRightBorder: false,
          roundedTopBorder: false,
        ),
        Expanded(
          child: SelectableRegion(
            focusNode: selectableFocusNode,
            selectionControls: materialTextSelectionControls,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: denseSpacing),
              child: ListView(
                children: [
                  const SizedBox(height: denseModeDenseSpacing),
                  Text("Key: ${details.key}"),
                  const SizedBox(height: denseModeDenseSpacing),
                  Text("Type: ${details.type}"),
                  const SizedBox(height: denseModeDenseSpacing),
                  Text("Status: ${details.state.status}"),
                  const SizedBox(height: denseModeDenseSpacing),
                  Text("Stale: ${details.stale ?? false}"),
                  const SizedBox(height: denseModeDenseSpacing),
                  ExpandableRow(
                    titleWidget: Row(
                      children: [
                        const Text("Data"),
                        const Spacer(),
                        DevToolsTooltip(
                          message: "Copy query data to clipboard",
                          child: IconButton(
                              icon: Icon(
                                Icons.copy,
                                size: 16,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(
                                    text: _dataToString(details),
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                    child: QueryData(details: details.state),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _dataToString(QueryDetailsState details) {
    final state = details.state;
    switch (state) {
      case QueryStateDetailsJson():
        return state.data.toString();
      case QueryStateDetailsString():
        return state.data ?? "";
      case InfiniteQueryDetailsJson():
        return state.pages.toString();
    }
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Select a query to view details"));
  }
}
