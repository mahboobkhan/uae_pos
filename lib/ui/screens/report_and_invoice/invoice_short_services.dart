import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ABCInvoiceWidget extends StatelessWidget {
  final String refNo;
  final String clientName;
  final String managerName;
  final List<Map<String, dynamic>> services;
  final String date;
  final PdfPageFormat pageFormat;

  const ABCInvoiceWidget({
    Key? key,
    required this.refNo,
    required this.clientName,
    required this.managerName,
    required this.services,
    this.date = '',
    this.pageFormat = PdfPageFormat.a6,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Preview'),
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
        pdfFileName: 'Invoice_$refNo.pdf',
      ),
    );
  }

  Future<void> _printPDF() async {
    await Printing.layoutPdf(onLayout: (format) => _generatePDF(), name: 'Invoice_$refNo.pdf');
  }

  Future<void> _sharePDF() async {
    await Printing.sharePdf(bytes: await _generatePDF(), filename: 'Invoice_$refNo.pdf');
  }

  Future<Uint8List> _generatePDF() async {
    final pdf = pw.Document();

    // Load SVG dirham symbol
    final svgString = await rootBundle.loadString('icons/dirham_symble.svg');

    // Calculate scale based on page width
    final scale = pageFormat.width / PdfPageFormat.a4.width;

    // Calculate totals
    double subtotal = 0.0;
    double totalDiscount = 0.0;

    for (var service in services) {
      final qty = _toInt(service['quantity']);
      final price = _toDouble(service['unit_price']);
      final disc = _toDouble(service['discount']);
      subtotal += (qty * price);
      totalDiscount += disc;
    }

    final total = subtotal - totalDiscount;

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
              _clientInfo(scale),
              pw.SizedBox(height: 15 * scale),
              _servicesTable(scale, svgString),
              pw.SizedBox(height: 15 * scale),
              _totals(scale, subtotal, totalDiscount, total, svgString),
              pw.SizedBox(height: 20 * scale),
              _signature(scale),
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
              'INVOICE',
              style: pw.TextStyle(fontSize: 20 * scale, fontWeight: pw.FontWeight.bold, color: PdfColors.white),
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

  pw.Widget _clientInfo(double scale) {
    final displayDate = date.isNotEmpty ? date : DateTime.now().toString().split(' ')[0];

    return pw.Container(
      padding: pw.EdgeInsets.all(12 * scale),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Expanded(
            flex: 2,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('BILL TO:', style: pw.TextStyle(fontSize: 10 * scale, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 5 * scale),
                pw.Text(clientName, style: pw.TextStyle(fontSize: 14 * scale, fontWeight: pw.FontWeight.bold)),
              ],
            ),
          ),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('SHORT SERVICE #:', style: pw.TextStyle(fontSize: 10 * scale, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 5 * scale),
                pw.Text(refNo, style: pw.TextStyle(fontSize: 12 * scale, color: PdfColors.blue800)),
              ],
            ),
          ),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('DATE:', style: pw.TextStyle(fontSize: 10 * scale, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 5 * scale),
                pw.Text(displayDate, style: pw.TextStyle(fontSize: 12 * scale)),
              ],
            ),
          ),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('MANAGER:', style: pw.TextStyle(fontSize: 10 * scale, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 5 * scale),
                pw.Text(managerName, style: pw.TextStyle(fontSize: 12 * scale)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _servicesTable(double scale, String svgString) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400),
      columnWidths: {
        0: pw.FixedColumnWidth(30 * scale),
        1: const pw.FlexColumnWidth(3),
        2: pw.FixedColumnWidth(50 * scale),
        3: pw.FixedColumnWidth(70 * scale),
        4: pw.FixedColumnWidth(70 * scale),
        5: pw.FixedColumnWidth(80 * scale),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.blue800),
          children: [
            _cell('#', scale, true, ''),
            _cell('Service', scale, true, ''),
            _cell('Qty', scale, true, ''),
            _cell('Price', scale, true, ''),
            _cell('Discount', scale, true, ''),
            _cell('Amount', scale, true, ''),
          ],
        ),
        ...services.asMap().entries.map((entry) {
          final idx = entry.key + 1;
          final svc = entry.value;
          final name = svc['service_category_name']?.toString() ?? '';
          final qty = _toInt(svc['quantity']);
          final price = _toDouble(svc['unit_price']);
          final disc = _toDouble(svc['discount']);
          final amt = (qty * price) - disc;

          return pw.TableRow(
            decoration: pw.BoxDecoration(color: idx.isEven ? PdfColors.grey50 : PdfColors.white),
            children: [
              _cell(idx.toString(), scale, false, ''),
              _cell(name, scale, false, '', left: true),
              _cell(qty > 0 ? qty.toString() : '-', scale, false, ''),
              _cellWithIcon(price > 0 ? price.toStringAsFixed(2) : '-', scale, false, svgString),
              _cellWithIcon(disc > 0 ? disc.toStringAsFixed(2) : '-', scale, false, svgString),
              _cellWithIcon(amt.toStringAsFixed(2), scale, false, svgString, bold: true),
            ],
          );
        }).toList(),
      ],
    );
  }

  pw.Widget _cell(String text, double scale, bool header, String svg, {bool bold = false, bool left = false}) {
    return pw.Container(
      padding: pw.EdgeInsets.all(8 * scale),
      alignment: left ? pw.Alignment.centerLeft : pw.Alignment.center,
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: (header ? 11 : 10) * scale,
          fontWeight: (header || bold) ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: header ? PdfColors.white : PdfColors.black,
        ),
      ),
    );
  }

  pw.Widget _cellWithIcon(String text, double scale, bool header, String svgString, {bool bold = false}) {
    if (text == '-') {
      return pw.Container(
        padding: pw.EdgeInsets.all(8 * scale),
        alignment: pw.Alignment.center,
        child: pw.Text('-', style: pw.TextStyle(fontSize: 10 * scale)),
      );
    }

    return pw.Container(
      padding: pw.EdgeInsets.all(8 * scale),
      alignment: pw.Alignment.center,
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          /*pw.SvgImage(svg: svgString, width: 10 * scale, height: 10 * scale),
          pw.SizedBox(width: 2 * scale),*/
          pw.Text(
            text,
            style: pw.TextStyle(
              fontSize: 10 * scale,
              fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
              color: PdfColors.black,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _totals(double scale, double sub, double disc, double tot, String svgString) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        pw.Container(
          width: 250 * scale,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey400),
            borderRadius: pw.BorderRadius.circular(6),
          ),
          child: pw.Column(
            children: [
              _totalRow('Subtotal:', sub.toStringAsFixed(2), scale, false, svgString),
              // pw.Divider(color: PdfColors.grey300),
              _totalRow('Discount:', disc.toStringAsFixed(2), scale, false, svgString),
              // pw.Divider(color: PdfColors.grey300),
              _totalRow('TOTAL:', tot.toStringAsFixed(2), scale, true, svgString),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _totalRow(String label, String value, double scale, bool bold, String svgString) {
    return pw.Container(
      padding: pw.EdgeInsets.all(10 * scale),
      decoration: pw.BoxDecoration(
        color: bold ? PdfColors.blue50 : null,
        borderRadius:
            bold
                ? pw.BorderRadius.only(
                  bottomLeft: pw.Radius.circular(10 * scale),
                  bottomRight: pw.Radius.circular(10 * scale),
                )
                : null,
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: (bold ? 13 : 11) * scale,
              fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
          pw.Row(
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              pw.SvgImage(svg: svgString, width: (bold ? 12 : 10) * scale, height: (bold ? 12 : 10) * scale),
              pw.SizedBox(width: 3 * scale),
              pw.Text(
                value,
                style: pw.TextStyle(
                  fontSize: (bold ? 14 : 12) * scale,
                  fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
                  color: bold ? PdfColors.blue800 : PdfColors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _signature(double scale) {
    return pw.Container(
      padding: pw.EdgeInsets.all(12 * scale),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Receiver Signature:',
                  style: pw.TextStyle(fontSize: 11 * scale, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 30 * scale),
                pw.Container(height: 1, width: 150 * scale, color: PdfColors.grey400),
              ],
            ),
          ),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Authorized By:', style: pw.TextStyle(fontSize: 11 * scale, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 30 * scale),
                pw.Container(height: 1, width: 150 * scale, color: PdfColors.grey400),
              ],
            ),
          ),
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

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  factory ABCInvoiceWidget.fromApiData({required Map<String, dynamic> invoiceData, PdfPageFormat? pageFormat}) {
    // Extract invoice details
    final refNo = invoiceData['ref_id']?.toString() ?? 'N/A';
    final clientName = invoiceData['client_name']?.toString() ?? 'N/A';
    final managerName = invoiceData['manager_name']?.toString() ?? 'N/A';
    final date = invoiceData['date']?.toString() ?? '';

    // Extract services and map them to the expected format
    final List<Map<String, dynamic>> services = [];
    if (invoiceData['services'] != null && invoiceData['services'] is List) {
      for (var service in invoiceData['services']) {
        services.add({
          'service_category_name': service['service_category_name']?.toString() ?? 'N/A',
          'quantity': _toInt(service['quantity']),
          'unit_price': _toDouble(service['unit_price']),
          'discount': _toDouble(service['discount']),
        });
      }
    }

    if (services.isEmpty) {
      throw Exception('No services found in invoice data');
    }

    return ABCInvoiceWidget(
      refNo: refNo,
      clientName: clientName,
      managerName: managerName,
      services: services,
      date: date,
      pageFormat: pageFormat ?? PdfPageFormat.a4,
    );
  }
}
