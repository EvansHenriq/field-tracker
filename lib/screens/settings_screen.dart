import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';

import '../main.dart';
import '../services/settings_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  Timer? _debounce;
  String _currentLocale = 'pt';

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _nameController.dispose();
    _idController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final name = await SettingsService.getTechnicianName();
    final id = await SettingsService.getTechnicianId();
    final locale = await SettingsService.getLocale();
    setState(() {
      _nameController.text = name ?? '';
      _idController.text = id ?? '';
      _currentLocale = locale;
    });
  }

  Future<void> _save() async {
    await SettingsService.saveTechnicianProfile(
      name: _nameController.text.trim(),
      id: _idController.text.trim(),
    );
    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(l10n.profileSaved),
            duration: Duration(milliseconds: 500),
          ),
        );
    }
  }

  Future<void> _setLocale(String code) async {
    await SettingsService.setLocale(code);
    setState(() {
      _currentLocale = code;
    });
    if (mounted) {
      FieldTrackerApp.setLocale(context, Locale(code));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle, style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Technician profile
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.technician, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: l10n.technicianName,
                      prefixIcon: const Icon(Icons.person),
                    ),
                    onChanged: (_) {
                      _debounce?.cancel();
                      _debounce = Timer(const Duration(milliseconds: 800), _save);
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _idController,
                    decoration: InputDecoration(
                      labelText: l10n.technicianId,
                      prefixIcon: const Icon(Icons.badge),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    onChanged: (_) {
                      _debounce?.cancel();
                      _debounce = Timer(const Duration(milliseconds: 800), _save);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Language
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.language, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  SegmentedButton<String>(
                    segments: [
                      ButtonSegment<String>(
                        value: 'pt',
                        label: Text(l10n.portuguese),
                        icon: const Icon(Icons.language),
                      ),
                      ButtonSegment<String>(
                        value: 'en',
                        label: Text(l10n.english),
                        icon: const Icon(Icons.language),
                      ),
                    ],
                    selected: {
                      _currentLocale
                    },
                    onSelectionChanged: (selected) {
                      _setLocale(selected.first);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // About
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(l10n.about, style: Theme.of(context).textTheme.titleMedium),
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(l10n.version),
                  trailing: Text('1.0.0', style: Theme.of(context).textTheme.bodyMedium),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: Text(l10n.appDescription, style: Theme.of(context).textTheme.bodySmall),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
