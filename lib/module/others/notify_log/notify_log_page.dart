import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/http/http.dart';
import 'package:qinglong_app/base/ql_app_bar.dart';
import 'package:qinglong_app/base/single_account_page.dart';
import 'package:qinglong_app/base/theme.dart';
import 'package:qinglong_app/base/ui/enable_widget.dart';
import 'package:qinglong_app/base/ui/lazy_load_state.dart';
import 'package:qinglong_app/base/ui/loading_widget.dart';
import 'package:qinglong_app/utils/extension.dart';
import 'package:qinglong_app/utils/utils.dart';

import 'notify_log_bean.dart';

/// 通知审计日志（青龙 2.24.0+）
class NotifyLogPage extends ConsumerStatefulWidget {
  const NotifyLogPage({Key? key}) : super(key: key);

  @override
  _NotifyLogPageState createState() => _NotifyLogPageState();
}

class _NotifyLogPageState extends ConsumerState<NotifyLogPage>
    with LazyLoadState<NotifyLogPage> {
  List<NotifyLogBean> list = [];

  /// 只显示失败的
  bool onlyFailed = false;

  List<NotifyLogBean> get shown =>
      onlyFailed ? list.where((e) => e.status != 0).toList() : list;

  @override
  Widget build(BuildContext context) {
    final data = shown;
    return Scaffold(
      appBar: QlAppBar(
        canBack: true,
        backCall: () {
          Navigator.of(context).pop();
        },
        title: "通知日志",
        actions: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: Text(
              onlyFailed ? "全部" : "仅失败",
              style: TextStyle(
                fontSize: 14,
                color: ref.watch(themeProvider).themeColor.title2Color(),
              ),
            ),
            onPressed: () {
              setState(() {
                onlyFailed = !onlyFailed;
              });
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: data.isEmpty
          ? Center(
              child: Text(
                onlyFailed ? "没有失败的通知" : "暂无通知记录",
                style: TextStyle(
                  fontSize: 14,
                  color: ref.watch(themeProvider).themeColor.descColor(),
                ),
              ),
            )
          : ListView.separated(
              primary: true,
              itemCount: data.length,
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(indent: 15, height: 1);
              },
              itemBuilder: (context, index) {
                final item = data[index];
                final ok = item.status == 0;
                return _buildItem(context, item, ok);
              },
            ),
    );
  }

  Widget _buildItem(BuildContext context, NotifyLogBean item, bool ok) {
    final themeColor = ref.watch(themeProvider).themeColor;
    final maxWidth = MediaQuery.of(context).size.width / 1.7;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _showDetail(item),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints.loose(Size.fromWidth(maxWidth)),
                      child: Text(
                        item.title?.isNotEmpty == true ? item.title! : "(无标题)",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: themeColor.titleColor(),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: StatusWidget(
                        title: ok ? "成功" : "失败",
                        color: ok
                            ? ref.watch(themeProvider).primaryColor
                            : const Color(0xffFB5858),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (item.notifyType?.isNotEmpty == true)
                      _tag("渠道 ${_prettyType(item.notifyType!)}", themeColor),
                    if ((item.source ?? '') == 'script')
                      _tag(
                        "脚本 ${item.scriptName ?? ''}",
                        themeColor,
                      ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              Utils.formatMessageTime(item.timestamp ?? 0),
              style: TextStyle(fontSize: 12, color: themeColor.descColor()),
            ),
          ),
          const SizedBox(width: 15),
        ],
      ),
    );
  }

  Widget _tag(String text, dynamic themeColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: themeColor.descColor(), width: 0.5),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 11, color: themeColor.descColor()),
      ),
    );
  }

  static String _prettyType(String raw) {
    const map = {
      'weWorkBot': '企业微信机器人',
      'weWorkApp': '企业微信应用',
      'serverChan': 'Server酱',
      'telegramBot': 'Telegram',
      'dingtalkBot': '钉钉',
      'pushPlus': 'PushPlus',
      'webhook': '自定义通知',
      'bark': 'Bark',
      'gotify': 'Gotify',
      'ntfy': 'Ntfy',
      'email': '邮箱',
      'lark': '飞书',
      'chat': '群晖chat',
      'iGot': 'IGot',
      'pushDeer': 'PushDeer',
      'pushMe': 'PushMe',
      'wpush': 'WPUSH',
      'aibotk': '智能微秘书',
      'wePlusBot': '微加机器人',
      'wxPusherBot': 'wxPusher',
      'wxPusherSpt': 'wxPusher SPT',
      'openiLink': 'OpeniLink',
      'chronocat': 'Chronocat',
      'goCqHttpBot': 'GoCqHttpBot',
    };
    return map[raw] ?? raw;
  }

  void _showDetail(NotifyLogBean item) {
    final ok = item.status == 0;
    showCupertinoDialog(
      useRootNavigator: false,
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(
          item.title?.isNotEmpty == true ? item.title! : "(无标题)",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        content: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "状态：${ok ? '成功' : '失败'}\n"
                  "渠道：${_prettyType(item.notifyType ?? '-')}\n"
                  "来源：${(item.source ?? '') == 'script' ? '脚本 ${item.scriptName ?? ''}' : '面板/系统'}"
                  "${item.taskId?.isNotEmpty == true ? '\n任务 ID：${item.taskId}' : ''}\n"
                  "时间：${Utils.formatMessageTime(item.timestamp ?? 0)}",
                  style: const TextStyle(fontSize: 13),
                ),
                if (item.content?.isNotEmpty == true) ...[
                  const SizedBox(height: 10),
                  const Text("内容：", style: TextStyle(fontSize: 13)),
                  const SizedBox(height: 4),
                  SelectableText(
                    item.content!,
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ],
            ),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text("关闭"),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  Future<void> loadData() async {
    HttpResponse<List<NotifyLogBean>> response =
        await SingleAccountPageState.ofApi(context).notifyLog();
    if (response.success) {
      list.clear();
      list.addAll(response.bean ?? []);
      // 按时间倒序，最新的在最上面
      list.sort((a, b) => (b.timestamp ?? 0).compareTo(a.timestamp ?? 0));
      setState(() {});
    } else if ((response.code ?? 0) == 404) {
      // 青龙 < 2.24.0 没有这个接口
      "该功能需要青龙 2.24.0 及以上版本".toast();
    } else {
      response.message?.toast();
    }
  }

  @override
  void onLazyLoad() {
    loadData();
  }
}
