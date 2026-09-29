import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../l10n/app_localizations.dart';
import 'search_screen.dart';
import 'leads_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final t = AppLocalizations.of(context);

    final List<Widget> screens = [
      const HomeTabContent(),
      const SearchScreen(),
      const LeadsScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(t.translate('appTitle')),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => appProvider.toggleLanguage(),
            tooltip: 'Change Language / تغيير اللغة',
          ),
        ],
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal[800],
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard),
            label: t.translate('dashboard'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label: t.translate('searchTab'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.business),
            label: t.translate('leadsTab'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: t.translate('settingsTab:'),
          ),
        ],
      ),
    );
  }
}

class HomeTabContent extends StatelessWidget {
  const HomeTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final t = AppLocalizations.of(context);

    final noWebCount = appProvider.leads.where((l) => !l.hasWebsite).length;
    final contactedCount = appProvider.leads.where((l) => l.status == 'Contacted').length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal[700]!, Colors.teal[900]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'مرحباً محمد ضهير 👋',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  t.translate('welcomeMsg'),
                  style: const TextStyle(fontSize: 15, color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'ملخص السوق الخليجي',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal[950]),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  title: 'بدون موقع إلكتروني',
                  count: '$noWebCount',
                  color: Colors.orange,
                  icon: Icons.web_off,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  title: 'تم التواصل معهم',
                  count: '$contactedCount',
                  color: Colors.blue,
                  icon: Icons.connect_without_contact,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              bool success = await appProvider.sendAllReport();
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(t.translate('emailReportSuccess'))),
                );
              }
            },
            icon: const Icon(Icons.email),
            label: const Text('إرسال تقرير شامل بجميع الشركات لبريدي', style: TextStyle(fontSize: 16)),
          ),
          const SizedBox(height: 24),
          Text(
            'آخر الشركات المكتشفة',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal[950]),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: appProvider.leads.length > 3 ? 3 : appProvider.leads.length,
            itemBuilder: (context, index) {
              final lead = appProvider.leads[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: lead.hasWebsite ? Colors.green : Colors.red[100],
                    child: Icon(
                      lead.hasWebsite ? Icons.web : Icons.web_off,
                      color: lead.hasWebsite ? Colors.white : Colors.red,
                    ),
                  ),
                  title: Text(lead.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${lead.country} • ${lead.sector}'),
                  trailing: Text(lead.status, style: TextStyle(color: Colors.teal[800], fontWeight: FontWeight.bold)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String count;
  final Color color;
  final IconData icon;

  const StatCard({
    super.key,
    required this.title,
    required this.count,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 6, spreadRadius: 2),
        ],
        border: Border(top: BorderSide(color: color, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(count, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        ],
      ),
    );
  }
}