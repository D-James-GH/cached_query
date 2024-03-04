import 'package:devtools_app_shared/ui.dart';
import 'package:devtools_extension/src/widgets/query_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpandableRow extends ConsumerStatefulWidget {
  final String? title;
  final Widget? titleWidget;
  final Widget child;

  const ExpandableRow({
    super.key,
    required this.child,
    this.title,
    this.titleWidget,
  }) : assert(title != null || titleWidget != null);

  @override
  ConsumerState<ExpandableRow> createState() => _ExpandableRowState();
}

class _ExpandableRowState extends ConsumerState<ExpandableRow> {
  bool isExpanded = false;
  @override
  void initState() {
    super.initState();
    isExpanded = ref.read(detailsExpandedProvider);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      detailsExpandedProvider,
      (prev, next) => setState(() => isExpanded = next),
    );
    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => isExpanded = !isExpanded),
          child: Row(
            children: [
              Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                color: Theme.of(context).colorScheme.onSurface,
                size: 16,
              ),
              const SizedBox(width: intermediateSpacing),
              if (widget.titleWidget != null)
                Expanded(child: widget.titleWidget!),
              if (widget.title != null) Expanded(child: Text(widget.title!)),
            ],
          ),
        ),
        if (isExpanded)
          Container(
            margin: const EdgeInsets.only(left: denseRowSpacing),
            padding: const EdgeInsets.only(left: denseRowSpacing),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: Theme.of(context).focusColor,
                ),
              ),
            ),
            child: widget.child,
          ),
      ],
    );
  }
}
