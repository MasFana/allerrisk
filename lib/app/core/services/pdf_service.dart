import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../utils/formatters.dart';
import '../../data/models/patient_model.dart';
import '../../data/models/clinical_note_model.dart';
import '../../data/models/assessment_result_model.dart';

class PdfService extends GetxService {
  Future<PdfService> init() async {
    return this;
  }

  Future<void> generatePatientReport(Patient patient, List<ClinicalNote> notes) async {
    final pdf = pw.Document();
    
    // Add page
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return [
            _buildHeader(patient),
            pw.SizedBox(height: 20),
            _buildAssessmentSummary(patient.latestAssessment),
            pw.SizedBox(height: 20),
            _buildClinicalNotes(notes),
          ];
        },
      ),
    );

    // Print or share
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'Laporan_Pasien_${patient.child.name.replaceAll(' ', '_')}.pdf',
    );
  }

  pw.Widget _buildHeader(Patient patient) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Laporan Medis AllerRisk', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
        pw.Divider(),
        pw.SizedBox(height: 10),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Nama Pasien: ${patient.child.name}', style: pw.TextStyle(fontSize: 14)),
                pw.Text('Orang Tua: ${patient.parent.name}', style: pw.TextStyle(fontSize: 12)),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text('BB: ${patient.child.weightKg} kg | TB: ${patient.child.heightCm} cm', style: pw.TextStyle(fontSize: 12)),
                pw.Text('Tanggal Cetak: ${AppFormatters.dateShort(DateTime.now())}', style: pw.TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildAssessmentSummary(AssessmentResult? latest) {
    if (latest == null) {
      return pw.Text('Belum ada data asesmen risiko alergi.');
    }

    String riskLabel = 'RENDAH';
    PdfColor riskColor = PdfColors.green;
    
    if (latest.level == RiskLevel.high) {
      riskLabel = 'TINGGI';
      riskColor = PdfColors.red;
    } else if (latest.level == RiskLevel.medium) {
      riskLabel = 'SEDANG';
      riskColor = PdfColors.orange;
    }

    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Asesmen Terakhir (${AppFormatters.dateShort(latest.assessedAt)})', 
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Skor Total: ${latest.score.toStringAsFixed(1)} / 10', style: pw.TextStyle(fontSize: 14)),
              pw.Text('Tingkat Risiko: $riskLabel', style: pw.TextStyle(fontSize: 14, color: riskColor, fontWeight: pw.FontWeight.bold)),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Text('Rincian Skor:', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          pw.Bullet(text: 'Genetik: ${latest.breakdown.geneticScore.toStringAsFixed(1)}'),
          pw.Bullet(text: 'Gejala Aktif: ${latest.breakdown.symptomsScore.toStringAsFixed(1)}'),
          pw.Bullet(text: 'Riwayat Penyakit: ${latest.breakdown.historyScore.toStringAsFixed(1)}'),
          pw.Bullet(text: 'Lingkungan: ${latest.breakdown.environmentScore.toStringAsFixed(1)}'),
        ],
      ),
    );
  }

  pw.Widget _buildClinicalNotes(List<ClinicalNote> notes) {
    if (notes.isEmpty) {
      return pw.SizedBox();
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Catatan Klinis Dokter', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
        pw.Divider(),
        ...notes.map((note) => pw.Container(
          margin: const pw.EdgeInsets.only(bottom: 10, top: 5),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('${AppFormatters.dateLong(note.createdAt)} - dr. ${note.doctorName}', 
                  style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
              pw.SizedBox(height: 4),
              pw.Text(note.note, style: const pw.TextStyle(fontSize: 12)),
            ],
          ),
        )),
      ],
    );
  }
}
