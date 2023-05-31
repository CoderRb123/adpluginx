import 'package:adpluginx/adpluginx.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RateUsAlert {
  showRateUsDialog() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int rateUsDelay = preferences.getInt("rateUsDelay") ?? 1;
    int jsonDelay = NavigationService.navigatorKey.currentContext!
            .read<AdBase>()
            .data!['rateUsDelay'] ??
        20;
    if (rateUsDelay % jsonDelay == 0) {
      final InAppReview inAppReview = InAppReview.instance;
      if (await inAppReview.isAvailable()) {
        preferences.setInt("rateUsDelay", rateUsDelay + 1);
        inAppReview.requestReview();
      }
    } else {
      preferences.setInt("rateUsDelay", rateUsDelay + 1);
    }
  }
}
