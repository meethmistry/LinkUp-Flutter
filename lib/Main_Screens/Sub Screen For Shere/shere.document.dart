import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:linkup/Theme/app.theme.dart';

class ShareDocumentPage extends StatefulWidget {
  final String docUrl;

  const ShareDocumentPage({
    Key? key,
    required this.docUrl,
  }) : super(key: key);

  @override
  _ShareDocumentPageState createState() => _ShareDocumentPageState();
}

class _ShareDocumentPageState extends State<ShareDocumentPage> {
  final ThemeColors _themeColors = ThemeColors();
  String? localPath;

  @override
  void initState() {
    super.initState();
    _downloadAndSavePdf();
  }

  Future<void> _downloadAndSavePdf() async {
    try {
      final response = await http.get(Uri.parse(widget.docUrl));
      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/temp.pdf';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        setState(() {
          localPath = filePath;
        });
      } else {
        debugPrint('Failed to download document: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error downloading document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _themeColors.containerColor(context),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: _themeColors.containerColor(context),
        elevation: 0,
      ),
      body: localPath == null
          ? Center(child: CircularProgressIndicator())
          : PDFView(
              filePath: localPath!,
              enableSwipe: true,
              swipeHorizontal: false,
              autoSpacing: true,
              pageFling: true,
            ),
    );
  }
}
