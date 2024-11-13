import 'package:docx/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class DocEditScreen extends StatefulWidget {
  const DocEditScreen({super.key});

  @override
  State<DocEditScreen> createState() => _DocEditScreenState();
}

class _DocEditScreenState extends State<DocEditScreen> {
  final QuillController _controller = QuillController.basic();

  Future<void> exportQuillToPdf(QuillController controller) async {
    // Create a new PDF document
    final pdf = pw.Document();

    // Get the Quill document content as delta format
    final delta = controller.document.toDelta();

    // Define a function to parse and style each segment
    List<pw.Widget> buildStyledText(List<dynamic> operations) {
      List<pw.Widget> pdfWidgets = [];

      for (var op in operations) {
        // Each `op` is a delta operation in the Quill document
        final text = op['insert'];
        final style = op['attributes'] ?? {};

        // Set base style
        pw.TextStyle textStyle = pw.TextStyle(fontSize: 14);

        // Apply style attributes
        if (style['bold'] == true) {
          textStyle = textStyle.copyWith(fontWeight: pw.FontWeight.bold);
        }
        if (style['italic'] == true) {
          textStyle = textStyle.copyWith(fontStyle: pw.FontStyle.italic);
        }
        if (style['underline'] == true) {
          textStyle = textStyle.copyWith(decoration: pw.TextDecoration.underline);
        }
        if (style['header'] != null) {
          final headerSize = style['header'] == 1 ? 24 : 20;
          textStyle = textStyle.copyWith(fontSize: headerSize.toDouble(), fontWeight: pw.FontWeight.bold);
        }

        pdfWidgets.add(pw.Text(text, style: textStyle));
      }

      return pdfWidgets;
    }

    // Build the PDF page
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: buildStyledText(delta.toJson()),
          );
        },
      ),
    );

    // Preview the PDF using the printing package
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  Future<String> deltaToHtml(QuillController controller) async {
    final delta = controller.document.toDelta();
    String htmlContent = '';

    // Iterate through delta operations and convert to HTML
    for (var op in delta.toList()) {
      if (op.isInsert) {
        final insertText = op.insert.toString();

        // Handle formatting based on attributes
        if (op.attributes != null) {
          final attributes = op.attributes!;
          if (attributes.containsKey('bold')) {
            htmlContent += '<b>$insertText</b>';
          } else if (attributes.containsKey('italic')) {
            htmlContent += '<i>$insertText</i>';
          } else if (attributes.containsKey('underline')) {
            htmlContent += '<u>$insertText</u>';
          } else if (attributes.containsKey('color')) {
            final color = attributes['color'];
            htmlContent += '<span style="color:$color;">$insertText</span>';
          } else {
            htmlContent += insertText; // Plain text
          }
        } else {
          htmlContent += insertText; // Plain text
        }
      }
    }

    return htmlContent;
  }

  Future<void> exportQuillToHtmlPdf(QuillController controller) async {
    // Convert Quill delta to JSON
    final deltaJson = controller.document.toDelta().toJson();

    // Convert JSON to HTML using vsc_quill_delta_to_html
    final htmlContent = deltaToHtml(deltaJson);

    // Generate the PDF from HTML
    final outputDir = await getTemporaryDirectory();
    final outputFile = await FlutterHtmlToPdf.convertFromHtmlContent(
      htmlContent,
      outputDir.path,
      "styled_quill_document.pdf",
    );

    print("PDF generated at: ${outputFile.path}");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Document",
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.comment),
            tooltip: 'Comment Icon',
            color: Colors.white,
            onPressed: () {},
          ), //IconButton
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Setting Icon',
            color: Colors.white,
            onPressed: () {},
          ), //IconButton
        ], //<Widget>[]
        backgroundColor: Colors.blueAccent[400],
        elevation: 50.0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          tooltip: 'Menu Icon',
          color: Colors.white,
          onPressed: () {},
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        color: AppColors.kAppBarColorMobile.withOpacity(.5),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1), // Black border with 2px width
                  borderRadius: BorderRadius.circular(4),
                  color: AppColors.kWarningToastBgColor),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: QuillSimpleToolbar(
                  controller: _controller,
                  configurations: const QuillSimpleToolbarConfigurations(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1), // Black border with 2px width
                    borderRadius: BorderRadius.circular(4),
                    color: AppColors.kBlankMsgBackground // Optional: to make corners rounded
                    ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: QuillEditor.basic(
                    controller: _controller,
                    configurations: const QuillEditorConfigurations(),
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20, top: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.kSegmentButton,
                      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 5),
                      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  onPressed: () async {
                    await exportQuillToPdf(_controller);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.remove_red_eye, color: AppColors.kWhiteColor),
                      SizedBox(width: 10),
                      Text(
                        'Preview PDF',
                        style: TextStyle(color: AppColors.kWhiteColor, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
