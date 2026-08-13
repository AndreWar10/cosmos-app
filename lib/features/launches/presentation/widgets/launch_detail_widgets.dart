import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_webview_page.dart';
import '../../domain/entities/launch.dart';

class LaunchPatchHeader extends StatelessWidget {
  const LaunchPatchHeader({super.key, required this.launch});

  final Launch launch;

  @override
  Widget build(BuildContext context) {
    final imageUrl = launch.links.patchLarge ?? launch.links.patchSmall;

    return Center(
      child: imageUrl != null
          ? CachedNetworkImage(
              imageUrl: imageUrl,
              height: 160,
              fit: BoxFit.contain,
              placeholder: (_, _) => const SizedBox(
                height: 160,
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              ),
              errorWidget: (_, _, _) => const _FallbackPatch(),
            )
          : const _FallbackPatch(),
    );
  }
}

class _FallbackPatch extends StatelessWidget {
  const _FallbackPatch();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.rocket_launch, size: 56, color: AppColors.primary),
    );
  }
}

class LaunchInfoRow extends StatelessWidget {
  const LaunchInfoRow({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondaryColor = theme.brightness == Brightness.dark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: secondaryColor),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: secondaryColor,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LaunchLinksSection extends StatelessWidget {
  const LaunchLinksSection({super.key, required this.launch});

  final Launch launch;

  @override
  Widget build(BuildContext context) {
    final t = context.translate;
    final links = launch.links;
    final hasLinks =
        links.webcast != null || links.wikipedia != null || links.article != null;

    if (!hasLinks) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (links.webcast != null)
          FilledButton.icon(
            onPressed: () => _openWebView(context, links.webcast!, t.launchDetailWatchWebcast),
            icon: const Icon(Icons.play_circle_outline),
            label: Text(t.launchDetailWatchWebcast),
          ),
        if (links.wikipedia != null && links.wikipedia!.isNotEmpty) ...[
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => _openWebView(context, links.wikipedia!, 'Wikipedia'),
            icon: const Icon(Icons.language),
            label: const Text('Wikipedia'),
          ),
        ],
        if (links.article != null && links.article!.isNotEmpty) ...[
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => _openWebView(context, links.article!, 'Article'),
            icon: const Icon(Icons.article_outlined),
            label: const Text('Article'),
          ),
        ],
      ],
    );
  }

  void _openWebView(BuildContext context, String url, String title) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AppWebViewPage(url: url, title: title),
      ),
    );
  }
}
