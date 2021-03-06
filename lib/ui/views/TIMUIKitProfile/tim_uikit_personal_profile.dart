import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tim_ui_kit/business_logic/view_models/tui_personal_profile_view_model.dart';
import 'package:tim_ui_kit/business_logic/view_models/tui_self_info_view_model.dart';
import 'package:tim_ui_kit/business_logic/view_models/tui_theme_view_model.dart';
import 'package:tim_ui_kit/data_services/services_locatar.dart';
import 'package:tim_ui_kit/tim_ui_kit.dart';
import 'package:tim_ui_kit/ui/controller/tim_uikit_personal_profile_controller.dart';
import 'package:tim_ui_kit/ui/utils/color.dart';
import 'package:tim_ui_kit/ui/widgets/avatar.dart';

class TIMUIKitProfilePersonalInfoPage extends StatelessWidget {
  final String appBarTile;

  /// userID, initModel based on it when not null, otherwise using current user ID.
  final String? userID;

  // Profile Controller
  final TIMUIKitPersonalProfileController? controller;

  // self avatar tap
  final OnSelfAvatarTap? onSelfAvatarTap;

  /// the builder for custom operation list
  final Widget Function(
    BuildContext context,
    V2TimUserFullInfo userInfo,
  )? operationListBuilder;

  const TIMUIKitProfilePersonalInfoPage(
      {this.userID,
      required this.appBarTile,
      this.controller,
      this.operationListBuilder,
      this.onSelfAvatarTap,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: serviceLocator<TUIThemeViewModel>(),
        child: Consumer<TUIThemeViewModel>(builder: (context, value, child) {
          final theme = value.theme;
          return Scaffold(
              appBar: AppBar(
                  shadowColor: theme.weakDividerColor,
                  title: Text(
                    appBarTile,
                    style: const TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  flexibleSpace: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        theme.lightPrimaryColor ??
                            CommonColor.lightPrimaryColor,
                        theme.primaryColor ?? CommonColor.primaryColor
                      ]),
                    ),
                  ),
                  iconTheme: const IconThemeData(
                    color: Colors.white,
                  )),
              body: TIMUIKitProfilePersonalInfo(
                userID: userID,
                controller: controller,
                operationListBuilder: operationListBuilder,
                onSelfAvatarTap: onSelfAvatarTap,
              ));
        }));
  }
}

class TIMUIKitProfilePersonalInfo extends StatefulWidget {
  final String? userID;
  final TIMUIKitPersonalProfileController? controller;
  final OnSelfAvatarTap? onSelfAvatarTap;

  /// ?????????????????????????????????
  final Widget Function(
    BuildContext context,
    V2TimUserFullInfo userInfo,
  )? operationListBuilder;

  /// ??????
  static Widget portraitBar(Widget portraitWidget, I18nUtils ttBuild) {
    return SizedBox(
      child: TIMUIKitOperationItem(
        operationName: ttBuild.imt("??????"),
        operationRightWidget: portraitWidget,
        showArrowRightIcon: false,
      ),
    );
  }

  /// ??????
  static Widget nicknamekBar(String nickName, I18nUtils ttBuild) {
    return SizedBox(
      child: TIMUIKitOperationItem(
        operationName: ttBuild.imt("??????"),
        operationRightWidget: Text(nickName),
      ),
    );
  }

  /// ??????
  static Widget userNumBar(String userNum, I18nUtils ttBuild) {
    return SizedBox(
      child: TIMUIKitOperationItem(
        showArrowRightIcon: false,
        operationName: ttBuild.imt("??????"),
        operationRightWidget: Text(userNum),
      ),
    );
  }

  /// ????????????
  static Widget signatureBar(String signature, I18nUtils ttBuild) {
    return SizedBox(
      child: TIMUIKitOperationItem(
        operationName: ttBuild.imt("????????????"),
        operationRightWidget: Text(signature),
      ),
    );
  }

  /// ??????
  static Widget genderBar(String gender, I18nUtils ttBuild) {
    return SizedBox(
      child: TIMUIKitOperationItem(
        operationName: ttBuild.imt("??????"),
        operationRightWidget: Text(gender),
      ),
    );
  }

  /// ??????
  static Widget birthdayBar(String birthday, I18nUtils ttBuild) {
    return InkWell(
      onTap: () {},
      child: TIMUIKitOperationItem(
        operationName: ttBuild.imt("??????"),
        operationRightWidget: Text(birthday),
      ),
    );
  }

  const TIMUIKitProfilePersonalInfo(
      {this.userID,
      this.operationListBuilder,
      this.controller,
      this.onSelfAvatarTap,
      Key? key})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => TIMUIKitProfilePersonalInfoState();
}

