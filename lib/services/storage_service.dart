import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/business_lead.dart';

class StorageService {
  static const String _leadsKey = 'mohammed_dhair_leads';
  static const String _emailKey = 'mohammed_dhair_email';

  static Future<void> saveLeads(List<BusinessLead> leads) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(leads.map((l) => l.toJson()).toList());
    await prefs.setString(_leadsKey, encoded);
  }

  static Future<List<BusinessLead>> getLeads() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encoded = prefs.getString(_leadsKey);
    if (encoded == null) return [];
    final List<dynamic> decoded = jsonDecode(encoded);
    return decoded.map((item) => BusinessLead.fromJson(item)).toList();
  }

  static Future<void> saveUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
  }

  static Future<String> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey) ?? 'mohammed.dhair@example.com';
  }
}