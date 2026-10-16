import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:qinglong_app/base/ui/loading_widget.dart';
import 'package:qinglong_app/main.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../base/theme.dart';
import 'impl.dart';

class CodeMirrorView extends CodeMirrorViewImpl {
  final CodeMirrorOptions options;

  final ValueChanged<EditorController> onCreate;

  final Function(String val) onValue;

  const CodeMirrorView({
    Key? key,
    required this.options,
    required this.onCreate,
    required this.onValue,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return CodeMirrorViewState();
  }
}

class CodeMirrorViewState extends CodeMirrorViewImplState<CodeMirrorView> {
  String getHtml(String raw) {
    String _html = raw;
    _html = _html.replaceAll('VERSION', '5.65.6');
    _html = _html.replaceAll('EDITOR_THEME', widget.options.theme);
    _html = _html.replaceAll('EDITOR_MODE', widget.options.mode);
    return Uri.dataFromString(_html, mimeType: 'text/html').toString();
  }

  WebViewController? _controller;

  bool readOnly = false;
  bool isLoaded = false;

  static bool isLoadedJs = false;
  bool isShowSearch = false;

  Future<void> showSearchBar() async {
    if (isShowSearch) {
      await _controller?.runJavaScript(
        'clearSearchText()',
      );
    } else {
      await _controller?.runJavaScript(
        'searchText()',
      );
    }
    isShowSearch = !isShowSearch;
  }

  WebViewController _createController(String rawHtml, double width, double height) {
    final controller = WebViewController();
    controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    controller.setBackgroundColor(ref.watch(themeProvider).themeColor.codeBgColor());
    controller.setNavigationDelegate(
      NavigationDelegate(
        onPageFinished: (url) {
          controller.runJavaScript(
            'editor.setSize(${width},${height})',
          );
          widget.onCreate(EditorController(
            setOptions: (val) async {
              readOnly = val.readOnly;
              controller.runJavaScript(
                'editor.setSize(${width},${height})',
              );

              await controller.runJavaScript(
                'editor.setOption("mode", "${val.mode}")',
              );
              await controller.runJavaScript(
                'editor.setOption("theme", "${val.theme}")',
              );
              await controller.runJavaScript(
                'editor.setOption("readOnly", ${val.readOnly ? '\"nocursor\"' : false})',
              );

              await controller.runJavaScript(
                'editor.setOption("lineNumbers", ${val.showLineNumber})',
              );
              await Future.delayed(
                const Duration(milliseconds: 200),
              );
              await controller.runJavaScript(
                'editor.refresh()',
              );
              await EasyLoading.dismiss();
              if (widget.options.mode != val.mode || widget.options.theme != val.theme) {
                await controller.loadRequest(Uri.parse(getHtml(rawHtml)));
              }
            },
            setValue: (val) async {
              TextPainter painter = TextPainter(
                text: TextSpan(
                  text: val,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
                textDirection: TextDirection.ltr,
              );
              painter.layout(
                maxWidth: MediaQuery.of(context).size.width,
              );
              isLoaded = true;
              final raw = Uri.encodeComponent(val);
              controller.runJavaScript('editor.setValue(decodeURIComponent("$raw"))');
            },
            refresh: () async {
              const delay = Duration(milliseconds: 50);
              await Future.delayed(delay);
              controller.runJavaScript(
                'editor.refresh()',
              );
            },
          ));
        },
      ),
    );
    controller.addJavaScriptChannel(
      'MessageInvoker',
      onMessageReceived: (event) => widget.onValue(event.message),
    );
    if (MultiAccountPageState.useAction().isEmpty) {
      if (!isLoadedJs) {
        isLoadedJs = true;
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          EasyLoading.show(status: "加载中");
        });
      }
    }
    controller.loadRequest(Uri.parse(getHtml(rawHtml)));
    return controller;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: rootBundle.loadString('assets/codemirror.html'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: LoadingWidget());
          }
          return LayoutBuilder(
            builder: (context, dimens) {
              return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
                final controller = _controller ??= _createController(
                  snapshot.data ?? "",
                  dimens.maxWidth,
                  dimens.maxHeight,
                );
                if (isLoaded) {
                  controller.runJavaScript(
                    'editor.setSize(${dimens.maxWidth},${dimens.maxHeight})',
                  );
                }
                controller.setBackgroundColor(ref.watch(themeProvider).themeColor.codeBgColor());
                return WebViewWidget(
                  controller: controller,
                );
              });
            },
          );
        });
  }
}
