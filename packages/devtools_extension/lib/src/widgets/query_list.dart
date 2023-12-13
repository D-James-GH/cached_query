import 'package:devtools_app_shared/ui.dart';
import 'package:devtools_extension/src/state/query.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QueryListWidget extends ConsumerWidget {
  const QueryListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Column(
      children: [
        AreaPaneHeader(
          title: Text("Cached Queries"),
          includeTopBorder: false,
          includeBottomBorder: true,
          includeLeftBorder: false,
          includeRightBorder: false,
          roundedTopBorder: false,
        ),
        Expanded(child: _QueryListBody()),
      ],
    );
  }
}

class _QueryListBody extends ConsumerWidget {
  const _QueryListBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queries = ref.watch(queryListProvider);
    if (queries.isLoading && queries.value == null) {
      return const CircularProgressIndicator();
    }
    if (queries.hasError) {
      return ListView(
        children: [
          Text("Error: ${queries.error}}"),
          Text("Stack Trace: ${queries.stackTrace}"),
        ],
      );
    }
    final data = queries.value?.queries ?? [];

    return ListView(
      children: [
        _Row(
          showBorder: true,
          children: [
            Text(
              "Key",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              "Type",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              "Status",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              "Stale",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        for (final item in data) _Query(query: item)
      ],
    );
  }
}

class _Query extends ConsumerWidget {
  final QueryInstance query;
  const _Query({required this.query});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final QueryInstance(:key, :type, :valueRef) = query;
    final status = ref.watch(queryStatusProvider(valueRef, key)).value ?? "";
    var stale = ref.watch(staleProvider(valueRef)).value ?? false;
    return _Row(
      showBorder: false,
      onTap: () => ref.read(queryListProvider.notifier).selectQuery(key),
      children: [
        Text(key),
        Text(type),
        Text(status),
        Text(stale.toString()),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  final bool showBorder;
  final void Function()? onTap;
  final List<Widget> children;
  const _Row({
    required this.children,
    this.onTap,
    this.showBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          border: showBorder
              ? Border(
                  bottom: BorderSide(color: Theme.of(context).focusColor),
                )
              : null,
        ),
        child: Row(
          children: [
            for (int i = 0; i < children.length; i++) _buildCell(context, i),
          ],
        ),
      ),
    );
  }

  Widget _buildCell(BuildContext context, int index) {
    if (index == 0) {
      return Expanded(
        flex: 1,
        child: Container(
          decoration: BoxDecoration(
            border: showBorder
                ? Border(
                    right: BorderSide(color: Theme.of(context).focusColor),
                  )
                : null,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: denseSpacing,
            vertical: denseModeDenseSpacing,
          ),
          child: children[index],
        ),
      );
    }
    if (index == children.length - 1) {
      return Expanded(
        flex: 1,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: denseSpacing,
            vertical: denseModeDenseSpacing,
          ),
          child: children[index],
        ),
      );
    }
    return Expanded(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(
          border: showBorder
              ? Border(
                  right: BorderSide(color: Theme.of(context).focusColor),
                )
              : null,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: denseSpacing,
          vertical: denseModeDenseSpacing,
        ),
        child: children[index],
      ),
    );
  }
}
