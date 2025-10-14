import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'hex_color.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ====================================================
// ============== START COLORS ========================
// ====================================================

// var appColorPrimary = HexColor.generateMaterialColor('#256021');
var appColorPrimary = HexColor.generateMaterialColor('#00984b');
class AppColor{
  static Color primary = const Color(0xff00984b);
  static Color secondary = const Color(0xfff0864f);
  static Color black = const Color.fromARGB(255, 55, 73, 87);
  static Color lightText = const Color.fromARGB(255, 136, 160, 178);
  static Color xLightBackground = const Color.fromARGB(255, 239, 243, 246);
  static Color lightBackground = const Color.fromARGB(255, 244, 244, 244);
  static Color white = Colors.white;

  MaterialColor primaryMaterial = HexColor.generateMaterialColor('00984b');
  MaterialColor secondaryMaterial = HexColor.generateMaterialColor('f0864f');
  MaterialColor redMaterial = HexColor.generateMaterialColor('991100');
  MaterialColor blackMaterial = HexColor.generateMaterialColor('f374957');
}

var appColorSecondary = HexColor.generateMaterialColor('#F8931D');
var appColorSearchBackground = HexColor.generateMaterialColor('#dfdfdf');
var appColorInputBackgroundWhite = HexColor.generateMaterialColor('#f5f5f5');
var appColorButtonTextBlack = HexColor.generateMaterialColor('#333333');
var appColorBackgroundAsh = HexColor.generateMaterialColor('#f5f5f5');

var appColorTextInputLightBlue = HexColor.generateMaterialColor('#f2f7fb');
var appColorTextInputLightBlueSecondary = HexColor.generateMaterialColor('#d4dae5');


var waiColorPrimary = HexColor.generateMaterialColor('#04728A');
var waiColorSecondary = HexColor.generateMaterialColor('#D6A01C');


var tmtColorPrimary = HexColor.generateMaterialColor('#00984b');
var tmtColorSecondary = HexColor.generateMaterialColor('#758285');

// ==================================================
// ============== END COLORS ========================
// ==================================================


// ====================================================
// ============== START ICONS ========================
// ====================================================

