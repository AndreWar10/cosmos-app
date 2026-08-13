import 'package:flutter/material.dart';

class HomeLoadingSkeleton extends StatelessWidget {
  const HomeLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final divider = Theme.of(context).dividerColor;
    final surface = Theme.of(context).colorScheme.surface;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            height: 240,
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 32),
          _SkeletonTitle(width: 120, color: divider),
          const SizedBox(height: 12),
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 6,
              separatorBuilder: (_, _) => const SizedBox(width: 16),
              itemBuilder: (_, _) => Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: divider,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 40,
                    height: 10,
                    decoration: BoxDecoration(
                      color: divider,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          _SkeletonTitle(width: 140, color: divider),
          const SizedBox(height: 12),
          _SkeletonCarousel(
            height: 180, cardWidth: 220, cardCount: 3,
            surface: surface, divider: divider,
          ),
          const SizedBox(height: 32),
          _SkeletonTitle(width: 180, color: divider),
          const SizedBox(height: 14),
          _SkeletonCarousel(
            height: 260, cardWidth: 220, cardCount: 3,
            surface: surface, divider: divider,
          ),
          const SizedBox(height: 24),
          _SkeletonTitle(width: 160, color: divider),
          const SizedBox(height: 12),
          _SkeletonCarousel(
            height: 180, cardWidth: 220, cardCount: 3,
            surface: surface, divider: divider,
          ),
        ],
      ),
    );
  }
}

class _SkeletonTitle extends StatelessWidget {
  const _SkeletonTitle({required this.width, required this.color});

  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 14,
        width: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(7),
        ),
      ),
    );
  }
}

class _SkeletonCarousel extends StatelessWidget {
  const _SkeletonCarousel({
    required this.height,
    required this.cardWidth,
    required this.cardCount,
    required this.surface,
    required this.divider,
  });

  final double height;
  final double cardWidth;
  final int cardCount;
  final Color surface;
  final Color divider;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: cardCount,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, _) => SizedBox(
          width: cardWidth,
          child: Container(
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(color: divider.withValues(alpha: 0.3)),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 12,
                        width: cardWidth * 0.7,
                        decoration: BoxDecoration(
                          color: divider,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 10,
                        width: cardWidth * 0.45,
                        decoration: BoxDecoration(
                          color: divider.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
