import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../l10n/app_localizations.dart';
import '../models/business_lead.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _selectedCountry = '';
  String _selectedSector = '';
  List<BusinessLead> _searchResults = [];
  bool _hasSearched = false;

  final List<String> _gulfCountries = [
    'المملكة العربية السعودية',
    'الإمارات العربية المتحدة',
    'دولة الكويت',
    'مملكة البحرين',
    'دولة قطر',
    'سلطنة عمان',
  ];

  final List<String> _sectors = [
    'مطاعم وضيافة',
    'تجزئة وأثاث',
    'مجوهرات واكسسوارات',
    'عيادات ومراكز طبية',
    'مقاولات وعقارات',
    'خدمات صيانة وسيارات',
  ];

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
            t.translate('searchTitle'),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal[900]),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: t.translate('country'),
              border: const OutlineInputBorder(),
            ),
            value: _selectedCountry.isEmpty ? null : _selectedCountry,
            items: _gulfCountries.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: (val) => setState(() => _selectedCountry = val ?? ''),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: t.translate('sector'),
              border: const OutlineInputBorder(),
            ),
            value: _selectedSector.isEmpty ? null : _selectedSector,
            items: _sectors.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
            onChanged: (val) => setState(() => _selectedSector = val ?? ''),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal[800],
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              setState(() {
                _searchResults = appProvider.searchGulfMarket(
                  country: _selectedCountry,
                  sector: _selectedSector,
                );
                _hasSearched = true;
              });
            },
            child: Text(t.translate('searchBtn'), style: const TextStyle(fontSize: 16)),
          ),
          const SizedBox(height: 20),
          Text(
            t.translate('resultsTitle'),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal[900]),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: !_hasSearched
                ? const Center(child: Text('اختر الدولة والقطاع وابدأ البحث عن الشركات المستهدفة'))
                : _searchResults.isEmpty
                    ? const Center(child: Text('لم يتم العثور على شركات بدون موقع في هذا القطاع حالياً'))
                    : ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final lead = _searchResults[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(lead.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                      Chip(
                                        backgroundColor: Colors.red[50],
                                        label: Text(
                                          t.translate('noWebsiteDetected'),
                                          style: const TextStyle(color: Colors.red, fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text('${lead.country} • ${lead.sector}'),
                                  const SizedBox(height: 4),
                                  Text('هاتف: ${lead.phone}', style: const TextStyle(color: Colors.grey)),
                                  Text('عنوان: ${lead.address}', style: const TextStyle(color: Colors.grey)),
                                  const Divider(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      OutlinedButton.icon(
                                        onPressed: () async {
                                          bool sent = await appProvider.sendLeadEmail(lead);
                                          if (sent) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text(t.translate('emailReportSuccess'))),
                                            );
                                          }
                                        },
                                        icon: const Icon(Icons.email, color: Colors.teal),
                                        label: Text(t.translate('sendEmailReport')),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}