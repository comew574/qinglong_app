import 'package:json_conversion_annotation/json_conversion_annotation.dart';

/// 青龙 2.24.0 新增：通知审计日志
/// GET /api/system/notify-log -> data: [ {timestamp,title,content,status,notifyType,source,scriptName,taskId} ]
@JsonConversion()
class NotifyLogBean {
  int? timestamp;
  String? title;
  String? content;

  /// 0 = 成功, 1 = 失败（与 LoginStatus 一致）
  int? status;

  /// 通知渠道，如 weWorkBot / webhook / bark
  String? notifyType;

  /// system = 面板/后端发出；script = 脚本上报
  String? source;

  /// source=script 时的脚本名
  String? scriptName;

  /// 关联任务 id（可空）
  String? taskId;

  NotifyLogBean({
    this.timestamp,
    this.title,
    this.content,
    this.status,
    this.notifyType,
    this.source,
    this.scriptName,
    this.taskId,
  });

  NotifyLogBean.fromJson(Map<String, dynamic> json) {
    timestamp = int.tryParse((json['timestamp'] ?? '').toString());
    title = json['title']?.toString();
    content = json['content']?.toString();
    status = json['status'] is int ? json['status'] : int.tryParse('${json['status']}');
    notifyType = json['notifyType']?.toString();
    source = json['source']?.toString();
    scriptName = json['scriptName']?.toString();
    taskId = json['taskId']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['timestamp'] = timestamp;
    data['title'] = title;
    data['content'] = content;
    data['status'] = status;
    data['notifyType'] = notifyType;
    data['source'] = source;
    data['scriptName'] = scriptName;
    data['taskId'] = taskId;
    return data;
  }

  static NotifyLogBean jsonConversion(Map<String, dynamic> json) {
    return NotifyLogBean.fromJson(json);
  }
}
