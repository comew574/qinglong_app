import 'package:qinglong_app/base/userinfo_viewmodel.dart';
import 'package:qinglong_app/main.dart';

class Url {
  int index;

  Url(this.index);

  static get login => "/api/user/login";

  static get system => "/api/system";

  static get loginOld => "/api/login";

  static get loginTwo => "/api/user/two-factor/login";
  static const loginByClientId = "/open/auth/token";
  static const user = "/api/user";

  static const updatePassword = "/api/user";

  get logDel => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/system/log/remove" : "/api/system/log/remove";

  // 青龙 2.23+ 老路由 /system/log/remove 已下线，改用 system/config
  get systemConfig => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/system/config" : "/api/system/config";

  get logRemoveFrequency => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/system/config/log-remove-frequency" : "/api/system/config/log-remove-frequency";

  get tasks => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/crons" : "/api/crons";

  get subscribes => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/subscriptions" : "/api/subscriptions";

  get notifcations => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/user/notification" : "/api/user/notification";

  get runSubscribes => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/subscriptions/run" : "/api/subscriptions/run";

  get stopSubscribes => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/subscriptions/stop" : "/api/subscriptions/stop";

  get addSubscribes => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/subscriptions" : "/api/subscriptions";

  get enableSubscribes =>
      getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/subscriptions/enable" : "/api/subscriptions/enable";

  get disableSubscribes =>
      getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/subscriptions/disable" : "/api/subscriptions/disable";

  get runTasks => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/crons/run" : "/api/crons/run";

  get stopTasks => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/crons/stop" : "/api/crons/stop";

  get taskDetail => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/crons/" : "/api/crons/";

  get addTask => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/crons" : "/api/crons";

  get pinTask => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/crons/pin" : "/api/crons/pin";

  get unpinTask => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/crons/unpin" : "/api/crons/unpin";

  get enableTask => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/crons/enable" : "/api/crons/enable";

  get disableTask => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/crons/disable" : "/api/crons/disable";

  get files => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/configs/files" : "/api/configs/files";

  // 青龙 2.23+ 老路由 /configs/<file> 已下线（410），改用 /configs/detail?path=<file>
  get configContent => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/configs/detail" : "/api/configs/detail";

  get saveFile => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/configs/save" : "/api/configs/save";

  get envs => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/envs" : "/api/envs";

  get addEnv => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/envs" : "/api/envs";

  get delEnv => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/envs" : "/api/envs";

  get disableEnvs => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/envs/disable" : "/api/envs/disable";

  get enableEnvs => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/envs/enable" : "/api/envs/enable";

  get loginLog => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/user/login-log" : "/api/user/login-log";

  get logFoldDelete => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/logs" : "/api/logs";

  get taskLog => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/logs" : "/api/logs";

  get taskLogDetail => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/logs/" : "/api/logs/";

  // 青龙 2.23+ 老路由 /logs/<文件名> 已下线（410），改用 /logs/detail?file=&path=
  get taskLogDetailNew => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/logs/detail" : "/api/logs/detail";

  get scripts => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/scripts/files" : "/api/scripts/files";

  get scripts2 => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/scripts" : "/api/scripts";

  get scriptUpdate => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/scripts" : "/api/scripts";

  get scriptDetail => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/scripts" : "/api/scripts";
  // 青龙 2.23+ 老路由 /scripts/<file> 已下线（410）；且文件名含大写时会被
  // protectedPathCase 中间件判为 Invalid path format，所以文件名走 query。
  get scriptDetailForReadFile => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/scripts/detail" : "/api/scripts/detail";

  get dependencies => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/dependencies" : "/api/dependencies";

  get dependenciesDeleteFocus =>
      getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/dependencies/force" : "/api/dependencies/force";

  get dependenciesReinstall =>
      getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/dependencies/reinstall" : "/api/dependencies/reinstall";

  get addScript => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/scripts" : "/api/scripts";

