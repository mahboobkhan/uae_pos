import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ProjectReportWidget extends StatelessWidget {
  final String projectRefId;
  final String clientName;
  final String serviceName;
  final String orderType;
  final String status;
  final String startDate;
  final double quotation;
  final double paidAmount;
  final List<Map<String, dynamic>> stages;
  final List<Map<String, dynamic>> payments;
  final PdfPageFormat pageFormat;

  const ProjectReportWidget({
    Key? key,
    required this.projectRefId,
    required this.clientName,
    required this.serviceName,
    required this.orderType,
    required this.status,
    required this.startDate,
    required this.quotation,
    required this.paidAmount,
    required this.stages,
    required this.payments,
    this.pageFormat = PdfPageFormat.a4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Report'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(icon: const Icon(Icons.print), onPressed: () => _printPDF(), tooltip: 'Print'),
          IconButton(icon: const Icon(Icons.share), onPressed: () => _sharePDF(), tooltip: 'Share'),
        ],
      ),
      body: PdfPreview(
        build: (format) => _generatePDF(),
        allowPrinting: true,
        allowSharing: true,
        canChangePageFormat: false,
        pdfFileName: 'Project_Report_$projectRefId.pdf',
      ),
    );
  }

  Future<void> _printPDF() async {
    await Printing.layoutPdf(onLayout: (format) => _generatePDF(), name: 'Project_Report_$projectRefId.pdf');
  }

  Future<void> _sharePDF() async {
    await Printing.sharePdf(bytes: await _generatePDF(), filename: 'Project_Report_$projectRefId.pdf');
  }

  Future<Uint8List> _generatePDF() async {
    final pdf = pw.Document();

    // Load SVG dirham symbol
    final svgString = await rootBundle.loadString('assets/icons/dirham_symble.svg');

    final scale = pageFormat.width / PdfPageFormat.a4.width;
    final balance = quotation - paidAmount;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: pageFormat,
        margin: pw.EdgeInsets.all(20 * scale),
        build:
            (context) => [
              _header(scale),
              pw.SizedBox(height: 15 * scale),
              _contact(scale),
              pw.SizedBox(height: 15 * scale),
              _projectInfo(scale),
              pw.SizedBox(height: 15 * scale),
              _statusSection(scale),
              pw.SizedBox(height: 15 * scale),
              _stagesSection(scale),
              pw.SizedBox(height: 15 * scale),
              _paymentsSection(scale, svgString),
              pw.SizedBox(height: 15 * scale),
              _financialSummary(scale, balance, svgString),
              pw.Spacer(),
              pw.Center(child: _footer(scale)),
            ],
      ),
    );

    return pdf.save();
  }

  pw.Widget _header(double scale) {
    return pw.Container(
      padding: pw.EdgeInsets.all(15 * scale),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.blue800, width: 2),
        borderRadius: pw.BorderRadius.circular(8),
        color: PdfColors.blue50,
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'ABC Business Consultancy',
                style: pw.TextStyle(fontSize: 24 * scale, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900),
              ),
              pw.SizedBox(height: 5 * scale),
              pw.Text(
                'Your Business Gateway in the Emirates',
                style: pw.TextStyle(fontSize: 12 * scale, color: PdfColors.blue700),
              ),
            ],
          ),
          pw.Container(
            padding: pw.EdgeInsets.all(10 * scale),
            decoration: pw.BoxDecoration(color: PdfColors.blue800, borderRadius: pw.BorderRadius.circular(8)),
            child: pw.Text(
              'PROJECT REPORT',
              style: pw.TextStyle(fontSize: 18 * scale, fontWeight: pw.FontWeight.bold, color: PdfColors.white),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _contact(double scale) {
    return pw.Container(
      padding: pw.EdgeInsets.all(12 * scale),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: pw.BorderRadius.circular(6),
        color: PdfColors.grey100,
      ),
      child: pw.Column(
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Expanded(
                child: pw.Text(
                  'Address: Near Sinara Super Market R/A, Ajman',
                  style: pw.TextStyle(fontSize: 10 * scale),
                ),
              ),
              pw.Expanded(
                child: pw.Text('Phone: 06-7449724 | 050-52 36 278', style: pw.TextStyle(fontSize: 10 * scale)),
              ),
            ],
          ),
          pw.SizedBox(height: 8 * scale),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Expanded(child: pw.Text('WhatsApp: 055-3995447 (Atif)', style: pw.TextStyle(fontSize: 10 * scale))),
              pw.Expanded(
                child: pw.Text(
                  'Website: www.abcconsultants.com',
                  style: pw.TextStyle(fontSize: 10 * scale, color: PdfColors.blue700),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _projectInfo(double scale) {
    return pw.Container(
      padding: pw.EdgeInsets.all(12 * scale),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'PROJECT DETAILS',
            style: pw.TextStyle(fontSize: 14 * scale, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800),
          ),
          pw.Divider(color: PdfColors.grey400),
          pw.SizedBox(height: 8 * scale),
          pw.Row(
            children: [
              pw.Expanded(child: _infoRow('Project ID:', projectRefId, scale)),
              pw.Expanded(child: _infoRow('Client Name:', clientName, scale)),
            ],
          ),
          pw.SizedBox(height: 8 * scale),
          pw.Row(
            children: [
              pw.Expanded(child: _infoRow('Service:', serviceName, scale)),
              pw.Expanded(child: _infoRow('Order Type:', orderType, scale)),
            ],
          ),
          pw.SizedBox(height: 8 * scale),
          _infoRow('Start Date:', startDate, scale),
        ],
      ),
    );
  }

  pw.Widget _infoRow(String label, String value, double scale) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(fontSize: 11 * scale, fontWeight: pw.FontWeight.bold, color: PdfColors.grey700),
        ),
        pw.SizedBox(width: 5 * scale),
        pw.Expanded(child: pw.Text(value, style: pw.TextStyle(fontSize: 11 * scale))),
      ],
    );
  }

  pw.Widget _statusSection(double scale) {
    PdfColor statusColor = PdfColors.orange;
    if (status.toLowerCase() == 'completed') statusColor = PdfColors.green;
    if (status.toLowerCase() == 'pending') statusColor = PdfColors.orange;
    if (status.toLowerCase() == 'cancelled') statusColor = PdfColors.red;

    return pw.Container(
      padding: pw.EdgeInsets.all(12 * scale),
      decoration: pw.BoxDecoration(
        color: statusColor.shade(0.9),
        border: pw.Border.all(color: statusColor),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: [
          pw.Text('PROJECT STATUS: ', style: pw.TextStyle(fontSize: 12 * scale, fontWeight: pw.FontWeight.bold)),
          pw.Text(
            status.toUpperCase(),
            style: pw.TextStyle(fontSize: 12 * scale, fontWeight: pw.FontWeight.bold, color: statusColor),
          ),
        ],
      ),
    );
  }

  pw.Widget _stagesSection(double scale) {
    if (stages.isEmpty) return pw.SizedBox();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'PROJECT STAGES',
          style: pw.TextStyle(fontSize: 14 * scale, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800),
        ),
        pw.SizedBox(height: 10 * scale),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey400),
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.blue800),
              children: [
                _tableHeader('Stage', scale),
                _tableHeader('Department', scale),
                _tableHeader('Start Date', scale),
                _tableHeader('End Date', scale),
                _tableHeader('Status', scale),
              ],
            ),
            ...stages.asMap().entries.map((entry) {
              final idx = entry.key + 1;
              final stage = entry.value;
              final dept = stage['service_department']?.toString() ?? 'N/A';
              final startDate = stage['created_at']?.toString().split(' ')[0] ?? 'N/A';
              final endDate = stage['end_at']?.toString().split(' ')[0] ?? 'In Progress';
              final stageStatus = stage['end_at'] != null ? 'Completed' : 'In Progress';

              return pw.TableRow(
                decoration: pw.BoxDecoration(color: idx.isEven ? PdfColors.grey50 : PdfColors.white),
                children: [
                  _tableCell('Stage $idx', scale),
                  _tableCell(dept, scale),
                  _tableCell(startDate, scale),
                  _tableCell(endDate, scale),
                  _tableCell(stageStatus, scale, bold: true),
                ],
              );
            }).toList(),
          ],
        ),
      ],
    );
  }

  pw.Widget _paymentsSection(double scale, String svgString) {
    if (payments.isEmpty) return pw.SizedBox();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'PAYMENT HISTORY',
          style: pw.TextStyle(fontSize: 14 * scale, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800),
        ),
        pw.SizedBox(height: 10 * scale),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey400),
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.blue800),
              children: [
                _tableHeader('Date', scale),
                _tableHeader('Payment ID', scale),
                _tableHeader('Method', scale),
                _tableHeader('Amount', scale),
                _tableHeader('Status', scale),
              ],
            ),
            ...payments.map((payment) {
              final date = payment['created_at']?.toString().split(' ')[0] ?? 'N/A';
              final paymentId = payment['payment_ref_id']?.toString() ?? 'N/A';
              final method = payment['payment_method']?.toString().toUpperCase() ?? 'N/A';
              final amount = _toDouble(payment['paid_amount']);
              final status = payment['status']?.toString() ?? 'N/A';

              return pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.white),
                children: [
                  _tableCell(date, scale),
                  _tableCell(paymentId, scale),
                  _tableCell(method, scale),
                  _tableCellWithIcon(amount.toStringAsFixed(2), scale, svgString),
                  _tableCell(status.toUpperCase(), scale, bold: true),
                ],
              );
            }).toList(),
          ],
        ),
      ],
    );
  }

  pw.Widget _financialSummary(double scale, double balance, String svgString) {
    return pw.Container(
      padding: pw.EdgeInsets.all(12 * scale),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: pw.BorderRadius.circular(6),
        color: PdfColors.blue50,
      ),
      child: pw.Column(
        children: [
          pw.Text(
            'FINANCIAL SUMMARY',
            style: pw.TextStyle(fontSize: 14 * scale, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800),
          ),
          pw.Divider(color: PdfColors.blue800),
          pw.SizedBox(height: 10 * scale),
          _summaryRow('Total Project Cost:', quotation.toStringAsFixed(2), scale, svgString),
          pw.SizedBox(height: 8 * scale),
          _summaryRow('Total Paid:', paidAmount.toStringAsFixed(2), scale, svgString, color: PdfColors.green),
          pw.SizedBox(height: 8 * scale),
          pw.Container(
            padding: pw.EdgeInsets.all(10 * scale),
            decoration: pw.BoxDecoration(
              color: balance > 0 ? PdfColors.orange50 : PdfColors.green50,
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: _summaryRow(
              'Balance Remaining:',
              balance.toStringAsFixed(2),
              scale,
              svgString,
              color: balance > 0 ? PdfColors.orange : PdfColors.green,
              bold: true,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _summaryRow(
    String label,
    String value,
    double scale,
    String svgString, {
    PdfColor? color,
    bool bold = false,
  }) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: (bold ? 13 : 12) * scale,
            fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
            color: color,
          ),
        ),
        pw.Row(
          mainAxisSize: pw.MainAxisSize.min,
          children: [
            pw.SvgImage(svg: svgString, width: (bold ? 14 : 12) * scale, height: (bold ? 14 : 12) * scale),
            pw.SizedBox(width: 3 * scale),
            pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: (bold ? 14 : 12) * scale,
                fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
                color: color,
              ),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _tableHeader(String text, double scale) {
    return pw.Container(
      padding: pw.EdgeInsets.all(8 * scale),
      alignment: pw.Alignment.center,
      child: pw.Text(
        text,
        style: pw.TextStyle(fontSize: 11 * scale, fontWeight: pw.FontWeight.bold, color: PdfColors.white),
      ),
    );
  }

  pw.Widget _tableCell(String text, double scale, {bool bold = false}) {
    return pw.Container(
      padding: pw.EdgeInsets.all(8 * scale),
      alignment: pw.Alignment.center,
      child: pw.Text(
        text,
        style: pw.TextStyle(fontSize: 10 * scale, fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal),
      ),
    );
  }

  pw.Widget _tableCellWithIcon(String text, double scale, String svgString) {
    return pw.Container(
      padding: pw.EdgeInsets.all(8 * scale),
      alignment: pw.Alignment.center,
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.SvgImage(svg: svgString, width: 10 * scale, height: 10 * scale),
          pw.SizedBox(width: 2 * scale),
          pw.Text(text, style: pw.TextStyle(fontSize: 10 * scale)),
        ],
      ),
    );
  }

  pw.Widget _footer(double scale) {
    return pw.Column(
      children: [
        pw.Container(
          padding: pw.EdgeInsets.all(12 * scale),
          decoration: pw.BoxDecoration(color: PdfColors.blue800, borderRadius: pw.BorderRadius.circular(6)),
          child: pw.Column(
            children: [
              pw.Text(
                'ABC Business Consultancy - Your Business Gateway in the Emirates',
                style: pw.TextStyle(fontSize: 11 * scale, fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 5 * scale),
              pw.Text(
                'New Business Setup | Visa Services | PRO Services | Dubai & Ajman',
                style: pw.TextStyle(fontSize: 9 * scale, color: PdfColors.white),
                textAlign: pw.TextAlign.center,
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 8 * scale),
        pw.Text(
          'Powered by Eline Technologies (elinctec.com)',
          style: pw.TextStyle(fontSize: 8 * scale, color: PdfColors.grey600),
          textAlign: pw.TextAlign.center,
        ),
      ],
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  factory ProjectReportWidget.fromApiData({required Map<String, dynamic> reportData, PdfPageFormat? pageFormat}) {
    final project = reportData['project'] ?? {};
    final stagesData = reportData['stages'] ?? {};
    final paymentsData = reportData['payments'] ?? {};

    return ProjectReportWidget(
      projectRefId: project['project_ref_id']?.toString() ?? 'N/A',
      clientName: reportData['client']?['name']?.toString() ?? 'N/A',
      serviceName: project['service_name']?.toString() ?? 'N/A',
      orderType: project['order_type']?.toString() ?? 'N/A',
      status: project['status']?.toString() ?? 'N/A',
      startDate: project['created_at']?.toString().split(' ')[0] ?? 'N/A',
      quotation: _toDouble(project['quotation']),
      paidAmount: _toDouble(project['paid_payment']),
      stages: List<Map<String, dynamic>>.from(stagesData['stages'] ?? []),
      payments:
          List<Map<String, dynamic>>.from(
            paymentsData['payments'] ?? [],
          ).where((p) => p['payment_type'] == 'in').toList(),
      pageFormat: pageFormat ?? PdfPageFormat.a4,
    );
  }
}
