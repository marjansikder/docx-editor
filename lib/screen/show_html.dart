import 'dart:io';

import 'package:docx/screen/prescription_format.dart';
import 'package:docx/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:html_to_pdf/html_to_pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:uuid/uuid.dart';

class ShowHtmlScreen extends StatefulWidget {
  const ShowHtmlScreen({super.key});

  @override
  State<ShowHtmlScreen> createState() => _ShowHtmlScreenState();
}

class _ShowHtmlScreenState extends State<ShowHtmlScreen> {
  static const headerName = 'Header';
  static const primaryContent = 'Dhaka Cantonment';
  static const secondaryContent = 'Bangladesh';

  static const htmlDataFormat = """
<h1>Header 1</h1>
<h2>Header 2</h2>
<h3>Header 3</h3>
<h4>Header 4</h4>
<h5>Header 5</h5>
<h6>Header 6</h6>
<h3>Ruby Support:</h3>
      <p>
        <ruby>
          漢<rt>かん</rt>
          字<rt>じ</rt>
        </ruby>
        &nbsp;is Japanese Kanji.
      </p>
      <h3>Support for <code>sub</code>/<code>sup</code></h3>
      Solve for <var>x<sub>n</sub></var>: log<sub>2</sub>(<var>x</var><sup>2</sup>+<var>n</var>) = 9<sup>3</sup>
      <p>One of the most <span>common</span> equations in all of physics is <br /><var>E</var>=<var>m</var><var>c</var><sup>2</sup>.</p>
      <h3>Table support (with custom styling!):</h3>
      <p>
      <q>Famous quote...</q>
      </p>
      <table class="table">
      <colgroup>
        <col width="50%" />
        <col width="25%" />
        <col width="25%" />
      </colgroup>
      <thead>
      <tr ><th>One</th><th>Two</th><th>Three</th></tr>
      </thead>
      <tbody>
      <tr>
        <td>Data</td><td>Data</td><td>Data</td>
      </tr>
      <tr>
        <td>Data</td><td>Data</td><td>Data</td>
      </tr>
      </tbody>
      <tfoot>
      <tr><td>fData</td><td>fData</td><td>fData</td></tr>
      </tfoot>
      </table>
      <h3>Custom Element Support:</h3>
      <flutter></flutter>
      <flutter horizontal></flutter>
      <h3>SVG support:</h3>
      <svg id='svg1' viewBox='0 0 100 100' xmlns='http://www.w3.org/2000/svg'>
            <circle r="32" cx="35" cy="65" fill="#F00" opacity="0.5"/>
            <circle r="32" cx="65" cy="65" fill="#0F0" opacity="0.5"/>
            <circle r="32" cx="50" cy="35" fill="#00F" opacity="0.5"/>
      </svg>
      <h3 class="highlight">List support:</h3>
      <ol>
            <li>This</li>
            <li><p>is</p></li>
            <li>an</li>
            <li>
            ordered
            <ul>
            <li>With<br /><br />...</li>
            <li>a</li>
            <li>nested</li>
            <li>unordered
            <ol>
            <li>With a nested</li>
            <li>ordered list.</li>
            </ol>
            </li>
            <li>list</li>
            </ul>
            </li>
            <li>list! Lorem ipsum dolor sit amet.</li>
            <li><h2>Header 2</h2></li>
            <h2><li>Header 2</li></h2>
      </ol>
      <h3>Link support:</h3>
      <p>
        Linking to <a href='https://github.com'>websites</a> has never been easier.
      </p>
""";

  final htmlCode = """ <div id="header-editable" style="margin: 0 10px">
     <div id="header-name" data-placeholder='name' class="area-selector editable" style="text-align: center; position: relative;">
      ${headerName}
    </div>
    <div id="header-content" style="width100%; display: grid; grid-template-areas: 'primary secondary'; gap: 10px; font-size: 14px; grid-template-columns: 49% 49%">
    <div class="editor-selector editable area-selector" data-placeholder='primary' style="padding: 10px; margin-left: 5px; position: relative; grid-area: primary">
      ${primaryContent}
    </div>
    <div data-placeholder='secondary' style="padding: 10px; margin-right: 5px; position: relative; grid-area: secondary; text-align: right" class="editor-selector editor-secondary editable area-selector">
      ${secondaryContent}
    </div>
    </div>
    </div>""";

  var uuid = Uuid();

  Future<Uint8List?> _getPdf() async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    final targetPath = appDirectory.path;
    final documentName = "document_${uuid.v1().toString()}.pdf";

    final generatedPdfFile = await HtmlToPdf.convertFromHtmlContent(
      htmlContent: prescriptionFormat,
      printPdfConfiguration: PrintPdfConfiguration(
        targetDirectory: targetPath,
        targetName: documentName,
        printSize: PrintSize.A4,
        printOrientation: PrintOrientation.Portrait,
      ),
    );

    return generatedPdfFile.readAsBytes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Html Doc",
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              onPressed: () async {
                final pdfBytes = await _getPdf();
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
      ),
      body: SingleChildScrollView(
          //scrollDirection: Axis.horizontal,
          child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1), // Black border with 2px width
            borderRadius: BorderRadius.circular(4),
            color: AppColors.kWarningToastBgColor.withOpacity(.8)),
        child: HtmlWidget(
          prescriptionFormat,
          customStylesBuilder: (element) {
            if (element.classes.contains('highlight')) {
              return {
                'color': 'red',
                'font-weight': 'bold',
                'background-color': 'yellow',
              };
            }
            if (element.classes.contains('table')) {
              return {
                'background-color': 'grey',
              };
            }
            return null; // Return null for elements without custom styles.
          },
        ),
      )),
    );
  }
}
