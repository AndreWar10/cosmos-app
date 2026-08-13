import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_webview_page.dart';
import '../../../home/domain/entities/observatory.dart';

class ObservatoryDetailPage extends StatelessWidget {
  const ObservatoryDetailPage({super.key, required this.observatory});

  final Observatory observatory;

  @override
  Widget build(BuildContext context) {
    final t = context.translate;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final secondaryColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240 + statusBarHeight,
            pinned: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: EdgeInsets.only(top: statusBarHeight),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      observatory.image,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        child: const Center(
                          child: Icon(Icons.visibility_rounded, size: 64),
                        ),
                      ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.6),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    observatory.name,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: secondaryColor),
                      const SizedBox(width: 4),
                      Text(
                        observatory.state,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: secondaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 16),
                      ...List.generate(5, (i) {
                        final full = i < observatory.rating.floor();
                        final half = !full &&
                            i < observatory.rating &&
                            observatory.rating - i >= 0.3;
                        return Icon(
                          full
                              ? Icons.star_rounded
                              : half
                                  ? Icons.star_half_rounded
                                  : Icons.star_outline_rounded,
                          size: 16,
                          color: const Color(0xFFFFD54F),
                        );
                      }),
                      const SizedBox(width: 4),
                      Text(
                        observatory.rating.toStringAsFixed(1),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: secondaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Divider(color: theme.dividerColor),
                  const SizedBox(height: 16),
                  Text(
                    observatory.description,
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
                  ),
                  const SizedBox(height: 24),
                  _InfoTile(
                    icon: Icons.place_outlined,
                    label: observatory.address,
                  ),
                  if (observatory.phone.isNotEmpty)
                    _InfoTile(
                      icon: Icons.phone_outlined,
                      label: observatory.phone,
                    ),
                  const SizedBox(height: 24),
                  if (observatory.website.isNotEmpty &&
                      !observatory.website.contains('goo.gl/maps'))
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => AppWebViewPage(
                              url: observatory.website,
                              title: observatory.name,
                            ),
                          ),
                        ),
                        icon: const Icon(Icons.language),
                        label: Text(t.observatoryWebsite),
                      ),
                    ),
                  if (observatory.mapsUrl.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => AppWebViewPage(
                              url: observatory.mapsUrl,
                              title: observatory.name,
                            ),
                          ),
                        ),
                        icon: const Icon(Icons.map_outlined),
                        label: Text(t.observatoryOpenMaps),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final secondaryColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: secondaryColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: secondaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
