import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/ql_app_bar.dart';
import 'package:qinglong_app/base/single_account_page.dart';
import 'package:qinglong_app/base/theme.dart';
import 'package:qinglong_app/base/ui/lazy_load_state.dart';
import 'package:qinglong_app/base/ui/loading_widget.dart';
import 'package:qinglong_app/module/subscribe/add_subscribe_page.dart';
import 'package:qinglong_app/utils/extension.dart';

import '../base/commit_button.dart';

class PushSettingPage extends ConsumerStatefulWidget {
  const PushSettingPage({Key? key}) : super(key: key);

  @override
  ConsumerState<PushSettingPage> createState() => _PushSettingPageState();
}

class _PushSettingPageState extends ConsumerState<PushSettingPage> {
  List<PushBean> list = [];

  PushBean? current;
  bool loading = true;

  @override
  void initState() {
    initData();
    super.initState();
    onLazyLoad();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: QlAppBar(
        title: "通知设置",
        actions: [
          CommitButton(
            onTap: () {
              commit();
            },
          ),
        ],
      ),
      body: loading
          ? const Center(child: LoadingWidget())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "通知设置",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DropdownButtonFormField<PushBean>(
                        items: list
                            .map<DropdownMenuItem<PushBean>>(
                                (e) => DropdownMenuItem<PushBean>(
                                      value: e,
                                      child: Text(getNameByKey(e.name)),
                                    ))
                            .toList(),
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              ref.watch(themeProvider).themeColor.title2Color(),
                        ),
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                        ),
                        icon: const Icon(
                          CupertinoIcons.chevron_up_chevron_down,
                          size: 16,
                        ),
                        value: current,
                        onChanged: (value) {
                          current = value!;
                          _applyDropdownDefaults(current!);
                          setState(() {});
                        },
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: current?.children
                                .map(
                                  (e) => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      TitleWidget(
                                        e.key,
                                        required: e.required,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      e.items.isEmpty
                                          ? TextField(
                                              controller: e.controller,
                                              textAlignVertical:
                                                  TextAlignVertical.center,
                                              maxLines: e.maxLines,
                                              decoration: InputDecoration(
                                                hintText: e.hint,
                                              ),
                                              autofocus: false,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            )
                                          : Builder(builder: (ddContext) {
                                              final tc = ref
                                                  .watch(themeProvider)
                                                  .themeColor;
                                              final isDark = Theme.of(ddContext)
                                                      .brightness ==
                                                  Brightness.dark;
                                              // 配色跟随主题：
                                              // 白色主题 -> 白底黑字；黑色主题 -> 黑底白字
                                              final popBg = isDark
                                                  ? const Color(0xFF1C1C1E)
                                                  : const Color(0xFFFFFFFF);
                                              final fg = tc.title2Color();
                                              final borderColor = isDark
                                                  ? const Color(0xFF3A3A3C)
                                                  : const Color(0xffe4e4e4);

                                              return DropdownButtonFormField<
                                                  String>(
                                                isExpanded: true,
                                                elevation: 8,
                                                dropdownColor: popBg,
                                                icon: Icon(
                                                  CupertinoIcons
                                                      .chevron_up_chevron_down,
                                                  size: 16,
                                                  color: fg,
                                                ),
                                                value: e.items.any((it) =>
                                                        it.value ==
                                                        e.controller.text)
                                                    ? e.controller.text
                                                    : e.items.first.value,
                                                items: e.items
                                                    .map((it) =>
                                                        DropdownMenuItem<
                                                            String>(
                                                          value: it.value,
                                                          child: Text(
                                                            it.label,
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color: fg,
                                                            ),
                                                          ),
                                                        ))
                                                    .toList(),
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  contentPadding:
                                                      const EdgeInsets
                                                              .symmetric(
                                                    vertical: 10,
                                                    horizontal: 10,
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: borderColor,
                                                      width: 1,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: borderColor,
                                                      width: 1,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                ),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: fg,
                                                ),
                                                onChanged: (v) {
                                                  e.controller.text = v ?? '';
                                                  setState(() {});
                                                },
                                              );
                                            }),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        e.name,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: ref
                                              .watch(themeProvider)
                                              .themeColor
                                              .descColor(),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                .toList() ??
                            [],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  void initData() {
    var pushSetting = <String, List<Map<String, dynamic>>>{
      'gotify': [
        {"label": 'gotifyUrl', "tip": 'gotify的url地址，例如 https://push.example.de:8080', "required": true},
        {"label": 'gotifyToken', "tip": 'gotify的消息应用token码', "required": true},
        {"label": 'gotifyPriority', "tip": '推送消息的优先级'},
      ],
      'ntfy': [
        {"label": 'ntfyUrl', "tip": 'ntfy的url地址，例如 https://ntfy.sh', "required": true},
        {"label": 'ntfyTopic', "tip": 'ntfy应用topic', "required": true},
        {"label": 'ntfyPriority', "tip": '推送消息的优先级'},
        {"label": 'ntfyToken', "tip": 'ntfy应用token'},
        {"label": 'ntfyUsername', "tip": 'ntfy应用用户名'},
        {"label": 'ntfyPassword', "tip": 'ntfy应用密码'},
        {"label": 'ntfyActions', "tip": 'ntfy用户动作'},
      ],
      'goCqHttpBot': [
        {"label": 'goCqHttpBotUrl', "tip": '推送到个人QQ: http://127.0.0.1/send_private_msg，群：http://127.0.0.1/send_group_msg', "required": true},
        {"label": 'goCqHttpBotToken', "tip": '访问密钥', "required": true},
        {"label": 'goCqHttpBotQq', "tip": '如果GOBOT_URL设置 /send_private_msg 则需要填入 user_id=个人QQ 相反如果是 /send_group_msg 则需要填入 group_id=QQ群', "required": true},
      ],
      'serverChan': [
        {"label": 'serverChanKey', "tip": 'Server酱SENDKEY', "required": true},
      ],
      'pushDeer': [
        {"label": 'pushDeerKey', "tip": 'PushDeer的Key，https://github.com/easychen/pushdeer', "required": true},
        {"label": 'pushDeerUrl', "tip": 'PushDeer的自架API endpoint，默认是 https://api2.pushdeer.com/message/push'},
      ],
      'bark': [
        {"label": 'barkPush', "tip": 'Bark的信息IP/设备码，例如：https://api.day.app/XXXXXXXX', "required": true},
        {"label": 'barkIcon', "tip": 'BARK推送图标，自定义推送图标 (需iOS15或以上才能显示)'},
        {"label": 'barkSound', "tip": 'BARK推送铃声，铃声列表去APP查看复制填写'},
        {"label": 'barkGroup', "tip": 'BARK推送消息的分组，默认为qinglong'},
        {"label": 'barkLevel', "tip": 'BARK推送消息的时效性，默认为active'},
        {"label": 'barkUrl', "tip": 'BARK推送消息的跳转URL'},
        {"label": 'barkArchive', "tip": 'BARK是否保存推送消息'},
      ],
      'telegramBot': [
        {"label": 'telegramBotToken', "tip": 'telegram机器人的token，例如：1077xxx4424:AAFjv0FcqxxxxxxgEMGfi22B4yh15R5uw', "required": true},
        {"label": 'telegramBotUserId', "tip": 'telegram用户的id，例如：129xxx206', "required": true},
        {"label": 'telegramBotProxyHost', "tip": '代理IP'},
        {"label": 'telegramBotProxyPort', "tip": '代理端口'},
        {"label": 'telegramBotProxyAuth', "tip": 'telegram代理配置认证参数，用户名与密码用英文冒号连接 user:password'},
        {"label": 'telegramBotApiHost', "tip": 'telegram api自建的反向代理地址，默认tg官方api'},
      ],
      'dingtalkBot': [
        {"label": 'dingtalkBotToken', "tip": '钉钉机器人webhook token，例如：5a544165465465645d0f31dca676e7bd07415asdasd', "required": true},
        {"label": 'dingtalkBotSecret', "tip": '密钥，机器人安全设置页面，加签一栏下面显示的SEC开头的字符串'},
      ],
      'weWorkBot': [
        {"label": 'weWorkBotKey', "tip": '企业微信机器人的webhook(详见文档 https://work.weixin.qq.com/api/doc/90000/90136/91770)，例如：693a91f6-7xxx-4bc4-97a0-0ec2sifa5aaa', "required": true},
        {"label": 'weWorkOrigin', "tip": '企业微信代理地址'},
      ],
      'weWorkApp': [
        {"label": 'weWorkAppKey', "tip": 'corpid、corpsecret、touser(注:多个成员ID使用|隔开)、agentid、消息类型(选填，不填默认文本消息类型) 注意用,号隔开(英文输入法的逗号)，例如：wwcfrs,B-76WERQ,qinglong,1000001,2COat', "required": true},
        {"label": 'weWorkOrigin', "tip": '企业微信代理地址'},
      ],
      'aibotk': [
        {"label": 'aibotkKey', "tip": '密钥key，智能微秘书个人中心获取apikey，申请地址：https://wechat.aibotk.com/signup?from=ql', "required": true},
        {"label": 'aibotkType', "tip": '发送的目标，群组或者好友', "required": true, "placeholder": '请输入要发送的目标', "items": [{'value': 'room', 'label': '群聊'}, {'value': 'contact', 'label': '好友'}]},
        {"label": 'aibotkName', "tip": '要发送的用户昵称或群名，如果目标是群，需要填群名，如果目标是好友，需要填好友昵称', "required": true},
      ],
      'iGot': [
        {"label": 'iGotPushKey', "tip": 'iGot的信息推送key，例如：https://push.hellyw.com/XXXXXXXX', "required": true},
      ],
      'pushPlus': [
        {"label": 'pushPlusToken', "tip": '微信扫码登录后一对一推送或一对多推送下面的token(您的Token)，不提供PUSH_PLUS_USER则默认为一对一推送，参考 https://www.pushplus.plus/', "required": true},
        {"label": 'pushPlusUser', "tip": '一对多推送的“群组编码”（一对多推送下面->您的群组(如无则创建)->群组编码，如果您是创建群组人。也需点击“查看二维码”扫描绑定，否则不能接受群组消息推送）'},
        {"label": 'pushplusTemplate', "tip": '发送模板'},
        {"label": 'pushplusChannel', "tip": '发送渠道'},
        {"label": 'pushplusWebhook', "tip": 'webhook编码'},
        {"label": 'pushplusCallbackUrl', "tip": '发送结果回调地址'},
        {"label": 'pushplusTo', "tip": '好友令牌'},
      ],
      'wePlusBot': [
        {"label": 'wePlusBotToken', "tip": '用户令牌，扫描登录后 我的—>设置->令牌 中获取，参考 https://www.weplusbot.com/', "required": true},
        {"label": 'wePlusBotReceiver', "tip": '消息接收人'},
        {"label": 'wePlusBotVersion', "tip": '调用版本；专业版填写pro，个人版填写personal，为空默认使用专业版'},
      ],
      'wxPusherBot': [
        {"label": 'wxPusherBotAppToken', "tip": 'wxPusherBot的appToken', "required": true},
        {"label": 'wxPusherBotTopicIds', "tip": 'wxPusherBot的topicIds'},
        {"label": 'wxPusherBotUids', "tip": 'wxPusherBot的uids'},
      ],
      'wxPusherSpt': [
        {"label": 'wxPusherSptList', "tip": 'wxPusherSpt的SPT', "required": true},
      ],
      'wpush': [
        {"label": 'wpushApiKey', "tip": 'WPUSH的API Key，在 https://wpush.cn/settings 获取，参考 https://wpush.cn/docs', "required": true},
        {"label": 'wpushChannel', "tip": '推送渠道，支持 wechat/app/sms/mail/webhook/dingtalk/feishu/wechat_work/clawbot/qqbot，默认 wechat'},
        {"label": 'wpushTopicCode', "tip": '可选，Topic 广播编码；填写后按 Topic 推送，参考 https://wpush.cn/docs'},
      ],
      'openiLink': [
        {"label": 'openiLinkAppToken', "tip": 'OpeniLink的app_token，在OpeniLink Hub后台安装App后获取，参考 https://openilink.com/docs/hub/apps', "required": true},
        {"label": 'openiLinkHubUrl', "tip": 'OpeniLink Hub地址，默认为 https://hub.openilink.com，自建Hub时填写自己的地址'},
        {"label": 'openiLinkContextToken', "tip": 'OpeniLink的context_token，用于标识消息会话上下文，可从消息事件中获取'},
      ],
      'chat': [
        {"label": 'synologyChatUrl', "tip": 'synologyChat的url地址', "required": true},
      ],
      'email': [
        {"label": 'emailService', "tip": '邮箱服务名称，比如126、163、Gmail、QQ等，支持列表https://github.com/nodemailer/nodemailer/blob/master/lib/well-known/services.json', "required": true},
        {"label": 'emailUser', "tip": '邮箱认证地址', "required": true},
        {"label": 'emailPass', "tip": 'SMTP 登录密码，也可能为特殊口令，视具体邮件服务商说明而定', "required": true},
        {"label": 'emailTo', "tip": '收件邮箱地址，多个分号分隔，默认发送给发件邮箱地址'},
      ],
      'lark': [
        {"label": 'larkKey', "tip": '飞书群组机器人：https://www.feishu.cn/hc/zh-CN/articles/360024984973', "required": true},
        {"label": 'larkSecret', "tip": '飞书群组机器人加签密钥，安全设置中开启签名校验后获得'},
      ],
      'pushMe': [
        {"label": 'pushMeKey', "tip": 'PushMe的Key，https://push.i-i.me/', "required": true},
        {"label": 'pushMeUrl', "tip": '自建的PushMeServer消息接口地址，例如：http://127.0.0.1:3010，不填则使用官方消息接口'},
      ],
      'chronocat': [
        {"label": 'chronocatURL', "tip": 'Chronocat Red 服务的连接地址 https://chronocat.vercel.app/install/docker/official/', "required": true},
        {"label": 'chronocatQQ', "tip": '个人:user_id=个人QQ 群则填入group_id=QQ群 多个用英文;隔开同时支持个人和群 如：user_id=xxx;group_id=xxxx;group_id=xxxxx', "required": true},
        {"label": 'chronocatToken', "tip": 'docker安装在持久化config目录下的chronocat.yml文件可找到', "required": true},
      ],
      'webhook': [
        {"label": 'webhookMethod', "tip": '请求方法', "required": true, "items": [{'value': 'GET', 'label': 'GET'}, {'value': 'POST', 'label': 'POST'}, {'value': 'PUT', 'label': 'PUT'}]},
        {"label": 'webhookContentType', "tip": '请求头Content-Type', "required": true, "items": [{'value': 'text/plain', 'label': 'text/plain'}, {'value': 'application/json', 'label': 'application/json'}, {'value': 'multipart/form-data', 'label': 'multipart/form-data'}, {'value': 'application/x-www-form-urlencoded', 'label': 'application/x-www-form-urlencoded'}]},
        {"label": 'webhookUrl', "tip": '请求链接以http或者https开头。url或者body中必须包含\$title，\$content可选，对应api内容的位置', "required": true, "placeholder": 'https://xxx.cn/api?content=\$title\n'},
        {"label": 'webhookHeaders', "tip": '请求头格式Custom-Header1: Header1，多个换行分割', "placeholder": 'Custom-Header1: Header1\nCustom-Header2: Header2'},
        {"label": 'webhookBody', "tip": '请求体格式key1: value1，多个换行分割。url或者body中必须包含\$title，\$content可选，对应api内容的位置', "placeholder": 'key1: \$title\nkey2: \$content'},
      ],
      "closed": [],
    };

    for (var entry in pushSetting.entries) {
      list.add(PushBean(
          entry.key,
          entry.key,
          entry.value.map((e) {
        final raw = (e["items"] as List?) ?? const [];
        final items = raw
            .map<PushItemBean>((it) => PushItemBean(
                (it as Map)["value"].toString(),
                (it["label"] ?? it["value"]).toString()))
            .toList();
        return PushChildBean(e["label"].toString(), e["tip"].toString(),
            (e["required"] ?? false) as bool, items,
            (e["placeholder"] ?? '').toString());
      }).toList()));
    }
  }

