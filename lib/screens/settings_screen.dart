import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    _emailController = TextEditingController(text: appProvider.userEmail);
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final t = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.translate('emailSettings'),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal[900]),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: t.translate('emailHint'),
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.email),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              appProvider.updateUserEmail(_emailController.text);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(t.translate('saved'))),
              );
            },
            child: Text(t.translate('save'), style: const TextStyle(fontSize: 16)),
          ),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 16),
          const Text(
            'معلومات التطبيق',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('مخصص للمطور: محمد ضهير (MohammedDhair1)'),
          const Text('الهدف: البحث في السوق الخليجي عن الشركات التي لا تمتلك مواقع إلكترونية أو تطبيقات، والتواصل معها وإرسال التقارير بالكامل عبر البريد الإلكتروني.'),
        ],
      ),
    );
  }
}