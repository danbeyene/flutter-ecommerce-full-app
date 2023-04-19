import 'package:flutter/material.dart';
import 'package:inspireui/inspireui.dart' show PlatformError;
import 'package:webview_flutter/webview_flutter.dart';

import '../../common/constants.dart';
import '../common/app_bar_mixin.dart';

class StaticSite extends StatefulWidget {
  final String? data;

  const StaticSite({this.data});

  @override
  State<StaticSite> createState() => _StaticSiteState();
}

class _StaticSiteState extends State<StaticSite> with AppBarMixin {
  @override
  Widget build(BuildContext context) {
    var controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadHtmlString('data:text/html;base64,${widget.data}');

    return renderScaffold(
      routeName: RouteList.html,
      child: !isMobile
          ? const PlatformError()
          : SafeArea(
              child: WebViewWidget(controller: controller),
            ),
    );
  }
}