  /// 下拉字段为空时补默认值，避免"必填"校验把用户卡住。
  void _applyDropdownDefaults(PushBean bean) {
    for (final child in bean.children) {
      if (child.items.isEmpty) continue;
      final hasValue =
          child.items.any((it) => it.value == child.controller.text);
      if (!hasValue) {
        child.controller.text = child.items.first.value;
      }
    }
  }

  void onLazyLoad() async {
    var response = await SingleAccountPageState.ofApi(context).getNotifcation();

    if (response.success) {
      String result = response.bean ?? "{}";
      Map<String, dynamic> json = jsonDecode(result);

      if (json.isEmpty) {
        current = list.last;
        setState(() {
          loading = false;
        });
        return;
      }
      String? type = json["type"];
      if (type == null || type.isEmpty) {
        current = list.last;
        setState(() {
          loading = false;
        });
        return;
      }

      int index = list.indexWhere((element) => element.key == type);
      if (index < 0) {
        setState(() {
          loading = false;
        });
        return;
      }

      for (var element in list[index].children) {
        var raw = json[element.key]?.toString() ?? "";
        // 下拉字段：空值或不在候选里时，回落到第一项，避免必填校验卡住
        if (element.items.isNotEmpty &&
            !element.items.any((it) => it.value == raw)) {
          raw = element.items.first.value;
        }
        element.controller.text = raw;
      }
      current = list[index];
      setState(() {
        loading = false;
      });
    }
  }

