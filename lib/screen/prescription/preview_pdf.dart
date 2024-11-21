import 'dart:math';
import 'dart:typed_data';

import 'package:docx/utils/colors.dart';
import 'package:docx/utils/navigation_item.dart';
import 'package:flutter/material.dart';
import 'package:pdf_render/pdf_render_widgets.dart';

class PdfPreviewScreen extends StatefulWidget {
  final Uint8List pdfBytes;

  PdfPreviewScreen({required this.pdfBytes});

  @override
  State<PdfPreviewScreen> createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(200, 100, 100, 200),
        title: const Text(
          'Prescription view',
          style: TextStyle(fontFamily: 'NotoSans', fontSize: 24.5, fontWeight: FontWeight.w900, color: Colors.white),
        ),
      ),
      body: Container(
        color: Colors.grey[200], // Replace with AppColors.kBackgroundColor.
        padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
        child: PdfViewer.openData(
          widget.pdfBytes!,
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
      ),
      bottomNavigationBar: SafeArea(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.kCardColor,
            boxShadow: [
              BoxShadow(
                blurRadius: 2,
                color: Colors.grey.withOpacity(0.15),
                offset: const Offset(0, -2.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LayoutBuilder(
                builder: (_, constraints) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: constraints.maxWidth),
                      child: IntrinsicWidth(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            NavigationItem(
                              label: 'Share',
                              icon: Icon(Icons.share),
                              onPressed: () async {},
                            ),
                            NavigationItem(
                              label: 'Download',
                              icon: Icon(Icons.download),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
