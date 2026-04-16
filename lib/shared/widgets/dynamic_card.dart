import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DynamicCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? value;
  final String style; // 'glass', 'solid', 'elevated'
  final VoidCallback? onTap;
  final int index; // for staggered animations

  const DynamicCard({
    super.key,
    required this.title,
    this.subtitle,
    this.value,
    this.style = 'solid',
    this.onTap,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Widget content = Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: style == 'glass' ? Colors.white : theme.textTheme.titleMedium?.color,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: style == 'glass' ? Colors.white70 : theme.textTheme.bodyMedium?.color,
                letterSpacing: 0.5,
              ),
            ),
          ],
          if (value != null) ...[
            const SizedBox(height: 20),
            Text(
              value!,
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w900,
                color: style == 'glass' ? Colors.cyanAccent : theme.colorScheme.primary,
                letterSpacing: -1,
              ),
            ),
          ]
        ],
      ),
    );

    Widget cardWidget;

    if (style == 'glass') {
      cardWidget = ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(20),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withAlpha(30),
                width: 1.5,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withAlpha(30),
                  Colors.white.withAlpha(5),
                ],
              ),
            ),
            child: content,
          ),
        ),
      );
    } else if (style == 'elevated') {
      cardWidget = Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withAlpha(15),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: content,
      );
    } else {
      cardWidget = Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: theme.colorScheme.surface.withAlpha(200),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: theme.colorScheme.onSurface.withAlpha(20)),
        ),
        child: content,
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: cardWidget,
    )
    .animate(delay: (100 * index).ms)
    .fadeIn(duration: 600.ms, curve: Curves.easeOut)
    .slideY(begin: 0.2, end: 0, duration: 600.ms, curve: Curves.easeOutQuint)
    .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1));
  }
}