  void commit() async {
    if (current == null || current!.key == "closed") {
      EasyLoading.show(status: "提交中");

      var response =
          await SingleAccountPageState.ofApi(context).updateNotifcation({});
      EasyLoading.dismiss();
      if (response.success) {
        "设置成功".toast();
        Navigator.of(context).pop();
      } else {
        response.message.toast();
      }
      return;
    }
    int? index = current?.children.indexWhere((element) =>
        element.controller.text.isEmpty && element.required == true);
    index ??= -1;
    if (index >= 0) {
      ("${current?.children[index].key}为必填项").toast();
      return;
    }

    EasyLoading.show(status: "提交中");

    Map<String, dynamic> params = {};

    params["type"] = current!.key.toString();
    params.addAll(current!.children2Json());
    var response =
        await SingleAccountPageState.ofApi(context).updateNotifcation(params);
    EasyLoading.dismiss();
    if (response.success) {
      "设置成功".toast();
      Navigator.of(context).pop();
    } else {
      response.message.toast();
    }
  }
}

class PushBean {
  String key;
  String name;
  List<PushChildBean> children;

  PushBean(this.key, this.name, this.children);

  Map<String, dynamic> children2Json() {
    Map<String, dynamic> data = {};

    for (var e in children) {
      data[e.key] =
          e.controller.text.isEmpty ? '' : e.controller.text.toString();
    }
    return data;
  }
}

