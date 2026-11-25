import 'package:flutter/material.dart';
import '../models/marketplace.dart';

class MarketplaceCard extends StatefulWidget {
  final Marketplace marketplace;
  final VoidCallback onTap;

  const MarketplaceCard({
    super.key,
    required this.marketplace,
    required this.onTap,
  });

  @override
  State<MarketplaceCard> createState() => _MarketplaceCardState();
}

class _MarketplaceCardState extends State<MarketplaceCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final m = widget.marketplace;
    final fallback = Icon(m.fallbackIcon, color: Colors.white, size: 38);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        scale: _hover ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Card(
          elevation: _hover ? 6 : 0,
          shadowColor: m.color.withValues(alpha: 0.35),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: m.color,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    clipBehavior: Clip.antiAlias,
                    alignment: Alignment.center,
                    child: m.assetPath == null
                        ? fallback
                        : Image.asset(
                            m.assetPath!,
                            width: 72,
                            height: 72,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => fallback,
                          ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    m.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    m.tagline,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
