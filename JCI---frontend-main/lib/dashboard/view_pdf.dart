import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jci/widgets/custAppBar.dart';
import 'package:jci/widgets/titles.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewPdf extends StatefulWidget {
  const ViewPdf({super.key});

  @override
  State<ViewPdf> createState() => _ViewPdfState();
}

class _ViewPdfState extends State<ViewPdf> {
  late final String pdfName;
  late final String pdfUrl;
  late final String fileUrl;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args is Map) {
      pdfName = '${args['pdfName'] ?? ''}';
      pdfUrl = '${args['pdfUrl'] ?? ''}';
    } else {
      pdfName = '';
      pdfUrl = '';
    }
    fileUrl = pdfUrl.isEmpty ? '' : Uri.encodeFull(pdfUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustAppBar(pdfName.isNotEmpty ? pdfName : Titles.viewPdf).initAppBar(),
      body: fileUrl.isEmpty
          ? const Center(
              child: Text(
                'Unable to open PDF',
                style: TextStyle(fontFamily: 'pop-med', fontSize: 14),
              ),
            )
          : _isImageUrl(fileUrl)
              ? InteractiveViewer(
                  minScale: 1,
                  maxScale: 4,
                  child: Center(
                    child: Image.network(
                      fileUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Text(
                        'Failed to load file',
                        style: TextStyle(fontFamily: 'pop-med', fontSize: 14),
                      ),
                    ),
                  ),
                )
              : SfPdfViewer.network(
                  fileUrl,
                  canShowScrollHead: true,
                  onDocumentLoadFailed: (details) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to load PDF: ${details.error}')),
                    );
                  },
                ),
    );
  }

  bool _isImageUrl(String url) {
    final lower = url.toLowerCase();
    return lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.webp');
  }
}
