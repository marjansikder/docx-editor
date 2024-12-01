import 'package:docx/screen/other_practise/doc_edit_screen.dart';
import 'package:docx/screen/other_practise/document.dart';
import 'package:docx/screen/other_practise/quil_to_html_screen.dart';
import 'package:docx/screen/prescription/prescription_info.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Document',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Jost',
      ),
      home: DocumentScreen(),
      //home: HtmlEditorExample(title: 'Flutter HTML Editor Example'),
    );
  }
}
