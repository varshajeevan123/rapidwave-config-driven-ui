import 'package:flutter/material.dart';

class DynamicLayout extends StatelessWidget {
  final List<Widget> children;
  final String layoutStrategy; // 'adaptive', 'column', 'row', 'grid'
  final bool isStackedOnMobile;

  const DynamicLayout({
    super.key,
    required this.children,
    this.layoutStrategy = 'adaptive',
    this.isStackedOnMobile = true,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;
        bool isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 1024;

        if (layoutStrategy == 'column' || (layoutStrategy == 'adaptive' && isMobile && isStackedOnMobile)) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          );
        } else if (layoutStrategy == 'row' || (layoutStrategy == 'adaptive' && !isMobile)) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children.map((child) => Expanded(child: child)).toList(),
          );
        } else if (layoutStrategy == 'grid') {
          return GridView.count(
            crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
            childAspectRatio: isMobile ? 1.5 : 1.2,
            children: children,
          );
        }

        // Default fallback
        return Column(
          children: children,
        );
      },
    );
  }
}
