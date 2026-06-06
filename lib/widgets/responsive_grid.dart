import 'package:flutter/material.dart';

/// A simple responsive grid: lays children into [columns] columns with spacing.
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int columns;
  final double spacing;
  const ResponsiveGrid({
    super.key,
    required this.children,
    this.columns = 4,
    this.spacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, cons) {
        final width = cons.maxWidth;
        final itemWidth = (width - spacing * (columns - 1)) / columns;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final c in children) SizedBox(width: itemWidth, child: c),
          ],
        );
      },
    );
  }
}