var appIconHomeOld = PhosphorIcons.house;
var appIconHomeOldFill = PhosphorIcons.house_fill;
var appIconInfo = PhosphorIcons.info;
// var appIconMenu = Icons.bar_chart;
// var appIconMenu = PhosphorIcons.dots_three_outline;
var appIconBellOld = PhosphorIcons.bell;
var appIconList = PhosphorIcons.rows;
var appIconGrid = PhosphorIcons.squares_four;
var appIconUser = PhosphorIcons.user;
var appIconUserFill = PhosphorIcons.user_fill;
var appIconUserGroup = PhosphorIcons.users_three;
var appIconUserGroupFill = PhosphorIcons.users_three_fill;
var appIconTermsOfService = PhosphorIcons.file;
var appIconPrivacy = PhosphorIcons.shield_check;
var appIconSupport = PhosphorIcons.chat;
// var appIconBack = PhosphorIcons.arrow_u_up_left;
var appIconBackOld = PhosphorIcons.caret_left_bold;
var appIconBookmark = PhosphorIcons.bookmark_simple;
var appIconLogin = PhosphorIcons.sign_in;
var appIconGo = PhosphorIcons.arrow_right;
var appIconStar = PhosphorIcons.star;
var appIconStarFill = PhosphorIcons.star_fill;
var appIconSearchOld = PhosphorIcons.magnifying_glass;
var appIconAmenity = PhosphorIcons.buildings;
var appIconDirection = PhosphorIcons.path;
var appIconMapPin = PhosphorIcons.map_pin;
var appIconClose = PhosphorIcons.x_bold;
var appIconShare = PhosphorIcons.share_network;
var appIconCircleFill = PhosphorIcons.circle_fill;
var appIconSadFill = PhosphorIcons.smiley_sad_fill;
var appIconCrossHair = PhosphorIcons.crosshair;
var appIconCrossHairFill = PhosphorIcons.crosshair_fill;
var appIconCaretRight = PhosphorIcons.caret_right;
var appIconCopy = PhosphorIcons.copy;
var appIconBulletPoint = PhosphorIcons.circle_bold;
var appIconMap = PhosphorIcons.map_trifold;
var appIconMapFill = PhosphorIcons.map_trifold_fill;
var appIconHistoryOld = PhosphorIcons.clock_counter_clockwise;
var appIconHistoryOLdFill = PhosphorIcons.clock_counter_clockwise_bold;
var appIconPlusOld = PhosphorIcons.plus;
var appIconTree = PhosphorIcons.tree_evergreen;
var appIconTreeFill = PhosphorIcons.tree_evergreen_fill;
var appIconRequest = PhosphorIcons.note_pencil;
var appIconEditOld = PhosphorIcons.pencil_simple;
var appIconTrashOld = PhosphorIcons.trash;
var appIconTrashFill = PhosphorIcons.trash_fill;
var appIconImageFill = PhosphorIcons.image_fill;
// var appIconCameraFill = PhosphorIcons.camera_fill;
var appIconVideoFill = PhosphorIcons.monitor_play_fill;
var appIconVideoCameraFill = PhosphorIcons.video_camera_fill;
var appIconPlay = PhosphorIcons.play;
var appIconPlayFill = PhosphorIcons.play_fill;
var appIconPauseFill = PhosphorIcons.pause_fill;
var appIconPause = PhosphorIcons.pause;
var appIconOrganisation = PhosphorIcons.buildings;
var appIconSave = PhosphorIcons.floppy_disk;
var appIconSaveFill = PhosphorIcons.floppy_disk_fill;
var appIconBackSpace = PhosphorIcons.backspace;
var appIconBackSpaceFill = PhosphorIcons.backspace_fill;
var appIconAddMarkerFill = PhosphorIcons.selection_plus_fill;
var appIconMapLayerFill = PhosphorIcons.stack_simple_fill;
var appIconCheckCircleFill = PhosphorIcons.check_circle_fill;
var appIconClap = PhosphorIcons.hands_clapping;
var appIconCaretDown = PhosphorIcons.caret_down;
var appIconSend = PhosphorIcons.paper_plane_right;
var appIconSendFill = PhosphorIcons.paper_plane_right_fill;
var appIconEmoji = PhosphorIcons.smiley;
var appIconKeyboard = PhosphorIcons.keyboard;
var appIconChat = PhosphorIcons.chat_circle_dots;
var appIconChatBold = PhosphorIcons.chat_circle_dots_bold;

var appIconCameraFill = ({Color? color, double? size}) => SvgPicture.asset(
  'assets/icon/camera_fill.svg',
  color: color,
  height: size,
  width: size,
);

var appIconBookmarkFill = ({Color? color, double? size}) => SvgPicture.asset(
    'assets/icon/bookmark_fill.svg',
  color: color,
  height: size,
  width: size,
);


