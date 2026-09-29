import 'package:flutter/material.dart';
import '../models/business_lead.dart';
import '../services/storage_service.dart';
import '../services/email_service.dart';

class AppProvider extends ChangeNotifier {
  List<BusinessLead> _leads = [];
  String _userEmail = 'mohammed.dhair@example.com';
  Locale _locale = const Locale('ar');
  bool _isLoading = false;

  List<BusinessLead> get leads => _leads;
  String get userEmail => _userEmail;
  Locale get locale => _locale;
  bool get isLoading => _isLoading;

  AppProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    _isLoading = true;
    notifyListeners();

    _leads = await StorageService.getLeads();
    _userEmail = await StorageService.getUserEmail();

    if (_leads.isEmpty) {
      // Seed with initial realistic Gulf market examples lacking websites
      _leads = [
        BusinessLead(
          id: '1',
          name: 'مطاعم الشرق الأوسط (الرياض)',
          country: 'المملكة العربية السعودية',
          sector: 'مطاعم وضيافة',
          phone: '+966 11 234 5678',
          address: 'الرياض، شارع التحلية',
          hasWebsite: false,
          hasApp: false,
          status: 'Pending',
          notes: 'مطعم مشهور جداً وليس لديهم موقع الكتروني ولا تطبيق طلبات',
          discoveredDate: DateTime.now().subtract(const Duration(days: 1)),
        ),
        BusinessLead(
          id: '2',
          name: 'مفروشات دبي العريقة',
          country: 'الإمارات العربية المتحدة',
          sector: 'تجزئة وأثاث',
          phone: '+971 4 333 4455',
          address: 'دبي، شارع الشيخ زايد',
          hasWebsite: false,
          hasApp: false,
          status: 'Contacted',
          notes: 'تواصلت مع المدير وطلب عرض سعر لعمل موقع متكامل',
          discoveredDate: DateTime.now().subtract(const Duration(days: 3)),
        ),
        BusinessLead(
          id: '3',
          name: 'مجوهرات اللؤلؤة (المنامة)',
          country: 'مملكة البحرين',
          sector: 'مجوهرات وكسسوارات',
          phone: '+973 17 555 888',
          address: 'المنامة، السوق المركزي',
          hasWebsite: false,
          hasApp: false,
          status: 'Pending',
          notes: 'معرض كبير بدون أي تواجد رقمي',
          discoveredDate: DateTime.now().subtract(const Duration(days: 5)),
        ),
      ];
      await StorageService.saveLeads(_leads);
    }

    _isLoading = false;
    notifyListeners();
  }

  void toggleLanguage() {
    _locale = _locale.languageCode == 'ar' ? const Locale('en') : const Locale('ar');
    notifyListeners();
  }

  Future<void> updateUserEmail(String email) async {
    _userEmail = email;
    await StorageService.saveUserEmail(email);
    notifyListeners();
  }

  // Search Gulf market simulation function
  List<BusinessLead> searchGulfMarket({required String country, required String sector}) {
    // Simulate discovering/filtering businesses that lack websites in Gulf
    List<BusinessLead> results = _leads.where((lead) {
      bool matchCountry = country.isEmpty || lead.country.contains(country);
      bool matchSector = sector.isEmpty || lead.sector.contains(sector);
      return matchCountry && matchSector && !lead.hasWebsite;
    }).toList();
    return results;
  }

  Future<void> addLead(BusinessLead lead) async {
    _leads.insert(0, lead);
    await StorageService.saveLeads(_leads);
    notifyListeners();
  }

  Future<void> updateLeadStatus(String id, String status, String notes) async {
    final index = _leads.indexWhere((l) => l.id == id);
    if (index != -1) {
      _leads[index].status = status;
      _leads[index].notes = notes;
      await StorageService.saveLeads(_leads);
      notifyListeners();
    }
  }

  Future<bool> sendLeadEmail(BusinessLead lead) async {
    return await EmailService.sendLeadDetailsToEmail(recipientEmail: _userEmail, lead: lead);
  }

  Future<bool> sendAllReport() async {
    return await EmailService.sendAllLeadsReport(recipientEmail: _userEmail, leads: _leads);
  }
}