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
 <!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Prescription Template</title>
    <style>
    
     body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }

        .rx-container {
            display: flex;
            justify-content: space-between;
            padding: 15px;
            background-color: #fdfdfd;
            height: auto; /* Adjust to content */
        }
        
        .footer-container {
            display: flex;
            justify-content: space-between;
            margin: 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 15px;
            background-color: #fdfdfd;
            height: auto; /* Adjust to content */
        }

        .column {
            flex: 1;
            padding: 10px;
            overflow: hidden; /* Prevent content overflow */
        }

        .middle-border {
            border-left: 1px solid #000;
            height: auto;
            margin: 0 15px;
        }

        .section {
            margin-bottom: 20px;
            word-wrap: break-word; /* Prevent long words from overflowing */
        }

        .section-title {
            font-weight: bold;
            margin-bottom: 5px;
            white-space: nowrap; /* Prevent the title from breaking into multiple lines */
        }

        .content {
            font-size: 14px;
            color: #555;
            margin: 5px 0; /* Space between lines */
        }

        .box-content {
            border: 1px solid #ddd;
            padding: 5px 10px;
            background-color: #fafafa;
            border-radius: 4px;
            margin-top: 5px;
        }

        .container {
            margin: 20px;
            padding: 10px;
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 10px;
        }
        
        .details-container {
            margin: 20px;
            padding: 10px;
        }

        .header {
            background-color: #c5b3f7;
            color: white;
            padding: 10px;
            margin: 10px;
            font-size: 24px;
            font-weight: bold;
        }

        .row {
            display: flex;
            justify-content: space-between;
            margin: 20px 0;
        }
        
        .divider {
            border-top: 1px solid black;
            margin: 10px;
        }

        .details-box {
            flex: 1;
          
            margin: 0 10px;
            padding: 10px;
          
        }

        .box p {
            margin: 5px 0;
        }
        
        .footer-box {
            padding: 15px;
            background-color: #fdfdfd;
        }

        .middle-box {
            padding: 10px;
            border-radius: 8px;
            text-align: left;
        }

        .footer {
            display: flex;
            justify-content: space-between;
            padding: 10px;
            border-top: 2px solid #ddd;
            margin-top: 20px;
            color: #333;
            background-color: #fafafa;
        }

        .footer .box {
            flex: 1;
            margin: 0 5px;
        }

        .editable {
            font-weight: bold;
        }
    </style>
</head>
    <div class="container">
        <div class="header">Prescription</div>
        <div class="divider"></div>
        <div class="row">
            <!-- First Left Box -->
            <div class="details-box">
              <p>${box3Content}</p>
            </div>
            <div class="middle-border"></div>
            <!-- Second Right Box -->
            <div class="details-box">
                <p>${box2Content}</p>
            </div>
        </div>
       
        <div class="divider"></div>
         <div class="middle-box">
            <p>${box1Content}</p>
        </div>
         <div class="divider"></div>
            <div class="rx-container">
        <!-- Left Column -->
      
        <div class="column">
            <div class="section">
                <div class="section-title">Owners Complaint</div>
                <div class="content">Complaints</div>
                <div class="content">Remarks</div>
            </div>
            <div class="section">
                <div class="section-title">Clinical Findings</div>
                <div class="content">Complaints</div>
                <div class="content">Remarks</div>
            </div>
            <div class="section">
                <div class="section-title">Postmortem Findings</div>
                <div class="content">Complaints</div>
                <div class="content">Remarks</div>
            </div>
            <div class="section">
                <div class="section-title">Diagnosis</div>
                <div class="content">Complaints</div>
                <div class="content">Remarks</div>
            </div>
        </div>

        <!-- Middle Border -->
        <div class="middle-border"></div>

        <!-- Right Column -->
        <div class="column">
            <div class="section">
                <div class="section-title">Rx</div>
                <div class="content">Complaints</div>
                <div class="content">Remarks</div>
            </div>
            <div class="section">
                <div class="section-title">Advice</div>
                <div class="content">Complaints</div>
                <div class="content">Remarks</div>
            </div>
        </div>
    </div>
    </div>
</html>
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
                    shouldEnsureVisible: true,
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
        color: Color(0xFFFFF8E1).withOpacity(.2),
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
                        //height: height * 0.3,
                        decoration: BoxDecoration(
                            border: Border(
                          top: BorderSide(color: Colors.black45, width: 1.5), // Top border
                          right: BorderSide(color: Colors.black45, width: .5),
                          bottom: BorderSide(color: Colors.black45, width: .5),
                        )),
                        child: TextButton(
                          onPressed: () => _showEdit(context, 2),
                          child: box2Content.isEmpty ? Text('Add Information') : HtmlWidget(box2Content),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Divider(thickness: 2),
                    Flexible(
                      child: Container(
                        width: width,
                        //height: height * 0.3,
                        decoration: BoxDecoration(
                            border: Border(
                          top: BorderSide(color: Colors.black45, width: 1.5), // Top border
                          left: BorderSide(color: Colors.black45, width: .5),
                          bottom: BorderSide(color: Colors.black45, width: .5),
                        )),
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
                  height: height * 0.1,
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