// ********************************************************************************
// ********************************************************************************
// ********************************************************************************
var appIconMenu = ({Color? color, double? size}) => SvgPicture.asset(
    'assets/icon/menu.svg',
  color: color,
  height: size,
  width: size,
);
var appIconHome = ({Color? color, double? size}) => SvgPicture.asset(
  'assets/icon/home.svg',
  color: color,
  height: size,
  width: size,
);
var appIconCalendar = ({Color? color, double? size}) => SvgPicture.asset(
  'assets/icon/calendar-clock.svg',
  color: color,
  height: size,
  width: size,
);
var appIconWifi = ({Color? color, double? size}) => SvgPicture.asset(
  'assets/icon/wifi.svg',
  color: color,
  height: size,
  width: size,
);
var appIconBell = ({Color? color, double? size}) => SvgPicture.asset(
  'assets/icon/bell.svg',
  color: color,
  height: size,
  width: size,
);
var appIconBack = ({Color? color, double? size}) => SvgPicture.asset(
  'assets/icon/back.svg',
  color: color,
  height: size,
  width: size,
);
var appIconCircleLeft = ({Color? color, double? size}) => SvgPicture.asset(
  'assets/icon/angle-circle-left.svg',
  color: color,
  height: size,
  width: size,
);
var appIconCircleRight = ({Color? color, double? size}) => SvgPicture.asset(
  'assets/icon/angle-circle-right.svg',
  color: color,
  height: size,
  width: size,
);
var appIconCamera = ({Color? color, double? size}) => SvgPicture.asset(
  'assets/icon/camera.svg',
  color: color,
  height: size,
  width: size,
);
var appIconVideoCamera = ({Color? color, double? size}) => SvgPicture.asset(
  'assets/icon/video-camera.svg',
  color: color,
  height: size,
  width: size,
);
var appIconImage = ({Color? color, double? size}) => SvgPicture.asset(
  'assets/icon/picture.svg',
  color: color,
  height: size,
  width: size,
);
var appIconMarker = ({Color? color, double? size}) => SvgPicture.asset(
  'assets/icon/marker.svg',
  color: color,
  height: size,
  width: size,
);
var appIconVideo = ({Color? color, double? size}) => SvgPicture.asset(
  'assets/icon/video.svg',
  color: color,
  height: size,
  width: size,
);
var appIconGallery = ({Color? color, double? size}) => SvgPicture.asset(
  'assets/icon/gallery.svg',
  color: color,
  height: size,
  width: size,
);
var appIconEye = ({Color? color, double? size}) => SvgPicture.asset(
  'assets/icon/eye.svg',
  color: color,
  height: size,
  width: size,
);
var appIconEdit = ({Color? color, double? size}) => SvgPicture.asset(
  'assets/icon/pencil.svg',
  color: color,
  height: size,
  width: size,
);
var appIconTrash = ({Color? color, double? size}) => SvgPicture.asset(
  'assets/icon/trash.svg',
  color: color,
  height: size,
  width: size,
);
var appIconRefresh = ({Color? color, double? size}) => SvgPicture.asset(
  'assets/icon/refresh.svg',
  color: color,
  height: size,
  width: size,
);
var appIconPlus = ({Color? color, double? size}) => SvgPicture.asset(
  'assets/icon/plus.svg',
  color: color,
  height: size,
  width: size,
);
var appIconMinus = ({Color? color, double? size}) => SvgPicture.asset(
  'assets/icon/minus.svg',
  color: color,
  height: size,
  width: size,
);
var appIconZoomIn = ({Color? color, double? size}) => SvgPicture.asset(
  'assets/icon/zoom-in.svg',
  color: color,
  height: size,
  width: size,
);
var appIconZoomOut = ({Color? color, double? size}) => SvgPicture.asset(
  'assets/icon/zoom-out.svg',
  color: color,
  height: size,
  width: size,
);
var appIconTarget = ({Color? color, double? size}) => SvgPicture.asset(
  'assets/icon/target.svg',
  color: color,
  height: size,
  width: size,
);
var appIconRuler = ({Color? color, double? size}) => SvgPicture.asset(
  'assets/icon/ruler.svg',
  color: color,
  height: size,
  width: size,
);
var appIconTractor = ({Color? color, double? size}) => SvgPicture.asset(
  'assets/icon/tractor.svg',
  color: color,
  height: size,
  width: size,
);
var appIconSeedlingInHand = ({Color? color, double? size}) => SvgPicture.asset(
  'assets/icon/seeding-in-hand.svg',
  color: color,
  height: size,
  width: size,
);
var appIconBadgeCheck = ({Color? color, double? size}) => SvgPicture.asset(
  'assets/icon/badge-check.svg',
  color: color,
  height: size,
  width: size,
);
var appIconNavigation = ({Color? color, double? size}) => SvgPicture.asset(
  'assets/icon/navigation.svg',
  color: color,
  height: size,
  width: size,
);
var appIconSearch = ({Color? color, double? size}) => SvgPicture.asset(
  'assets/icon/search.svg',
  color: color,
  height: size,
  width: size,
);
var appIconDownload = ({Color? color, double? size}) => SvgPicture.asset(
  'assets/icon/download.svg',
  color: color,
  height: size,
  width: size,
);
var appIconAdd = ({Color? color, double? size}) => SvgPicture.asset(
  'assets/icon/add.svg',
  color: color,
  height: size,
  width: size,
);
var appIconAngleRight = ({Color? color, double? size}) => SvgPicture.asset(
  'assets/icon/angle-right.svg',
  color: color,
  height: size,
  width: size,
);
var appIconTimePast = ({Color? color, double? size}) => SvgPicture.asset(
  'assets/icon/time-past.svg',
  color: color,
  height: size,
  width: size,
);
var appIconVector = ({Color? color, double? size}) => SvgPicture.asset(
  'assets/icon/vector.svg',
  color: color,
  height: size,
  width: size,
);
var appIconLayoutFluid = ({Color? color, double? size}) => SvgPicture.asset(
  'assets/icon/layout-fluid.svg',
  color: color,
  height: size,
  width: size,
);
var appIconLayers = ({Color? color, double? size}) => SvgPicture.asset(
  'assets/icon/layers.svg',
  color: color,
  height: size,
  width: size,
);
var appIconComment = ({Color? color, double? size}) => SvgPicture.asset(
  'assets/icon/comment.svg',
  color: color,
  height: size,
  width: size,
);
var appIconShareAlt = ({Color? color, double? size}) => SvgPicture.asset(
  'assets/icon/share.svg',
  color: color,
  height: size,
  width: size,
);
var appIconSignOut = ({Color? color, double? size}) => SvgPicture.asset(
  'assets/icon/sign-out-alt.svg',
  color: color,
  height: size,
  width: size,
);
var appIconDownloadCSV = ({Color? color, double? size}) => SvgPicture.asset(
  'assets/icon/download-csv.svg',
  color: color,
  height: size,
  width: size,
);
var appIconPortrait = ({Color? color, double? size}) => SvgPicture.asset(
  'assets/icon/portrait.svg',
  color: color,
  height: size,
  width: size,
);
var appIconRAList = ({Color? color, double? size}) => SvgPicture.asset(
  'assets/icon/ballot.svg',
  color: color,
  height: size,
  width: size,
);
var appIconKnife = ({Color? color, double? size}) => SvgPicture.asset(
  'assets/icon/knife.svg',
  color: color,
  height: size,
  width: size,
);


class AppButtonProps{
  static double borderRadius = 16;
  static double buttonHeight = 56;
}

class AppPadding{
  static double horizontal = 25;
  static double vertical = 25;
  static double sectionDividerSpace = 25;
}


// ====================================================
// ============== END ICONS ========================
// ====================================================


// ====================================================
// ============== START CONSTANTS ========================
// ====================================================

// FONT
var appMenuFontSize = 20.0;
var appHeadingFontSize = 18.0;
var appSmallFontSize = 11.0;


// PADDING
var appMainHorizontalPadding = 15.0;
var appMainVerticalPadding = 10.0;

// BORDER RADIUS
class AppBorderRadius{
  static double sm = 8.0;
  static double md = 18;
  static double lg = 25;
  static double xl = 32;
}

// ====================================================
// ============== END CONSTANTS ========================
// ====================================================


// ====================================================
// ============== START TEXT STYLE ========================
// ====================================================
class AppTextStyle{
  static TextStyle headingSM = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold
  );

  static TextStyle headingMDPrimary = const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 19,
      color: Colors.black
  );
}
// ====================================================
// ============== START TEXT STYLE ========================
// ====================================================
