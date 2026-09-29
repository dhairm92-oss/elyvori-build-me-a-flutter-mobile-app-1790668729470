import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../l10n/app_localizations.dart';
import '../models/business_lead.dart';

class LeadsScreen extends StatelessWidget {
  const LeadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final t = AppLocalizations.of(context);
    final leads = appProvider.leads;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.translate('leadsTitle'),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal[900]),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: leads.isEmpty
                ? const Center(child: Text('لا توجد شركات مضافة حالياً'))
                : ListView.builder(
                    itemCount: leads.length,
                    itemBuilder: (context, index) {
                      final lead = leads[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ExpansionTile(
                          title: Text(lead.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${lead.country} | ${lead.status}'),
                          trailing: Icon(
                            lead.hasWebsite ? Icons.check_circle : Icons.warning,
                            color: lead.hasWebsite ? Colors.green : Colors.orange,
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('القطاع: ${lead.sector}'),
                                  Text('الهاتف: ${lead.phone}'),
                                  Text('العنوان: ${lead.address}'),
                                  const SizedBox(height: 8),
                                  Text('الملاحظات: ${lead.notes.isEmpty ? "لا توجد ملاحظات" : lead.notes}'),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                                        onPressed: () async {
                                          bool sent = await appProvider.sendLeadEmail(lead);
                                          if (sent) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text(t.translate('emailReportSuccess'))),
                                            );
                                          }
                                        },
                                        icon: const Icon(Icons.email),
                                        label: Text(t.translate('sendEmailReport')),
                                      ),
                                      TextButton.icon(
                                        onPressed: () {
                                          _showEditDialog(context, lead, appProvider);
                                        },
                                        icon: const Icon(Icons.edit),
                                        label: const Text('تعديل الحالة'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, BusinessLead lead, AppProvider provider) {
    String status = lead.status;
    TextEditingController notesController = TextEditingController(text: lead.notes);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تحديث حالة الشركة: ${lead.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: status,
              items: const [
                DropdownMenuItem(value: 'Pending', child: Text('قيد التواصل (Pending)')),
                DropdownMenuItem(value: 'Contacted', child: Text('تم التواصل (Contacted)')),
                DropdownMenuItem(value: 'Converted', child: Text('تم الاتفاق (Converted)')),
              ],
              onChanged: (val) => status = val ?? status,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: 'ملاحظات المشروع أو التواصل',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.updateLeadStatus(lead.id, status, notesController.text);
              Navigator.pop(context);
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }
}