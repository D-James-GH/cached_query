import 'dart:convert';

import 'package:devtools_app_shared/ui.dart';
import 'package:devtools_extension/src/utils/extensions.dart';
import 'package:devtools_extension/src/widgets/expandable_row.dart';
import 'package:flutter/material.dart';

import '../state/query_details.dart';

class QueryData extends StatelessWidget {
  final QueryStateDetails details;

  const QueryData({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    final queryState = details;
    return switch (queryState) {
      QueryStateDetailsJson() => _formatJson(queryState.data ?? {}),
      QueryStateDetailsString() => Text(queryState.data ?? ""),
      InfiniteQueryDetailsJson() => Column(
          children: [
            for (final (i, page) in (queryState.pages ?? []).enumerate())
              ExpandableRow(
                title: "Page $i:",
                child: _formatJson(page),
              ),
          ],
        ),
    };
  }

  Widget _formatJson(dynamic json) {
    const encoder = JsonEncoder.withIndent("   ");
    return switch (json) {
      Map<String, dynamic>() => Padding(
          padding: const EdgeInsets.only(left: denseModeDenseSpacing),
          child: Text(encoder.convert(json)),
        ),
      List<dynamic>() => Column(
          children: [
            for (final (i, page) in (json).enumerate())
              ExpandableRow(
                title: "[$i]:",
                child: _formatJson(page),
              ),
          ],
        ),
      _ => Text(json.toString()),
    };
  }
}
