/// 通知渠道 key → 中文名（青龙 notificationModes）
String prettyNotifyType(String raw) {
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
    'closed': '已关闭',
  };
  return map[raw] ?? raw;
}
