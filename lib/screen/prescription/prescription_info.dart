import 'dart:io';
import 'dart:math';

import 'package:docx/utils/colors.dart';
import 'package:docx/utils/custom_text_wdget.dart';
import 'package:docx/utils/toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:html_to_pdf/html_to_pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:printing/printing.dart';

class PrescriptionInfoScreen extends StatefulWidget {
  const PrescriptionInfoScreen({super.key});

  @override
  State<PrescriptionInfoScreen> createState() => _PrescriptionInfoScreenState();
}

class _PrescriptionInfoScreenState extends State<PrescriptionInfoScreen> {
  HtmlEditorController htmlEditorController = HtmlEditorController();

  String patientInfo = "";
  String doctorInfo = "";
  String otherDetailsInfo = "";

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
            height: auto;
            padding: 10px;
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 5px;
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
            justify-content: First;
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
             margin: 0 0 0 10px;
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
        
        .footer-center {
           
            display: flex;
            justify-content:center;
            padding: 10px;
            border-top: 2px solid #ddd;
            margin-top: 20px 20px;
            color: #333;
            background-color: #fafafa;
        }
        
        .doctor-container {
           
            display: flex;
            justify-content:center;
            padding: 10px;
            border-top: 2px solid #ddd;
            margin-top: 20px 20px;
            color: #333;
            background-color: #fafafa;
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
              <p>${doctorInfo}</p>
            </div>
            <div class="middle-border"></div>
            <!-- Second Right Box -->
            <div class="details-box">
                <p>${otherDetailsInfo}</p>
            </div>
        </div>
       
        <div class="divider"></div>
         <div class="middle-box">
            <p>${patientInfo}</p>
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
    <div class="footer-center">
            <p>ডাক্তারের পরামর্শ ব্যতিত কোন ঔষধ পরিবর্তন যোগ্য নয়</p>
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

  Widget _buildPdfPreview(Uint8List pdfBytes) {
    return Container(
      color: AppColors.kBackgroundColor,
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
      child: PdfViewer.openData(
        pdfBytes,
        params: PdfViewerParams(
          pageDecoration: const BoxDecoration(),
          layoutPages: (viewSize, pages) {
            List<Rect> rect = [];
            final viewWidth = viewSize.width;
            final viewHeight = viewSize.height;
            final maxWidth = pages.fold<double>(0.0, (maxWidth, page) => max(maxWidth, page.width));
            final ratio = viewWidth / maxWidth;
            var top = 0.0;
            for (var page in pages) {
              final width = page.width * ratio;
              final height = page.height * ratio;
              final left = viewWidth > viewHeight ? (viewWidth / 2) - (width / 2) : 0.0;
              rect.add(Rect.fromLTWH(left, top, width, height));
              top += height + 8;
            }
            return rect;
          },
        ),
      ),
    );
  }

  void printRx(Uint8List data) async {
    await Printing.layoutPdf(onLayout: (_) => data);
  }

  Future<void> _showEdit(BuildContext context, int boxNumber) async {
    String currentContent = "";

    // Determine the content to load based on the box number
    if (boxNumber == 3) {
      currentContent = patientInfo;
    } else if (boxNumber == 1) {
      currentContent = doctorInfo;
    } else if (boxNumber == 2) {
      currentContent = otherDetailsInfo;
    }

    htmlEditorController.setText(currentContent);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
      ),
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Editor Area
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: HtmlEditor(
                      controller: htmlEditorController,
                      htmlEditorOptions: HtmlEditorOptions(
                          hint: 'Your text here...', shouldEnsureVisible: true, initialText: currentContent
                          //initialText: "<p>text content initial, if any</p>",
                          ),
                      htmlToolbarOptions: HtmlToolbarOptions(
                        toolbarPosition: ToolbarPosition.belowEditor,
                        toolbarType: ToolbarType.nativeScrollable,
                        defaultToolbarButtons: [
                          StyleButtons(),
                          FontButtons(
                              bold: true,
                              italic: true,
                              underline: true,
                              clearAll: false,
                              superscript: false,
                              subscript: false),
                          FontSettingButtons(
                            fontName: false,
                            fontSize: true,
                            fontSizeUnit: false,
                          ),
                          ParagraphButtons(
                              lineHeight: true,
                              caseConverter: false,
                              increaseIndent: false,
                              decreaseIndent: false,
                              textDirection: false)
                        ],
                        onButtonPressed: (ButtonType type, bool? status, Function? updateStatus) {
                          print("button '${describeEnum(type)}' pressed, the current selected status is $status");
                          return true;
                        },
                        onDropdownChanged: (DropdownType type, dynamic changed, Function(dynamic)? updateSelectedItem) {
                          print("dropdown '${describeEnum(type)}' changed to $changed");
                          return true;
                        },
                        mediaLinkInsertInterceptor: (String url, InsertFileType type) {
                          print(url);
                          return true;
                        },
                        mediaUploadInterceptor: (PlatformFile file, InsertFileType type) async {
                          print(file.name);
                          print(file.size);
                          print(file.extension);
                          return true;
                        },
                      ),
                      otherOptions: OtherOptions(height: 550),
                      callbacks: Callbacks(onBeforeCommand: (String? currentHtml) {
                        print('html before change is $currentHtml');
                      }, onChangeContent: (String? changed) {
                        print('content changed to $changed');
                      }, onChangeCodeview: (String? changed) {
                        print('code changed to $changed');
                      }, onChangeSelection: (EditorSettings settings) {
                        print('parent element is ${settings.parentElement}');
                        print('font name is ${settings.fontName}');
                      }, onDialogShown: () {
                        print('dialog shown');
                      }, onEnter: () {
                        print('enter/return pressed');
                      }, onFocus: () {
                        print('editor focused');
                      }, onBlur: () {
                        print('editor unfocused');
                      }, onBlurCodeview: () {
                        print('codeview either focused or unfocused');
                      }, onInit: () {
                        print('init');
                      }, onImageUploadError: (FileUpload? file, String? base64Str, UploadError error) {
                        print(describeEnum(error));
                        print(base64Str ?? '');
                        if (file != null) {
                          print(file.name);
                          print(file.size);
                          print(file.type);
                        }
                      }, onKeyDown: (int? keyCode) {
                        print('$keyCode key downed');
                        print('current character count: ${htmlEditorController.characterCount}');
                      }, onKeyUp: (int? keyCode) {
                        print('$keyCode key released');
                      }, onMouseDown: () {
                        print('mouse downed');
                      }, onMouseUp: () {
                        print('mouse released');
                      }, onNavigationRequestMobile: (String url) {
                        print(url);
                        return NavigationActionPolicy.ALLOW;
                      }, onPaste: () {
                        print('pasted into editor');
                      }, onScroll: () {
                        print('editor scrolled');
                      }),
                      plugins: [
                        SummernoteAtMention(
                            getSuggestionsMobile: (String value) {
                              var mentions = <String>['test1', 'test2', 'test3'];
                              return mentions.where((element) => element.contains(value)).toList();
                            },
                            mentionsWeb: ['test1', 'test2', 'test3'],
                            onSelect: (String value) {
                              print(value);
                            }),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        htmlEditorController.clear(); // Close the bottom sheet
                      },
                      icon: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: const Icon(Icons.refresh, color: Colors.white),
                      ),
                      label: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: const Text(
                          'Reset',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        String? content = await htmlEditorController.getText();
                        if (content.trim().isNotEmpty) {
                          setState(() {
                            if (boxNumber == 3) {
                              patientInfo = content;
                            } else if (boxNumber == 1) {
                              doctorInfo = content;
                            } else if (boxNumber == 2) {
                              otherDetailsInfo = content;
                            }
                          });
                          Navigator.pop(context); // Close the bottom sheet or dialog
                        } else {
                          Toast.showErrorToast(
                            "Empty field",
                          );
                        }
                      },
                      icon: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: const Icon(Icons.save, color: Colors.white),
                      ),
                      label: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: const Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    /*Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Container(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              htmlEditorController.clear(); // Close the bottom sheet
                            },
                            icon: const Icon(Icons.refresh, color: Colors.white),
                            label: const Text(
                              'Reset',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Container(
                          width: double.infinity,
                          child: ElevatedButton.icon(
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
                                  if (boxNumber == 3) {
                                    patientInfo = content;
                                  } else if (boxNumber == 1) {
                                    doctorInfo = content;
                                  } else if (boxNumber == 2) {
                                    otherDetailsInfo = content;
                                  }
                                });
                                Navigator.pop(context); // Close the bottom sheet
                              }
                            },
                            icon: const Icon(Icons.save, color: Colors.white),
                            label: const Text(
                              'Save',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),*/
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                final pdfBytes = await _getPdf(patientInfo + doctorInfo + otherDetailsInfo);
                if (pdfBytes != null) {
                  await Printing.layoutPdf(
                    usePrinterSettings: false,
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
          style: TextStyle(fontFamily: 'NotoSans', fontSize: 24.5, fontWeight: FontWeight.w900, color: Colors.white),
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
                    Flexible(
                      child: Container(
                        width: width,
                        //height: height * 0.3,
                        decoration: BoxDecoration(
                            border: Border(
                          top: BorderSide(color: Colors.black45, width: 1), // Top border
                          right: BorderSide(color: Colors.black45, width: 1),
                          //bottom: BorderSide(color: Colors.black45, width: .5),
                        )),
                        child: TextButton(
                          onPressed: () => _showEdit(context, 1),
                          child: doctorInfo.isEmpty ? Text('+ Add Doctor Information') : HtmlWidget(doctorInfo),
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
                          top: BorderSide(color: Colors.black45, width: 1), // Top border
                          left: BorderSide(color: Colors.black45, width: 1),
                          //bottom: BorderSide(color: Colors.black45, width: .5),
                        )),
                        child: TextButton(
                          onPressed: () => _showEdit(context, 2),
                          child:
                              otherDetailsInfo.isEmpty ? Text('+ Add Other Information') : HtmlWidget(otherDetailsInfo),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Divider(thickness: 2),
                Container(
                  width: width,
                  //height: height * 0.1,
                  decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.black12)),
                  child: TextButton(
                    onPressed: () => _showEdit(context, 3),
                    child: patientInfo.isEmpty ? Text('+ Add Patient Information') : HtmlWidget(patientInfo),
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
                ),
                SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
