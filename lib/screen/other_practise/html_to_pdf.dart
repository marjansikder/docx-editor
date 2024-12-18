/*
import 'dart:io';

import 'package:docx/screen/other_practise/prescription_format.dart';
import 'package:docx/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:html_to_pdf/html_to_pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class HtmlToPdfScreen extends StatefulWidget {
  const HtmlToPdfScreen({super.key});

  @override
  State<HtmlToPdfScreen> createState() => _HtmlToPdfScreenState();
}

class _HtmlToPdfScreenState extends State<HtmlToPdfScreen> {
  HtmlEditorController controller = HtmlEditorController();

  Future<Uint8List?> generateExampleDocument() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    final targetPath = appDocDir.path;
    final targetFileName = "example-pdf";

    // Convert HTML content to PDF bytes
    final generatedPdfFile = await HtmlToPdf.convertFromHtmlContent(
      htmlContent: await controller.getText(), // retrieve content from editor
      printPdfConfiguration: PrintPdfConfiguration(
        targetDirectory: targetPath,
        targetName: targetFileName,
        printSize: PrintSize.A4,
        printOrientation: PrintOrientation.Portrait,
      ),
    );

    return generatedPdfFile.readAsBytes();
  }

  // Read the file as bytes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Document",
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: IconButton(
                onPressed: () async {
                  final pdfBytes = await generateExampleDocument();
                  if (pdfBytes != null) {
                    await Printing.layoutPdf(
                      onLayout: (PdfPageFormat format) async => pdfBytes,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to generate PDF')),
                    );
                  }
                },
                icon: const Icon(
                  Icons.remove_red_eye_sharp,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ), //IconButton//IconButton
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
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          color: AppColors.kAppBarColorMobile.withOpacity(.5),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: HtmlEditor(
              controller: controller,
              htmlEditorOptions: HtmlEditorOptions(
                  hint: "Type your content here...",
                  shouldEnsureVisible: true,
                  autoAdjustHeight: true,
                  initialText: prescriptionFormat
                  //initialText: "<p>Welcome to the editor!</p>", // Optional initial text
                  ),
              htmlToolbarOptions: HtmlToolbarOptions(
                toolbarPosition: ToolbarPosition.belowEditor, // Toolbar above editor
                defaultToolbarButtons: [
                  FontButtons(
                    bold: true,
                    italic: true,
                    underline: true,
                  ),
                  ColorButtons(),
                  ListButtons(),
                  ParagraphButtons(
                    alignCenter: true,
                    alignJustify: true,
                    alignLeft: true,
                    alignRight: true,
                    lineHeight: true,
                  ),
                  InsertButtons(
                    picture: true,
                    link: true,
                  ),
                ],
                customToolbarButtons: [
                  IconButton(
                    icon: const Icon(Icons.save),
                    tooltip: 'Save',
                    onPressed: () async {
                      // Example: Get editor content
                      String? content = await controller.getText();
                      print(content); // Save or process content here
                    },
                  ),
                ],
              ),
              otherOptions: OtherOptions(
                height: 842,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              callbacks: Callbacks(
                onChangeContent: (String? content) {
                  print("Content changed: $content");
                },
                onFocus: () {
                  print("Editor focused");
                },
                onBlur: () {
                  print("Editor lost focus");
                },
              ),
            ),
          ),
        ));
  }
}
*/
