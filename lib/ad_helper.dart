import 'dart:io';

class AdHelper {

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-8413530976328583/3845409842';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-1911709436746841/5731022022';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-8413530976328583/7976511954";
    } else if (Platform.isIOS) {
      return "ca-app-pub-1911709436746841/2234630145";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-8413530976328583/6471858591";
    } else if (Platform.isIOS) {
      return "ca-app-pub-1911709436746841/2234630145";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}