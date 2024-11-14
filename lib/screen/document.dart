import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_to_pdf/flutter_quill_to_pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../utils/colors.dart';
import 'fort_loader.dart';

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({super.key});

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  late FontLoader loader;
  bool firstEntry = false;
  final PDFPageFormat params = PDFPageFormat.a4;
  final QuillController _quillController =
      QuillController(document: Document(), selection: const TextSelection.collapsed(offset: 0));
  final FocusNode _editorNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _shouldShowToolbar = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _quillController.dispose();
    _editorNode.dispose();
    _scrollController.dispose();
    _shouldShowToolbar.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    loader = FontLoader();
  }

  @override
  Widget build(BuildContext context) {
    //Navigator.pop(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 107, 188, 255),
        actions: [
          IconButton(
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return const LoadingWithAnimtedWidget(
                        text: 'Creating document...',
                        infinite: true,
                        loadingColor: Color.fromARGB(255, 108, 189, 255),
                      );
                    });
                final String? result = await FilePicker.platform.getDirectoryPath();
                if (result == null) {
                  Navigator.pop(context);
                  return;
                }
                File file = File('$result/document_demo_quill_to_pdf.pdf');
                FontLoader loader = FontLoader();
                PDFConverter pdfConverter = PDFConverter(
                  backMatterDelta: null,
                  frontMatterDelta: null,
                  document: _quillController.document.toDelta(),
                  fallbacks: [],

                  pageFormat: params, // Use your desired page format (e.g., PdfPageFormat.a4)
                );
                final pw.Document? document = await pdfConverter.createDocument();
                if (document == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('The file cannot be generated by an unknown error')),
                  );
                  _editorNode.unfocus();
                  _shouldShowToolbar.value = false;
                  Navigator.pop(context);
                  return;
                }
                await file.writeAsBytes(await document.save());
                _editorNode.unfocus();
                _shouldShowToolbar.value = false;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Generated document at path: ${file.path}')),
                );
              },
              icon: const Icon(
                Icons.print,
                color: Colors.white,
              )),
        ],
        centerTitle: true,
        title: const Text(
          'PDF Demo',
          style: TextStyle(fontFamily: 'Noto Sans', fontSize: 24.5, fontWeight: FontWeight.w900, color: Colors.white),
        ),
      ),
      body: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: <Widget>[
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Scrollbar(
                controller: _scrollController,
                notificationPredicate: (ScrollNotification notification) {
                  if (mounted && firstEntry) {
                    firstEntry = false; //avoid issue with column (Ln225,Col49) that mnakes false scroll
                    setState(() {});
                  }
                  return notification.depth == 0;
                },
                interactive: true,
                radius: const Radius.circular(10),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                        child: QuillEditor(
                          focusNode: _editorNode,
                          controller: _quillController,
                          scrollController: _scrollController,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1), // Black border with 2px width
                          borderRadius: BorderRadius.circular(4),
                          color: AppColors.kWarningToastBgColor),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: QuillSimpleToolbar(
                          controller: _quillController,
                          configurations: const QuillSimpleToolbarConfigurations(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoadingWithAnimtedWidget extends StatelessWidget {
  final String text;
  final double verticalTextPadding;
  final double? heightWidget;
  final double? spaceBetween;
  final double strokeWidth;
  final TextStyle? style;
  final Duration duration;
  final Color? loadingColor;
  final bool infinite;
  const LoadingWithAnimtedWidget({
    super.key,
    required this.text,
    this.loadingColor,
    this.strokeWidth = 7,
    this.spaceBetween,
    this.duration = const Duration(milliseconds: 260),
    this.infinite = false,
    this.style,
    this.heightWidget,
    this.verticalTextPadding = 30,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return PopScope(
      canPop: false,
      child: Dialog(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        child: SizedBox(
          height: heightWidget ?? size.height * 0.45,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(
                  strokeWidth: strokeWidth,
                  color: loadingColor,
                ),
                SizedBox(height: spaceBetween ?? 10),
                AnimatedWavyText(
                  infinite: infinite,
                  duration: duration,
                  text: text,
                  style: style ?? const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  verticalPadding: verticalTextPadding,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedWavyText extends StatelessWidget {
  final double verticalPadding;
  final Key? animatedKey;
  final String text;
  final bool infinite;
  final int totalRepeatCount;
  final Duration duration;
  final TextStyle? style;
  const AnimatedWavyText({
    super.key,
    this.animatedKey,
    this.verticalPadding = 50,
    required this.text,
    this.infinite = false,
    this.totalRepeatCount = 4,
    this.duration = const Duration(milliseconds: 260),
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: AnimatedTextKit(
        key: animatedKey,
        repeatForever: infinite,
        animatedTexts: <AnimatedText>[
          WavyAnimatedText(
            text,
            speed: duration,
            textStyle: style ??
                const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
        displayFullTextOnTap: true,
        totalRepeatCount: totalRepeatCount < 1 ? 1 : totalRepeatCount,
      ),
    );
  }
}