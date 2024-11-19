import 'dart:io';

import 'package:htmltopdfwidgets/htmltopdfwidgets.dart';

createDocument(String text) async {
  const filePath = 'example.pdf';
  final file = File(filePath);
  final newpdf = Document();
  final List<Widget> widgets = await HTMLToPdf().convert(
    text,
  );

  newpdf.addPage(MultiPage(
      maxPages: 200,
      build: (context) {
        return widgets;
      }));
  await file.writeAsBytes(await newpdf.save());
}