  get dependencyReinstall =>
      getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/dependencies/reinstall" : "/api/dependencies/reinstall";

  get checkUpdate => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/system/update-check" : "/api/system/update-check";

  get appkeys => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/apps" : "/api/apps";

  resetAppKey(dynamic id) {
    return getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined
        ? "/api/apps/${id.toString()}/reset-secret"
        : "/api/apps/${id.toString()}/reset-secret";
  }

  intimeLog(String cronId) {
    return getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/crons/$cronId/log" : "/api/crons/$cronId/log";
  }

  intimeDepLog(String id) {
    return getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/dependencies/$id" : "/api/dependencies/$id";
  }

  intimeSubscribeLog(int cronId) {
    return getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/subscriptions/$cronId/log" : "/api/subscriptions/$cronId/log";
  }

  envMove(String envId) {
    return getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/envs/$envId/move" : "/api/envs/$envId/move";
  }


  // ═══ 青龙 2.23.0 新增接口 ═══

  // 脚本历史版本
  get scriptHistory => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/scripts/history" : "/api/scripts/history";
  get scriptHistoryDetail => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/scripts/history/detail" : "/api/scripts/history/detail";
  get scriptHistoryRestore => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/scripts/history/restore" : "/api/scripts/history/restore";

  // 脚本操作
  get scriptRename => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/scripts/rename" : "/api/scripts/rename";
  get scriptRun => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/scripts/run" : "/api/scripts/run";
  get scriptStop => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/scripts/stop" : "/api/scripts/stop";
  get scriptDownload => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/scripts/download" : "/api/scripts/download";

  // 任务详情与实例
  get taskDetailNew => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/crons/detail" : "/api/crons/detail";
  get taskStatus => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/crons/status" : "/api/crons/status";
  get cronTaskLabel => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/crons/labels" : "/api/crons/labels";

  // 环境变量补充
  get envName => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/envs/name" : "/api/envs/name";
  get envPin => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/envs/pin" : "/api/envs/pin";
  get envUnpin => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/envs/unpin" : "/api/envs/unpin";

  // 日志
  get logDownload => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/logs/download" : "/api/logs/download";

  // 系统
  get systemLog => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/system/log" : "/api/system/log";
  get systemTimezone => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/system/config/timezone" : "/api/system/config/timezone";
  get systemLang => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/system/config/lang" : "/api/system/config/lang";
  get systemPanelTitle => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/system/config/panel-title" : "/api/system/config/panel-title";

  // Dashboard
  get dashboardOverview => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/dashboard/overview" : "/api/dashboard/overview";
  get dashboardTrend => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/dashboard/trend" : "/api/dashboard/trend";
  get dashboardLabels => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/dashboard/labels" : "/api/dashboard/labels";
  get dashboardSystem => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/dashboard/system" : "/api/dashboard/system";

  // 用户
  get userLogout => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/user/logout" : "/api/user/logout";
  get userAvatar => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/user/avatar" : "/api/user/avatar";
  get ipBlacklist => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/user/ip-blacklist" : "/api/user/ip-blacklist";

  // 配置
  get configSamples => getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/configs/samples" : "/api/configs/samples";

  cronInstances(String id) {
    return getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined ? "/open/crons/$id/instances" : "/api/crons/$id/instances";
  }

  cronInstanceStop(String id, String instanceId) {
    return getIt<UserInfoViewModel>(instanceName: index.toString()).useSecretLogined
        ? "/open/crons/$id/instances/$instanceId/stop"
        : "/api/crons/$id/instances/$instanceId/stop";
  }

  static bool inWhiteList(String path) {
    if (path == login || path == loginByClientId || path == loginTwo || path == loginOld) {
      return true;
    }
    return false;
  }

  static bool inLoginList(String path) {
    if (path == login || path == loginByClientId || path == loginOld) {
      return true;
    }
    return false;
  }
}
