import 'dart:io';

import 'package:docx/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html_to_pdf/html_to_pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

import '../../utils/custom_text_wdget.dart';
import '../../utils/toast.dart';
import '../prescription/preview_pdf.dart';
import 'format.dart';

class QuilToHtmlScreen extends StatefulWidget {
  const QuilToHtmlScreen({super.key});

  @override
  State<QuilToHtmlScreen> createState() => _QuilToHtmlScreenState();
}

class _QuilToHtmlScreenState extends State<QuilToHtmlScreen> {
  final QuillEditorController controller = QuillEditorController();
  String patientInfo = "";
  String doctorInfo = "";
  String otherDetailsInfo = "";

  void getHtmlText() async {
    String? htmlText = await controller.getText();
    debugPrint(htmlText);
  }

  final customToolBarList = [
    //ToolBarStyle.size,
    ToolBarStyle.headerOne,
    ToolBarStyle.headerTwo,
    //ToolBarStyle.color,
    ToolBarStyle.bold,
    ToolBarStyle.italic,
    ToolBarStyle.underline,
    ToolBarStyle.align,
  ];

  final _toolbarColor = Colors.white;
  final _backgroundColor = Colors.white;
  final _toolbarIconColor = Colors.black87;
  final _editorTextStyle = const TextStyle(
      fontSize: 16,
      color: Colors.black,
      fontWeight: FontWeight.normal,
      letterSpacing: 1.0,
      fontFamily: 'Roboto');
  final _hintTextStyle = const TextStyle(
      fontSize: 16, color: Colors.grey, fontWeight: FontWeight.normal);

  bool _hasFocus = false;

  String _applyLineHeight(String htmlContent) {
    return '''
  <style>
    * { line-height: 1.0; margin: 0; padding: 0; }
  </style>
  $htmlContent
  ''';
  }

  Future<File> _getPdf(String htmlContent) async {
    Directory appDirectory = await getApplicationDocumentsDirectory();

    final generatedPdfFile = await HtmlToPdf.convertFromHtmlContent(
      htmlContent: _applyLineHeight(
        getHtmlContentFull(doctorInfo, otherDetailsInfo, patientInfo),
      ),
      //htmlContent: getHtmlContentFull(doctorInfo, otherDetailsInfo, patientInfo),
      printPdfConfiguration: PrintPdfConfiguration(
        targetDirectory: appDirectory.path,
        targetName: 'document',
        printSize: PrintSize.A4,
        printOrientation: PrintOrientation.Portrait,
      ),
    );
    return generatedPdfFile;
  }

  Future<void> _showEditor(BuildContext context, int boxNumber) async {
    String? htmlText = await controller.getText();
    String currentContent = boxNumber == 3
        ? patientInfo
        : boxNumber == 1
        ? doctorInfo
        : otherDetailsInfo;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.kLightYellowColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setBottomSheetState) {
          bool _isSaving = false;
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 12,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: QuillHtmlEditor(
                        hintText: 'Type here',
                        hintTextStyle: _hintTextStyle,
                        backgroundColor: _backgroundColor,
                        text: currentContent.isEmpty ? htmlText : currentContent,
                        controller: controller,
                        minHeight: MediaQuery.of(context).size.height * 0.3,
                        textStyle: _editorTextStyle.copyWith(height: 1.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ToolBar(
                    toolBarColor: _toolbarColor,
                    padding: const EdgeInsets.all(8),
                    iconSize: 25,
                    iconColor: _toolbarIconColor,
                    activeIconColor: Colors.red,
                    controller: controller,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    direction: Axis.horizontal,
                    toolBarConfig: customToolBarList,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        controller.clear(); // Close the bottom sheet
                      },
                      icon: const Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Icon(Icons.refresh, color: Colors.white),
                      ),
                      label: const Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Text(
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
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        String? content = await controller.getText();
                        if (content.trim().isEmpty && content == '') {
                          //Toast.showErrorToast("Empty field",);
                          Fluttertoast.showToast(
                              msg: 'Empty field',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                          print('empty');

                        } else {
                          setBottomSheetState(() => _isSaving = true);
                          await Future.delayed(const Duration(seconds: 1));
                          setState(() {
                            if (boxNumber == 3) patientInfo = content;
                            if (boxNumber == 1) doctorInfo = content;
                            if (boxNumber == 2) otherDetailsInfo = content;
                          });
                          setBottomSheetState(() => _isSaving = false);
                          Navigator.pop(context);
                        }

                      },
                      icon: const Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Icon(Icons.save, color: Colors.white),
                      ),
                      label: const Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ],
            ),
          );
        },
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
              String? htmlText = await controller.getText();
              final pdfFile = await _getPdf(htmlText);
              Navigator.of(context).push(CupertinoPageRoute(
                builder: (_) => PdfPreviewScreen(
                  pdfFile: pdfFile,
                ),
              ));
            },
            icon: const Icon(
              Icons.picture_as_pdf_sharp,
              color: Colors.white,
            ),
          ),
        ],
        title: const Text(
          'Prescription',
          style: TextStyle(
              fontFamily: 'NotoSans',
              fontSize: 24.5,
              fontWeight: FontWeight.w900,
              color: Colors.white),
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
                          top: BorderSide(
                              color: Colors.black45, width: 1), // Top border
                          right: BorderSide(color: Colors.black45, width: 1),
                          //bottom: BorderSide(color: Colors.black45, width: .5),
                        )),
                        child: TextButton(
                            onPressed: () => _showEditor(context, 1),
                            child: doctorInfo.isEmpty
                                ? Text('+ Add Doctor Information')
                                : HtmlWidget(
                                    doctorInfo,
                                    customStylesBuilder: (element) {
                                      return {
                                        'margin': '0',
                                        'padding': '0',
                                        'line-height': '1.1',
                                      };
                                    },
                                    textStyle: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  )),
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
                          top: BorderSide(
                              color: Colors.black45, width: 1), // Top border
                          left: BorderSide(color: Colors.black45, width: 1),
                          //bottom: BorderSide(color: Colors.black45, width: .5),
                        )),
                        child: TextButton(
                            onPressed: () => _showEditor(context, 2),
                            child: otherDetailsInfo.isEmpty
                                ? Text('+ Add Other Information')
                                : HtmlWidget(
                                    otherDetailsInfo,
                                    customStylesBuilder: (element) {
                                      return {
                                        'margin': '0',
                                        'padding': '0',
                                        'line-height': '1.1',
                                      };
                                    },
                                    textStyle: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  )),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Divider(thickness: 2),
                Container(
                  width: width,
                  //height: height * 0.1,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.black12)),
                  child: TextButton(
                      onPressed: () => _showEditor(context, 3),
                      child: patientInfo.isEmpty
                          ? Text('+ Add Patient Information')
                          : HtmlWidget(
                              patientInfo,
                              customStylesBuilder: (element) {
                                return {
                                  'margin': '0',
                                  'padding': '0',
                                  'line-height': '1.1',
                                };
                              },
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            )),
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
                            top: BorderSide(
                                color: Colors.black45,
                                width: 1.5), // Top border
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
                          top: BorderSide(
                              color: Colors.black45, width: 1.5), // Top border
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