class PushItemBean {
  final String value;
  final String label;

  const PushItemBean(this.value, this.label);
}

class PushChildBean {
  String key;
  String name;
  bool required;
  List<PushItemBean> items;
  String placeholder;
  TextEditingController controller = TextEditingController();

  PushChildBean(this.key, this.name, this.required,
      [this.items = const [], this.placeholder = '']);

  /// 提示文案：优先用 placeholder，否则"请输入 xxx"
  String get hint => placeholder.isNotEmpty ? placeholder : "请输入$key";

  /// 多行字段（请求头 / 请求体）需要多行输入
  int get maxLines => placeholder.contains('\n') || key == 'webhookHeaders' || key == 'webhookBody' ? 4 : 1;
}

String getNameByKey(String key) {
  if (key == 'gotify') {
    return 'Gotify';
  }
  if (key == 'ntfy') {
    return 'Ntfy';
  }
  if (key == 'goCqHttpBot') {
    return 'GoCqHttpBot';
  }
  if (key == 'serverChan') {
    return 'Server酱';
  }
  if (key == 'pushDeer') {
    return 'PushDeer';
  }
  if (key == 'bark') {
    return 'Bark';
  }
  if (key == 'telegramBot') {
    return 'Telegram机器人';
  }
  if (key == 'dingtalkBot') {
    return '钉钉机器人';
  }
  if (key == 'weWorkBot') {
    return '企业微信机器人';
  }
  if (key == 'weWorkApp') {
    return '企业微信应用';
  }
  if (key == 'aibotk') {
    return '智能微秘书';
  }
  if (key == 'iGot') {
    return 'IGot';
  }
  if (key == 'pushPlus') {
    return 'PushPlus';
  }
  if (key == 'wePlusBot') {
    return '微加机器人';
  }
  if (key == 'wxPusherBot') {
    return 'wxPusher';
  }
  if (key == 'wxPusherSpt') {
    return 'WxPusher(极简推送SPT-推荐)';
  }
  if (key == 'wpush') {
    return 'WPUSH';
  }
  if (key == 'openiLink') {
    return 'OpeniLink';
  }
  if (key == 'chat') {
    return '群晖chat';
  }
  if (key == 'email') {
    return '邮箱';
  }
  if (key == 'lark') {
    return '飞书机器人';
  }
  if (key == 'pushMe') {
    return 'PushMe';
  }
  if (key == 'chronocat') {
    return 'Chronocat';
  }
  if (key == 'webhook') {
    return '自定义通知';
  }
  return "已关闭";
}