// ??????????????????
class TIMUIKitProfilePersonalInfoState
    extends State<TIMUIKitProfilePersonalInfo> {
  late TIMUIKitPersonalProfileController _timuiKitPersonalProfileController;

  late TUIPersonalProfileViewModel _model;

  @override
  void initState() {
    _timuiKitPersonalProfileController =
        widget.controller ?? TIMUIKitPersonalProfileController();
    _model = _timuiKitPersonalProfileController.model;
    _timuiKitPersonalProfileController.loadData(widget.userID);
    super.initState();
  }

  showGenderChoseSheet(
      BuildContext context, I18nUtils ttBuild, TUITheme? theme) {
    showAdaptiveActionSheet(
      context: context,
      title: Text(ttBuild.imt("??????")),
      actions: <BottomSheetAction>[
        BottomSheetAction(
          title: Text(ttBuild.imt("???"),
              style: TextStyle(color: theme?.primaryColor)),
          onPressed: () {
            _timuiKitPersonalProfileController.updateGender(1);
            Navigator.pop(context);
          },
        ),
        BottomSheetAction(
          title: Text(ttBuild.imt("???"),
              style: TextStyle(color: theme?.primaryColor)),
          onPressed: () {
            _timuiKitPersonalProfileController.updateGender(2);
            Navigator.pop(context);
          },
        ),
      ],
      cancelAction: CancelAction(
        title: Text(ttBuild.imt("??????")),
      ), // onPressed parameter is optional by default will dismiss the ActionSheet
    );
  }

  String handleGender(int gender, I18nUtils ttBuild) {
    switch (gender) {
      case 0:
        return ttBuild.imt("?????????");
      case 1:
        return ttBuild.imt("???");
      case 2:
        return ttBuild.imt("???");
      default:
        return "";
    }
  }

  void showCantModify() {
    final I18nUtils ttBuild = I18nUtils(context);
    Fluttertoast.showToast(
      msg: ttBuild.imt("??????????????????????????????"),
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      textColor: Colors.white,
      backgroundColor: Colors.black,
    );
  }

  Widget _defaultOperationListBuilder(
      V2TimUserFullInfo userInfo, bool isFriend, BuildContext context, theme) {
    final I18nUtils ttBuild = I18nUtils(context);
    return isFriend
        ? Column(
            children: [
              GestureDetector(
                child: TIMUIKitProfilePersonalInfo.portraitBar(
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: Avatar(
                        faceUrl: userInfo.faceUrl ?? "",
                        showName: userInfo.nickName ?? ""),
                  ),
                  ttBuild,
                ),
                onTap: widget.onSelfAvatarTap,
              ),
              TIMUIKitProfile.operationDivider(),

              GestureDetector(
                onTap: () async {
                  final connectivityResult =
                      await (Connectivity().checkConnectivity());
                  if (connectivityResult == ConnectivityResult.none) {
                    showCantModify();
                    return;
                  }
                  _timuiKitPersonalProfileController.showTextInputBottomSheet(
                      context,
                      ttBuild.imt("????????????"),
                      ttBuild.imt("??????????????????????????????????????????"), (String nickName) {
                    _timuiKitPersonalProfileController.updateNickName(nickName);
                  });
                },
                child: TIMUIKitProfilePersonalInfo.nicknamekBar(
                  userInfo.nickName ?? "",
                  ttBuild,
                ),
              ),

              TIMUIKitProfilePersonalInfo.userNumBar(
                  userInfo.userID ?? "", ttBuild),
              TIMUIKitProfile.operationDivider(),

              GestureDetector(
                onTap: () async {
                  final connectivityResult =
                      await (Connectivity().checkConnectivity());
                  if (connectivityResult == ConnectivityResult.none) {
                    showCantModify();
                    return;
                  }
                  _timuiKitPersonalProfileController.showTextInputBottomSheet(
                      context,
                      ttBuild.imt("????????????"),
                      ttBuild.imt("??????????????????????????????????????????"), (String selfSignature) {
                    _timuiKitPersonalProfileController
                        .updateSelfSignature(selfSignature);
                  });
                },
                child: TIMUIKitProfilePersonalInfo.signatureBar(
                    userInfo.selfSignature ?? ttBuild.imt("?????????????????????????????????"),
                    ttBuild),
              ),

              GestureDetector(
                onTap: () async {
                  final connectivityResult =
                      await (Connectivity().checkConnectivity());
                  if (connectivityResult == ConnectivityResult.none) {
                    showCantModify();
                    return;
                  }
                  showGenderChoseSheet(context, ttBuild, theme);
                },
                child: TIMUIKitProfilePersonalInfo.genderBar(
                    handleGender(userInfo.gender ?? 0, ttBuild), ttBuild),
              )

              // TIMUIKitProfilePersonalInfo.birthdayBar(ttBuild.imt("?????????????????????"))
            ],
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: _model),
          ChangeNotifierProvider.value(
              value: serviceLocator<TUIThemeViewModel>()),
          ChangeNotifierProvider.value(
            value: serviceLocator<TUISelfInfoViewModel>(),
          )
        ],
        builder: (context, w) {
          final userInfo = (widget.userID != null
                  ? Provider.of<TUIPersonalProfileViewModel>(context).userInfo
                  : Provider.of<TUISelfInfoViewModel>(context).loginInfo) ??
              V2TimUserFullInfo();

          final theme = Provider.of<TUIThemeViewModel>(context).theme;
          return Column(
            children: [
              widget.operationListBuilder != null
                  ? widget.operationListBuilder!(context, userInfo)
                  : _defaultOperationListBuilder(userInfo, true, context, theme)
            ],
          );
        });
  }
}
