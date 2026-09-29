import 'package:url_launcher/url_launcher.dart';
import '../models/business_lead.dart';

class EmailService {
  static Future<bool> sendLeadDetailsToEmail({
    required String recipientEmail,
    required BusinessLead lead,
  }) async {
    final String subject = Uri.encodeComponent('تفاصيل شركة جديدة بدون موقع - ${lead.name}');
    final String body = Uri.encodeComponent(
      'مرحباً محمد ضهير،\n\n'
      'تم رصد شركة جديدة في السوق الخليجي لا تمتلك موقعاً إلكترونياً أو تطبيقاً:\n\n'
      'اسم الشركة: ${lead.name}\n'
      'الدولة: ${lead.country}\n'
      'القطاع: ${lead.sector}\n'
      'رقم الهاتف: ${lead.phone}\n'
      'العنوان: ${lead.address}\n'
      'الحالة: ${lead.hasWebsite ? "لديه موقع" : "بدون موقع إلكتروني"}\n'
      'تاريخ الاكتشاف: ${lead.discoveredDate.toLocal()}\n\n'
      'ملاحظات:\n${lead.notes}\n\n'
      'يرجى التواصل معهم لعرض خدمة تصميم وتطوير الموقع الإلكتروني.\n'
    );

    final Uri emailUri = Uri.parse('mailto:$recipientEmail?subject=$subject&body=$body');

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
      return true;
    } else {
      // Fallback or web intent
      return false;
    }
  }

  static Future<bool> sendAllLeadsReport({
    required String recipientEmail,
    required List<BusinessLead> leads,
  }) async {
    final buffer = StringBuffer();
    buffer.writeln('مرحباً محمد ضهير،\n');
    buffer.writeln('إليك تقرير شامل بجميع الشركات المستهدفة في السوق الخليجي:\n');
    
    for (var lead in leads) {
      buffer.writeln('-----------------------------------');
      buffer.writeln('الشركة: ${lead.name}');
      buffer.writeln('الدولة: ${lead.country} | القطاع: ${lead.sector}');
      buffer.writeln('الهاتف: ${lead.phone}');
      buffer.writeln('بدون موقع: ${!lead.hasWebsite}');
      buffer.writeln('الحالة: ${lead.status}');
    }

    final String subject = Uri.encodeComponent('تقرير الشركات المستهدفة - السوق الخليجي');
    final String body = Uri.encodeComponent(buffer.toString());

    final Uri emailUri = Uri.parse('mailto:$recipientEmail?subject=$subject&body=$body');

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
      return true;
    }
    return false;
  }
}