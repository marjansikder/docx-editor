import 'dart:io';

import 'package:docx/utils/custom_text_wdget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:html_to_pdf/html_to_pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class PrescriptionInfoScreen extends StatefulWidget {
  const PrescriptionInfoScreen({super.key});

  @override
  State<PrescriptionInfoScreen> createState() => _PrescriptionInfoScreenState();
}

class _PrescriptionInfoScreenState extends State<PrescriptionInfoScreen> {
  HtmlEditorController htmlEditorController = HtmlEditorController();

  String box1Content = "";
  String box2Content = "";
  String box3Content = "";

  String getHtmlContentFull() {
    return """
  <div style="display: flex; flex-direction: column; gap: 8px; margin-bottom: 16px;">
    <div style="border: 1px dashed #ccc; padding: 8px; width: 100%;">
      <p style="margin: 0;">
        <strong>${box1Content}</strong><br>
        ${box2Content}<br>
        PGT in Clinics ${box3Content}<br>
        Kanchijhuli, Mymensingh<br>
        Mobile: 01711-020304, 01932-123987<br>
        E-mail: hasansharear@agro.net
      </p>
    </div>
  </div>
  """;
  }

  Future<Uint8List?> _getPdf(String htmlContent) async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    final targetPath = appDirectory.path;
    final documentName = "document.pdf";

    final generatedPdfFile = await HtmlToPdf.convertFromHtmlContent(
      htmlContent: getHtmlContentFull(),
      printPdfConfiguration: PrintPdfConfiguration(
        targetDirectory: targetPath,
        targetName: documentName,
        printSize: PrintSize.A4,
        printOrientation: PrintOrientation.Portrait,
      ),
    );

    return generatedPdfFile.readAsBytes();
  }

  Future<void> _showEdit(BuildContext context, int boxNumber) async {
    String currentContent = "";

    // Determine the content to load based on the box number
    if (boxNumber == 1) {
      currentContent = box1Content;
    } else if (boxNumber == 2) {
      currentContent = box2Content;
    } else if (boxNumber == 3) {
      currentContent = box3Content;
    }

    htmlEditorController.setText(currentContent);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
      ),
      backgroundColor: Color(0xFFFFF8E1),
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: double.infinity,
                child: HtmlEditor(
                  controller: htmlEditorController,
                  htmlEditorOptions: HtmlEditorOptions(
                    hint: "Type your content below...",
                    autoAdjustHeight: true,
                    initialText: currentContent,
                  ),
                  htmlToolbarOptions: HtmlToolbarOptions(
                    toolbarPosition: ToolbarPosition.belowEditor,
                    defaultToolbarButtons: [
                      FontSettingButtons(
                        fontName: false,
                        fontSize: true,
                        fontSizeUnit: false,
                      ),
                      FontButtons(
                          bold: true,
                          italic: true,
                          underline: true,
                          clearAll: false,
                          superscript: false,
                          subscript: false),
                    ],
                  ),
                ),
              ),
              // Save Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    String? content = await htmlEditorController.getText();
                    if (content.isNotEmpty) {
                      setState(() {
                        if (boxNumber == 1) {
                          box1Content = content;
                        } else if (boxNumber == 2) {
                          box2Content = content;
                        } else if (boxNumber == 3) {
                          box3Content = content;
                        }
                      });
                      Navigator.pop(context); // Close the bottom sheet
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.save, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        'Save',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(200, 100, 100, 200),
        actions: [
          IconButton(
              onPressed: () async {
                final pdfBytes = await _getPdf(box1Content + box2Content + box3Content);
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
                Icons.print,
                color: Colors.white,
              )),
        ],
        title: const Text(
          'Prescription',
          style: TextStyle(fontFamily: 'Noto Sans', fontSize: 24.5, fontWeight: FontWeight.w900, color: Colors.white),
        ),
      ),
      body: Container(
        color: Color(0xFFFFF8E1).withOpacity(.6),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 8),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Box 2
                    Flexible(
                      child: Container(
                        width: width,
                        decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.black12)),
                        child: TextButton(
                          onPressed: () => _showEdit(context, 2),
                          child: box2Content.isEmpty ? Text('Add Information') : HtmlWidget(box2Content),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Flexible(
                      child: Container(
                        width: width,
                        decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.black12)),
                        child: TextButton(
                          onPressed: () => _showEdit(context, 3),
                          child: box3Content.isEmpty ? Text('Add Information') : HtmlWidget(box3Content),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Container(
                  width: width,
                  height: height * 0.05,
                  decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.black12)),
                  child: TextButton(
                    onPressed: () => _showEdit(context, 1),
                    child: box1Content.isEmpty ? Text('Add Information') : HtmlWidget(box1Content),
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Flexible(
                      child: Container(
                          width: width,
                          height: height * 0.5,
                          decoration: BoxDecoration(
                              border: Border(
                            top: BorderSide(color: Colors.black45, width: 1.5), // Top border
                            right: BorderSide(color: Colors.black45, width: 1),
                          )), // Right border
                          // No left or bottom borders
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextWidget(
                                  title: 'Owners Complaint',
                                  subtitle: 'Complaints',
                                  description: 'Remarks',
                                ),
                                SizedBox(height: 12),
                                CustomTextWidget(
                                  title: 'Clinical Findings',
                                  subtitle: 'Complaints',
                                  description: 'Remarks',
                                ),
                                SizedBox(height: 12),
                                CustomTextWidget(
                                  title: 'Postmortem Findings',
                                  subtitle: 'Complaints',
                                  description: 'Remarks',
                                ),
                                SizedBox(height: 12),
                                CustomTextWidget(
                                  title: 'Diagnosis',
                                  subtitle: 'Complaints',
                                  description: 'Remarks',
                                ),
                              ],
                            ),
                          )),
                    ),
                    Flexible(
                      child: Container(
                        width: width,
                        height: height * 0.5,
                        decoration: BoxDecoration(
                            border: Border(
                          top: BorderSide(color: Colors.black45, width: 1.5), // Top border
                          left: BorderSide(color: Colors.black45, width: 1),
                        )),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextWidget(
                                title: 'Rx',
                                subtitle: 'Complaints',
                                description: 'Remarks',
                              ),
                              SizedBox(height: 12),
                              CustomTextWidget(
                                title: 'Advice',
                                subtitle: 'Complaints',
                                description: 'Remarks',
                              ),
                              SizedBox(height: 12),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
