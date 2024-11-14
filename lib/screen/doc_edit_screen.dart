import 'package:docx/utils/colors.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_to_pdf/converter/configurator/converter_option/pdf_page_format.dart';
import 'package:flutter_quill_to_pdf/converter/pdf_converter.dart';
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

  PDFPageFormat? pdfFormat = PDFPageFormat(
      marginTop: 12,
      marginBottom: 12,
      marginLeft: 12,
      marginRight: 12,
      height: double.infinity,
      width: double.infinity);

  final PDFPageFormat pageFormat = PDFPageFormat.all(width: double.infinity, height: double.infinity, margin: 12);

  final PdfPageFormat pdfPageFormat = PdfPageFormat(PDFPageFormat.a4.width, PDFPageFormat.a4.height, marginAll: 0);

  PDFConverter pdfConverter = PDFConverter(
      backMatterDelta: null, // You can provide optional back matter Delta here
      frontMatterDelta: null, // You can provide optional front matter Delta here
      document: QuillController.basic().document.toDelta(),
      fallbacks: [],
      pageFormat: PDFPageFormat.a4);

  Future<void> exportQuillToPdf(QuillController controller) async {
    //final pdfData = await pdfConverter.convert(controller.document);

    final pw.Widget? pwWidget = await pdfConverter.generateWidget(
      maxWidth: double.infinity,
      maxHeight: double.infinity,
    );

    final pw.Document? document = await pdfConverter.createDocument();
    final content = controller.document.toDelta();

// Add a page to the document with custom layout
    document?.addPage(
      pw.Page(
        pageFormat: pdfPageFormat,
        build: (pw.Context context) {
          return pw.Stack(children: [
            // Create a full-page blue background
            pw.Expanded(
              child: pw.Rectangle(
                fillColor: PdfColor.fromHex("#5AACFE"),
              ),
            ),
            // Position the editor content in the top-left corner
            pw.Positioned(top: PdfPageFormat.a4.marginTop, left: PdfPageFormat.a4.marginLeft, child: pwWidget!),
            // Position a copy of the editor content in the bottom-right corner
            pw.Positioned(bottom: PdfPageFormat.a4.marginBottom, right: PdfPageFormat.a4.marginRight, child: pwWidget!),
          ]);
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => document!.save(),
    );
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
