import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/http/http.dart';
import 'package:qinglong_app/base/ql_app_bar.dart';
import 'package:qinglong_app/base/single_account_page.dart';
import 'package:qinglong_app/base/theme.dart';
import 'package:qinglong_app/base/ui/enable_widget.dart';
import 'package:qinglong_app/base/ui/loading_widget.dart';
import 'package:qinglong_app/utils/extension.dart';
import 'package:qinglong_app/utils/utils.dart';

import '../login_log/login_log_bean.dart';
import 'notify_type.dart';
import '../notify_log/notify_log_bean.dart';

/// 统一「日志」页：登录日志 + 通知日志 分页切换
class LogPage extends ConsumerStatefulWidget {
  const LogPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LogPage> createState() => _LogPageState();
}

class _LogPageState extends ConsumerState<LogPage> {
  int _tab = 0;

  // 登录日志
  List<LoginLogBean> loginList = [];
  bool loginLoading = true;
  bool loginLoaded = false;

  // 通知日志
  List<NotifyLogBean> notifyList = [];
  bool notifyLoading = true;
  bool notifyLoaded = false;
  bool onlyFailed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadLogin();
      _loadNotify();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: QlAppBar(
        canBack: true,
        backCall: () => Navigator.of(context).pop(),
        title: "日志",
        actions: [
          if (_tab == 1)
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
      body: Column(
        children: [
          _buildSegment(),
          Expanded(
            child: _tab == 0 ? _buildLoginList() : _buildNotifyList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSegment() {
    return ColoredBox(
      color: ref.watch(themeProvider).currentTheme.scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 15,
          right: 15,
          bottom: 10,
          top: 10,
        ),
        child: CustomSlidingSegmentedControl<int>(
          initialValue: 0,
          height: 35,
          isStretch: true,
          children: {
            0: Text(
              "登录日志",
              maxLines: 1,
              style: TextStyle(
                fontSize: 14,
                color: ref.watch(themeProvider).themeColor.title2Color(),
              ),
            ),
            1: Text(
              "通知日志",
              maxLines: 1,
              style: TextStyle(
                fontSize: 14,
                color: ref.watch(themeProvider).themeColor.title2Color(),
              ),
            ),
          },
          decoration: BoxDecoration(
            color: ref.watch(themeProvider).themeColor.segmentedUnCheckBg(),
            borderRadius: BorderRadius.circular(8),
          ),
          thumbDecoration: BoxDecoration(
            color: ref.watch(themeProvider).themeColor.blackAndWhite(),
            borderRadius: BorderRadius.circular(6),
          ),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInToLinear,
          onValueChanged: (v) {
            setState(() {
              _tab = v;
            });
          },
        ),
      ),
    );
  }

  // ---------------- 登录日志 ----------------

  Widget _buildLoginList() {
    if (loginLoading) {
      return const Center(child: LoadingWidget());
    }
    if (loginList.isEmpty) {
      return _empty("暂无登录记录");
    }
    return ListView.separated(
      primary: true,
      itemCount: loginList.length,
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(indent: 15, height: 1);
      },
      itemBuilder: (context, index) {
        final item = loginList[index];
        final ok = item.status == 0;
        final themeColor = ref.watch(themeProvider).themeColor;
        final maxWidth = MediaQuery.of(context).size.width / 1.8;

        return Row(
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
                        constraints:
                            BoxConstraints.loose(Size.fromWidth(maxWidth)),
                        child: Text(
                          item.address ?? "-",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: themeColor.titleColor(),
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
                  SelectableText(
                    item.ip ?? "-",
                    style: TextStyle(
                      fontSize: 14,
                      color: themeColor.descColor(),
                    ),
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
        );
      },
    );
  }

  Future<void> _loadLogin() async {
    if (SingleAccountPageState.ofUserInfo(context).useSecretLogined) {
      // client_id 登录方式拿不到登录日志
      setState(() {
        loginLoading = false;
        loginLoaded = true;
      });
      return;
    }
    HttpResponse<List<LoginLogBean>> response =
        await SingleAccountPageState.ofApi(context).loginLog();
    if (!mounted) return;
    setState(() {
      loginLoading = false;
      loginLoaded = true;
      if (response.success) {
        loginList
          ..clear()
          ..addAll(response.bean ?? []);
        loginList.sort(
            (a, b) => (b.timestamp ?? 0).compareTo(a.timestamp ?? 0));
      }
    });
    if (!response.success && (response.message?.isNotEmpty ?? false)) {
      response.message?.toast();
    }
  }

  // ---------------- 通知日志 ----------------

  List<NotifyLogBean> get _shownNotify =>
      onlyFailed ? notifyList.where((e) => e.status != 0).toList() : notifyList;

  Widget _buildNotifyList() {
    if (notifyLoading) {
      return const Center(child: LoadingWidget());
    }
    final data = _shownNotify;
    if (data.isEmpty) {
      return _empty(onlyFailed ? "没有失败的通知" : "暂无通知记录");
    }
    return ListView.separated(
      primary: true,
      itemCount: data.length,
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(indent: 15, height: 1);
      },
      itemBuilder: (context, index) {
        final item = data[index];
        final ok = item.status == 0;
        final themeColor = ref.watch(themeProvider).themeColor;
        final maxWidth = MediaQuery.of(context).size.width / 1.7;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _showNotifyDetail(item),
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
                          constraints:
                              BoxConstraints.loose(Size.fromWidth(maxWidth)),
                          child: Text(
                            item.title?.isNotEmpty == true
                                ? item.title!
                                : "(无标题)",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              color: themeColor.titleColor(),
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
                          _tag(
                            "渠道 ${prettyNotifyType(item.notifyType!)}",
                            themeColor,
                          ),
                        if ((item.source ?? '') == 'script')
                          _tag("脚本 ${item.scriptName ?? ''}", themeColor),
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
      },
    );
  }

  Widget _empty(String text) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: ref.watch(themeProvider).themeColor.descColor(),
        ),
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

  Future<void> _loadNotify() async {
    HttpResponse<List<NotifyLogBean>> response =
        await SingleAccountPageState.ofApi(context).notifyLog();
    if (!mounted) return;
    setState(() {
      notifyLoading = false;
      notifyLoaded = true;
      if (response.success) {
        notifyList
          ..clear()
          ..addAll(response.bean ?? []);
        notifyList.sort(
            (a, b) => (b.timestamp ?? 0).compareTo(a.timestamp ?? 0));
      }
    });
    if (!response.success && (response.code ?? 0) == 404) {
      "通知日志需要青龙 2.24.0 及以上版本".toast();
    }
  }

  void _showNotifyDetail(NotifyLogBean item) {
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
                  "渠道：${prettyNotifyType(item.notifyType ?? '-')}\n"
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
}
