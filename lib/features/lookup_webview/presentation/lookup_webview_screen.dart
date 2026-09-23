import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../core/constants/app_colors.dart';

class LookupWebViewScreen extends StatefulWidget {
  final String initialUrl;
  const LookupWebViewScreen({
    super.key,
    this.initialUrl = 'https://fengshui-lookup-placeholder.web.app',
  });

  @override
  State<LookupWebViewScreen> createState() => _LookupWebViewScreenState();
}

class _LookupWebViewScreenState extends State<LookupWebViewScreen>
    with AutomaticKeepAliveClientMixin {
  late final WebViewController _controller;
  int _loadingProgress = 0;
  bool _hasError = false;

  @override
  bool get wantKeepAlive => true; // Keep state when switching navigation tabs

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.darkBackground)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            if (mounted) setState(() => _loadingProgress = progress);
          },
          onPageStarted: (url) {
            if (mounted) setState(() => _hasError = false);
          },
          onWebResourceError: (error) {
            if (mounted) setState(() => _hasError = true);
          },
        ),
      )
      ..addJavaScriptChannel(
        'FlutterBridge',
        onMessageReceived: (message) {
          debugPrint('PWA message: ${message.message}');
        },
      )
      ..loadRequest(Uri.parse(widget.initialUrl));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text('Tra Cứu Bát Quái & Phong Thuỷ', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.ivoryWhite)),
        backgroundColor: AppColors.surfaceCard,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.woodAccent),
            tooltip: 'Tải lại trang',
            onPressed: () => _controller.reload(),
          ),
        ],
      ),
      body: Stack(
        children: [
          if (!_hasError)
            WebViewWidget(controller: _controller)
          else
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud_off_rounded, size: 72, color: Colors.white30),
                    const SizedBox(height: 16),
                    const Text(
                      'Không thể kết nối Cổng Tra Cứu Trực Tuyến',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Vui lòng kiểm tra kết nối mạng của thiết bị và thử lại.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white54, fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.woodAccent,
                        foregroundColor: const Color(0xFF141414),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      onPressed: () => _controller.reload(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Thử lại', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
          if (_loadingProgress < 100 && !_hasError)
            LinearProgressIndicator(
              value: _loadingProgress / 100.0,
              backgroundColor: Colors.transparent,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.woodAccent),
            ),
        ],
      ),
    );
  }
}
