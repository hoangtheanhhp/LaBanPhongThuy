import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../core/constants/app_colors.dart';

class LookupWebViewScreen extends StatefulWidget {
  final String onlineUrl;
  const LookupWebViewScreen({
    super.key,
    this.onlineUrl = 'https://labanphongthuy-web.pages.dev/',
  });

  @override
  State<LookupWebViewScreen> createState() => _LookupWebViewScreenState();
}

class _LookupWebViewScreenState extends State<LookupWebViewScreen>
    with AutomaticKeepAliveClientMixin {
  late final WebViewController _controller;
  int _loadingProgress = 0;
  bool _hasError = false;
  bool _isOnlineMode = true;

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
      );

    _loadContent();
  }

  void _loadContent() {
    if (_isOnlineMode && widget.onlineUrl.isNotEmpty) {
      _controller.loadRequest(Uri.parse(widget.onlineUrl));
    } else {
      // Tải webapp tra cứu Bát Quái Phong Thuỷ tích hợp sẵn trong assets
      _controller.loadFlutterAsset('assets/web/index.html');
    }
  }

  void _toggleSource() {
    setState(() {
      _isOnlineMode = !_isOnlineMode;
      _hasError = false;
      _loadingProgress = 0;
    });
    _loadContent();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isOnlineMode
              ? 'Đang kết nối cổng tra cứu trực tuyến'
              : 'Đang dùng cổng tra cứu phong thuỷ tích hợp (Offline)',
          style: const TextStyle(color: AppColors.ivoryWhite),
        ),
        backgroundColor: AppColors.surfaceElevated,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text(
          'Tra Cứu Bát Quái Phong Thuỷ',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.ivoryWhite, fontSize: 16.5),
        ),
        backgroundColor: AppColors.surfaceCard,
        elevation: 0,
        actions: [
          // Nút chuyển đổi giữa bản tích hợp & bản trực tuyến (nếu có cấu hình onlineUrl)
          if (widget.onlineUrl.isNotEmpty)
            IconButton(
              icon: Icon(
                _isOnlineMode ? Icons.cloud_outlined : Icons.offline_pin_outlined,
                color: AppColors.woodAccent,
              ),
              tooltip: _isOnlineMode ? 'Bản Online' : 'Bản Tích hợp',
              onPressed: _toggleSource,
            ),
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.woodAccent),
            tooltip: 'Tải lại trang',
            onPressed: () {
              setState(() => _hasError = false);
              _loadContent();
            },
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
                      'Chuyển sang bản tra cứu phong thuỷ tích hợp sẵn trong ứng dụng để tiếp tục.',
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
                      onPressed: () {
                        setState(() {
                          _isOnlineMode = false;
                          _hasError = false;
                        });
                        _loadContent();
                      },
                      icon: const Icon(Icons.auto_stories_outlined),
                      label: const Text('Mở Bản Tra Cứu Tích Hợp', style: TextStyle(fontWeight: FontWeight.bold)),
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
