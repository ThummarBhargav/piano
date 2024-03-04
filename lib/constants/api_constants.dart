const imagePath = "assets/images/";
const iconPath = "assets/icons/";

class ArgumentConstant {
  static const categoryImages = "categoryImages";
  static const categoryName = "categoryName";
  static const passCategoryName = "passCategoryName";
  static const passImage = "passImage";
  static const categoryKey = "categoryKey";
  static const ImageKey = "ImageKey";
  static const categoryNameKey = "categoryNameKey";
  static const categoryImageListKey = "categoryImageListKey";
  static const mediaLink = "mediaLink";
  static const isStartTime = "isStartTime";
  static const isAppOpenStartTime = "isAppOpenStartTime";
  static const isCurrentIndex = "isCurrentIndex";
  static const packageName = "rangolidesigns.rangolism.rangoli.designs";
  static const oneSignalID = "8cd00610-696d-459c-9b17-24fa3c557268";
  static const shareApp = "https://play.google.com/store/apps/details?id=${packageName}";
  final shareLink = "Create and share stunning Rangoli designs with our app. Spread the joy of art and tradition! 🎨🪔 #RangoliApp #ShareArt. Download now https://play.google.com/store/apps/details?id=${packageName}";
}

class ImageConstant {
  static const String bg = imagePath + "bg.png";
  static const String slider1 = imagePath + "slider1.png";
  static const String slider2 = imagePath + "slider2.jpeg";
  static const String slider3 = imagePath + "slider3.jpg";
  static const String slider4 = imagePath + "slider4.jpg";
  static const String drawerImage = imagePath + "drawerImage.png";
  static const String splashScreen = imagePath + "splash_screen.png";
  static const String error = imagePath + "error.png";

  static const String drawer = iconPath + "drawer.png";
  static const String bottomLine = iconPath + "bottomLine.png";
  static const String category = iconPath + "category.png";
  static const String favorite = iconPath + "favorite.png";
  static const String home = iconPath + "home.png";
  static const String aboutUs = iconPath + "aboutUs.png";
  static const String gradientBg = iconPath + "gradientBg.png";
  static const String playStore = iconPath + "playStore.png";
  static const String privacyPolicy = iconPath + "privacyPolicy.png";
  static const String share = iconPath + "share.png";
  static const String start = iconPath + "start.png";
  static const String withOutGradientBg = iconPath + "withOutGradientBg.png";
  static const String backArrow = iconPath + "backArrow.png";
  static const String download = iconPath + "download.png";
  static const String like = iconPath + "like.png";
  static const String done = iconPath + "done.png";
}

bool isNullEmptyOrFalse(dynamic o) {
  if (o is Map<String, dynamic> || o is List<dynamic>) {
    return o == null || o.length == 0;
  }
  return o == null || false == o || "" == o;
}