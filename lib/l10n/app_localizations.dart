import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'ar': {
      'appTitle': 'موقع محمد ضهير - السوق الخليجي',
      'dashboard': 'الرئيسية',
      'searchTab': 'البحث في السوق',
      'leadsTab': 'الشركات المستهدفة',
      'settingsTab:': 'الإعدادات',
      'welcomeMsg': 'أهلاً بك يا محمد ضهير. ابحث عن شركات الخليج التي لا تمتلك مواقع وتواصل معها واطلب إرسال التفاصيل عبر البريد.',
      'searchTitle': 'البحث في أسواق دول الخليج',
      'country': 'الدولة',
      'sector': 'القطاع التجاري',
      'searchBtn': 'بحث عن شركات بدون موقع',
      'resultsTitle': 'نتائج البحث',
      'noWebsiteDetected': 'لا يوجد موقع إلكتروني أو تطبيق',
      'contactCompany': 'تواصل مع الشركة',
      'sendEmailReport': 'إرسال التفاصيل إلى بريدي',
      'emailReportSuccess': 'تم إرسال التفاصيل بنجاح إلى بريدك!',
      'leadsTitle': 'قائمة الشركات والعمليات',
      'emailSettings': 'إعدادات البريد الإلكتروني لاستلام التقارير',
      'save': 'حفظ',
      'saved': 'تم الحفظ بنجاح',
      'emailHint': 'بريدك الإلكتروني (مثل mohammed@example.com)',
      'statusPending': 'قيد التواصل',
      'statusContacted': 'تم التواصل',
      'statusConverted': 'تم الاتفاق على العمل',
      'notes': 'ملاحظات المشروع',
    },
    'en': {
      'appTitle': 'Mohammed Dhair - Gulf Market',
      'dashboard': 'Dashboard',
      'searchTab': 'Market Search',
      'leadsTab': 'Target Leads',
      'settingsTab:': 'Settings',
      'welcomeMsg': 'Welcome Mohammed Dhair. Find Gulf businesses without websites, contact them, and send reports to your email.',
      'searchTitle': 'Search Gulf Markets',
      'country': 'Country',
      'sector': 'Business Sector',
      'searchBtn': 'Search Businesses Without Website',
      'resultsTitle': 'Search Results',
      'noWebsiteDetected': 'No Website or App Detected',
      'contactCompany': 'Contact Company',
      'sendEmailReport': 'Send Details to My Email',
      'emailReportSuccess': 'Details successfully sent to your email!',
      'leadsTitle': 'Leads & Pipeline',
      'emailSettings': 'Email Settings for Reports',
      'save': 'Save',
      'saved': 'Saved Successfully',
      'emailHint': 'Your Email (e.g. mohammed@example.com)',
      'statusPending': 'Pending Contact',
      'statusContacted': 'Contacted',
      'statusConverted': 'Converted',
      'notes': 'Project Notes',
    }
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? _localizedValues['ar']?[key] ?? key;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['ar', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}