import 'package:flutter/material.dart';
import 'package:native_download_manager/native_download_manager.dart';

void main() {
  runApp(const DownloadManagerTestApp());
}

class DownloadManagerTestApp extends StatelessWidget {
  const DownloadManagerTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Native Download Manager Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const DownloadManagerTestScreen(),
    );
  }
}

class DownloadManagerTestScreen extends StatefulWidget {
  const DownloadManagerTestScreen({super.key});

  @override
  State<DownloadManagerTestScreen> createState() => _DownloadManagerTestScreenState();
}

class _DownloadManagerTestScreenState extends State<DownloadManagerTestScreen> {
  final TextEditingController _urlController = TextEditingController(
    text: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
  );
  final TextEditingController _fileNameController = TextEditingController(
    text: 'sample_document.pdf',
  );

  final List<Map<String, String>> _sampleFiles = [
    {
      'title': 'Sample PDF (Dummy PDF)',
      'url': 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
      'fileName': 'dummy.pdf',
    },
    {
      'title': 'Sample Image (JPEG)',
      'url': 'https://picsum.photos/1200/800.jpg',
      'fileName': 'sample_image.jpg',
    },
    {
      'title': 'Sample Video (MP4)',
      'url': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      'fileName': 'sample_video.mp4',
    },
  ];

  @override
  void dispose() {
    _urlController.dispose();
    _fileNameController.dispose();
    super.dispose();
  }

  void _startDownloadWithDialog() {
    final url = _urlController.text.trim();
    final fileName = _fileNameController.text.trim();

    if (url.isEmpty || fileName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid URL and File Name')),
      );
      return;
    }

    AppDownloadService.downloadWithDialog(
      context: context,
      url: url,
      fileName: fileName,
    );
  }

  void _startBackgroundDownload() {
    final url = _urlController.text.trim();
    final fileName = _fileNameController.text.trim();

    if (url.isEmpty || fileName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid URL and File Name')),
      );
      return;
    }

    AppDownloadService.startDownload(
      url: url,
      fileName: fileName,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Download started in background: $fileName')),
    );
  }

  void _showAllDownloads() {
    AppDownloadService.showDownloadsDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Native Download Manager Test'),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.folder_special),
            tooltip: 'View All Downloads',
            onPressed: _showAllDownloads,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Embedded Live Download Widget Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.downloading, color: Color(0xFF6366F1)),
                        const SizedBox(width: 8),
                        Text(
                          'Live Download Status',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    AppDownloadService.currentDownloadWidget(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Download Input Form
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Custom Download Request',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _urlController,
                      decoration: const InputDecoration(
                        labelText: 'Download URL',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.link),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _fileNameController,
                      decoration: const InputDecoration(
                        labelText: 'File Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.insert_drive_file),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _startDownloadWithDialog,
                            icon: const Icon(Icons.open_in_new),
                            label: const Text('With Modal Dialog'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _startBackgroundDownload,
                            icon: const Icon(Icons.download),
                            label: const Text('Background'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Quick Samples Section
            Text(
              'Sample Test Downloads',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            ..._sampleFiles.map((sample) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8.0),
                child: ListTile(
                  leading: const Icon(Icons.file_present, color: Color(0xFF6366F1)),
                  title: Text(sample['title']!),
                  subtitle: Text(sample['fileName']!),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.open_in_browser),
                        tooltip: 'Download with Dialog',
                        onPressed: () {
                          setState(() {
                            _urlController.text = sample['url']!;
                            _fileNameController.text = sample['fileName']!;
                          });
                          AppDownloadService.downloadWithDialog(
                            context: context,
                            url: sample['url']!,
                            fileName: sample['fileName']!,
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.file_download),
                        tooltip: 'Background Download',
                        onPressed: () {
                          AppDownloadService.startDownload(
                            url: sample['url']!,
                            fileName: sample['fileName']!,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Downloading ${sample['fileName']}...'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _showAllDownloads,
              icon: const Icon(Icons.history),
              label: const Text('Open Downloads History Dialog'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
