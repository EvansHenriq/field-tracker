import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../models/location_data.dart';

class LocationCard extends StatelessWidget {
  final LocationData? location;
  final VoidCallback? onRefresh;

  const LocationCard({
    super.key,
    this.location,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    if (location == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(Icons.location_searching,
                  size: 48, color: colorScheme.onSurfaceVariant),
              const SizedBox(height: 8),
              Text(l10n.waitingLocation,
                  style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.location_on, color: colorScheme.onPrimaryContainer),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${l10n.latitude}: ${location!.latitude.toStringAsFixed(6)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                if (onRefresh != null)
                  IconButton(
                    onPressed: onRefresh,
                    icon: const Icon(Icons.refresh),
                    color: colorScheme.onPrimaryContainer,
                    iconSize: 20,
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _row(context, Icons.place, l10n.longitude,
                    location!.longitude.toStringAsFixed(6), colorScheme),
                const SizedBox(height: 10),
                _row(
                    context,
                    Icons.access_time,
                    l10n.lastUpdate,
                    DateFormat('dd/MM/yyyy HH:mm:ss')
                        .format(location!.timestamp.toLocal()),
                    colorScheme),
                if (location!.accuracy != null) ...[
                  const SizedBox(height: 10),
                  _row(
                      context,
                      Icons.gps_fixed,
                      l10n.accuracy,
                      '${location!.accuracy!.toStringAsFixed(1)} ${l10n.meters}',
                      colorScheme),
                ],
                if (location!.altitude != null) ...[
                  const SizedBox(height: 10),
                  _row(
                      context,
                      Icons.terrain,
                      l10n.altitude,
                      '${location!.altitude!.toStringAsFixed(1)} ${l10n.meters}',
                      colorScheme),
                ],
                if (location!.speed != null && location!.speed! > 0) ...[
                  const SizedBox(height: 10),
                  _row(
                      context,
                      Icons.speed,
                      l10n.speed,
                      '${(location!.speed! * 3.6).toStringAsFixed(1)} ${l10n.kmh}',
                      colorScheme),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, IconData icon, String label, String value,
      ColorScheme colorScheme) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: textTheme.labelSmall
                      ?.copyWith(color: colorScheme.onSurfaceVariant)),
              const SizedBox(height: 2),
              Text(value,
                  style: textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }
}
