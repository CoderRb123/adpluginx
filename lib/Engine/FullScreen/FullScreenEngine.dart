// 🐦 Flutter imports:
import 'dart:async';

import 'package:adpluginx/AdBase/IronSource/IronRewardListner.dart';
import 'package:adpluginx/AdBase/Yodo/FullScreen/YodoFullScreenCallerX.dart';
import 'package:adpluginx/Logger/AdLogger.dart';
import 'package:adpluginx/Utils/DefaultValueProvider.dart';
import 'package:adpluginx/Utils/DeviceInformation/PackageInfoX.dart';
import 'package:adpluginx/Utils/UrlConst.dart';
import 'package:adpluginx/Widget/Loader/LoaderProvider.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:dog/dog.dart';
import 'package:ironsource_mediation/ironsource_mediation.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:adpluginx/AdBase/AppLovin/AppLovinReward.dart';
import 'package:adpluginx/Engine/Model/ScreenWiseModel.dart';
import 'package:adpluginx/adpluginx.dart';

import '../../AdBase/AppLovin/FullScreen/AppLovinFullScreenX.dart';

class FullScreenEngine {
  static final FullScreenEngine _singleton = FullScreenEngine._internal();

  factory FullScreenEngine() {
    return _singleton;
  }

  FullScreenEngine._internal();

  Map routeIndex = {};
  int currentAdIndex = 0;
  int failCounter = 0;
  int MAX_RETRY = 3;
  Timer? timer;
  ScreenWiseModel? screenWiseModel;

  Function()? onJobComplete;

  indexIncrement({String? route, bool isDefault = false}) {
    dog.i(" Incremetn =====> $route");
    if (screenWiseModel != null) {
      int arrayLength = screenWiseModel!.localClick!.length - 1;
      if (route != null) {
        dog.i("Route Not Null ======> $route");
        if (routeIndex[route] == null) {
          dog.i("Route INit ======>");
          if ((arrayLength + 1) == 1) {
            routeIndex[route] = 0;
          } else {
            routeIndex[route] = 1;
          }
        } else {
          if (routeIndex[route] != arrayLength &&
              routeIndex[route] < arrayLength) {
            dog.i("Route Increment ======>");
            routeIndex[route]++;
          } else {
            dog.i("Route Reset ======>");
            routeIndex[route] = 0;
          }
        }
      } else {
        if (currentAdIndex < arrayLength && currentAdIndex != arrayLength) {
          currentAdIndex++;
        } else {
          currentAdIndex = 0;
        }
      }
    }
    if (onJobComplete != null) {
      onJobComplete!();
    }
  }

  bool loopBreaker({int? retry}) {
    dog.i("Retrying ========> $failCounter");
    dog.i((retry ?? MAX_RETRY).toString());
    if (failCounter < (retry ?? MAX_RETRY)) {
      failCounter++;
      return false;
    }
    failCounter = 0;
    return true;
  }

  showAds(
      {required BuildContext context,
      String action = "default",
      required Function() onJobComplete,
      required Function() onTimeOut}) {
    this.onJobComplete = onJobComplete;

    ModalRoute? route = ModalRoute.of(context);
    AdBase adBase = context.read<AdBase>();
    Map? local = adBase.data![PackageInfoX().version ?? "0.0.1"]['screens']
        [route?.settings.name];
    dog.i("Route ======>${route?.settings.name}");
    if (local != null) {
      // Have Route Locals
      dog.i("Local Founded");
      screenWiseModel = ScreenWiseModel.fromMapLocalAndGlobal(
        local,
        adBase.data![PackageInfoX().version ?? "0.0.1"]['globalConfig'],
      );
    } else {
      dog.i("Global Data");
      // Take it Global
      screenWiseModel = ScreenWiseModel.fromGlobalOnly(
        adBase.data![PackageInfoX().version ?? "0.0.1"]['globalConfig'],
      );
    }

    _showAd(route: route?.settings.name, context: context);
  }

  showActionAds(
      {required BuildContext context,
      required String actionName,
      required Function() onJobComplete}) {
    this.onJobComplete = onJobComplete;
    AdBase adBase = context.read<AdBase>();
    Map? local =
        adBase.data![PackageInfoX().version ?? "0.0.1"]['actions'][actionName];
    if (local != null) {
      // Have Route Locals
      dog.i("Local Founded");
      screenWiseModel = ScreenWiseModel.fromMapLocalAndGlobal(
        local,
        adBase.data![PackageInfoX().version ?? "0.0.1"]['globalConfig'],
      );
    } else {
      dog.i("Global Data");
      // Take it Global
      screenWiseModel = ScreenWiseModel.fromGlobalOnly(
        adBase.data![PackageInfoX().version ?? "0.0.1"]['globalConfig'],
      );
    }
    _showAd(route: actionName, context: context);
  }

  _showAd({
    String? route,
    required BuildContext context,
    String action = "default",
  }) {
    AdBase adBase = context.read<AdBase>();
    int index = route != null ? (routeIndex[route] ?? 0) : currentAdIndex;
    if ((adBase.data![PackageInfoX().version ?? "0.0.1"]['isAdsOn'] ?? false) ==
        false) {
      if (onJobComplete != null) {
        onJobComplete!();
      }
      return;
    }
    if ((screenWiseModel!.localAdFlag ?? false) == false) {
      if (onJobComplete != null) {
        onJobComplete!();
      }
      return;
    }
    switch (screenWiseModel!.localClick![index]) {
      case 0:
        if (screenWiseModel!.overRideTimer!) {
          timer = Timer(Duration(seconds: screenWiseModel!.overRideTimerValue!),
              () {
            _failed(0, route: route);
          });
        }
        dog.i(" -------  Case Google -------- ");
        GoogleCallerX().loadGoogleAd(
          adType: GoogleAdType.fullScreen,
          callerInterface: AdCallerInterface(
            onClose: () {
              if (screenWiseModel!.overRideTimer!) {
                timer?.cancel();
              }
              indexIncrement(route: route);
            },
            onError: () {
              if (screenWiseModel!.overRideTimer!) {
                timer?.cancel();
              }
              _failed(0, route: route);
            },
            onStarted: () {},
            onLoaded: () {
              if (screenWiseModel!.overRideTimer!) {
                timer?.cancel();
              }
              AdLogger.logAd(provider: "Google", status: "Load");
            },
            onFailedToLoad: () {},
          ),
        );
        break;
      case 1:
        if (screenWiseModel!.overRideTimer!) {
          timer = Timer(Duration(seconds: screenWiseModel!.overRideTimerValue!),
              () {
            _failed(1, route: route);
          });
        }
        dog.i("Case Facebook");
        FacebookCallerX().loadFacebook(
          adType: FacebookAdType.fullScreen,
          callerInterface: AdCallerInterface(
            onClose: () {
              if (screenWiseModel!.overRideTimer!) {
                timer?.cancel();
              }
              indexIncrement(route: route);
            },
            onError: () {
              if (screenWiseModel!.overRideTimer!) {
                timer?.cancel();
              }
              _failed(1, route: route);
            },
            onStarted: () {},
            onLoaded: () {
              if (screenWiseModel!.overRideTimer!) {
                timer?.cancel();
              }
            },
            onFailedToLoad: () {},
          ),
        );
        break;
      case 2:
        if (screenWiseModel!.overRideTimer!) {
          timer = Timer(Duration(seconds: screenWiseModel!.overRideTimerValue!),
              () {
            _failed(2, route: route);
          });
        }
        dog.i("Case Unity");
        UnityCallerX().loadUnityAd(
          adType: UnityAdType.fullScreen,
          callerInterface: AdCallerInterface(
            onClose: () {
              if (screenWiseModel!.overRideTimer!) {
                timer?.cancel();
              }
              indexIncrement(route: route);
            },
            onError: () {
              if (screenWiseModel!.overRideTimer!) {
                timer?.cancel();
              }
              _failed(2, route: route);
            },
            onStarted: () {},
            onLoaded: () {
              if (screenWiseModel!.overRideTimer!) {
                timer?.cancel();
              }
            },
            onFailedToLoad: () {},
          ),
        );
        break;

      case 3:
        if (screenWiseModel!.overRideTimer!) {
          timer = Timer(Duration(seconds: screenWiseModel!.overRideTimerValue!),
              () {
            _failed(3, route: route);
          });
        }
        dog.e("----- Case  IronSource ------------");
        IronSourceFullScreenX ironSourceFullScreenX =
            IronSourceFullScreenX.onInit(
          onClose: () {
            if (screenWiseModel!.overRideTimer!) {
              timer?.cancel();
            }
            indexIncrement(route: route);
            AdLogger.logAd(
                provider: ironSourceInterKey, status: adDismissedKey);
          },
          onFailed: () {
            if (screenWiseModel!.overRideTimer!) {
              timer?.cancel();
            }
            dog.e("----- Failed on IronSource ------------");
            AdLogger.logAd(provider: ironSourceInterKey, status: adFailedKey);
            _failed(3, route: route);
          },
          onLoaded: () {
            if (screenWiseModel!.overRideTimer!) {
              timer?.cancel();
            }
            AdLogger.logAd(provider: ironSourceInterKey, status: adLoadedKey);
            IronSource.showInterstitial();
          },
        );
        IronSource.setISListener(ironSourceFullScreenX);
        IronSource.loadInterstitial();
        break;
      case 4:
        if (screenWiseModel!.overRideTimer!) {
          timer = Timer(Duration(seconds: screenWiseModel!.overRideTimerValue!),
              () {
            _failed(4, route: route);
          });
        }
        dog.i("Case Google Reward Normal");

        GoogleCallerX().loadGoogleAd(
          adType: GoogleAdType.rewardNormal,
          callerInterface: AdCallerInterface(
            onRewardSkip: () {
              if (screenWiseModel!.overRideTimer!) {
                timer?.cancel();
              }
              context.read<LoaderProvider>().isAdLoading = false;
              if (screenWiseModel!.overRideReward!) {
                indexIncrement(route: route);
              }
            },
            onClose: () {
              if (screenWiseModel!.overRideTimer!) {
                timer?.cancel();
              }
              indexIncrement(route: route);
            },
            onError: () {
              if (screenWiseModel!.overRideTimer!) {
                timer?.cancel();
              }
              _failed(4, route: route);
            },
            onStarted: () {},
            onLoaded: () {
              if (screenWiseModel!.overRideTimer!) {
                timer?.cancel();
              }
            },
            onFailedToLoad: () {},
          ),
        );
        break;
      case 5:
        if (screenWiseModel!.overRideTimer!) {
          timer = Timer(Duration(seconds: screenWiseModel!.overRideTimerValue!),
              () {
            _failed(5, route: route);
          });
        }
        dog.i("Case Google Reward Video");
        GoogleCallerX().loadGoogleAd(
          adType: GoogleAdType.rewardVideo,
          callerInterface: AdCallerInterface(
            onRewardSkip: () {
              if (screenWiseModel!.overRideTimer!) {
                timer?.cancel();
              }
              context.read<LoaderProvider>().isAdLoading = false;
              if (screenWiseModel!.overRideReward!) {
                indexIncrement(route: route);
              }
            },
            onClose: () {
              if (screenWiseModel!.overRideTimer!) {
                timer?.cancel();
              }
              indexIncrement(route: route);
            },
            onError: () {
              if (screenWiseModel!.overRideTimer!) {
                timer?.cancel();
              }
              _failed(5, route: route);
            },
            onStarted: () {},
            onLoaded: () {
              if (screenWiseModel!.overRideTimer!) {
                timer?.cancel();
              }
            },
            onFailedToLoad: () {},
          ),
        );
        break;
      case 6:
        if (screenWiseModel!.overRideTimer!) {
          timer = Timer(Duration(seconds: screenWiseModel!.overRideTimerValue!),
              () {
            _failed(6, route: route);
          });
        }
        dog.i("Case Unity Reward Video");
        UnityCallerX().loadUnityAd(
          adType: UnityAdType.rewardVideo,
          callerInterface: AdCallerInterface(
            onRewardSkip: () {
              context.read<LoaderProvider>().isAdLoading = false;
              if (screenWiseModel!.overRideReward!) {
                indexIncrement(route: route);
              }
            },
            onClose: () {
              if (screenWiseModel!.overRideTimer!) {
                timer?.cancel();
              }
              indexIncrement(route: route);
            },
            onError: () {
              if (screenWiseModel!.overRideTimer!) {
                timer?.cancel();
              }
              _failed(6, route: route);
            },
            onStarted: () {},
            onLoaded: () {
              if (screenWiseModel!.overRideTimer!) {
                timer?.cancel();
              }
            },
            onFailedToLoad: () {},
          ),
        );
        break;
      case 7:
        if (screenWiseModel!.overRideTimer!) {
          timer = Timer(Duration(seconds: screenWiseModel!.overRideTimerValue!),
              () {
            _failed(7, route: route);
          });
        }
        dog.i("Case Unity Normal Full Video");
        UnityCallerX().loadUnityAd(
          adType: UnityAdType.normalFullScreen,
          callerInterface: AdCallerInterface(
            onClose: () {
              if (screenWiseModel!.overRideTimer!) {
                timer?.cancel();
              }
              indexIncrement(route: route);
            },
            onError: () {
              if (screenWiseModel!.overRideTimer!) {
                timer?.cancel();
              }
              _failed(7, route: route);
            },
            onStarted: () {},
            onLoaded: () {
              if (screenWiseModel!.overRideTimer!) {
                timer?.cancel();
              }
            },
            onFailedToLoad: () {},
          ),
        );
        break;
      case 8:
        dog.i(screenWiseModel!.overRideTimer.toString());
        dog.i(screenWiseModel!.toJson());
        if (screenWiseModel!.overRideTimer!) {
          timer = Timer(Duration(seconds: screenWiseModel!.overRideTimerValue!),
              () {
            dog.i("Timer Failed =========> ${screenWiseModel!.maxFailed}");
            _failed(8, route: route);
          });
        }
        dog.i("Case AppLovin Normal Full Video");
        AppLovinFullScreenX().callAds(
          adCallerInterface: AdCallerInterface(
            onClose: () {
              if (screenWiseModel!.overRideTimer!) {
                timer?.cancel();
              }
              indexIncrement(route: route);
            },
            onError: () {
              if (screenWiseModel!.overRideTimer!) {
                timer?.cancel();
              }
              _failed(8, route: route);
            },
            onStarted: () {},
            onLoaded: () {
              if (screenWiseModel!.overRideTimer!) {
                timer?.cancel();
              }
            },
            onFailedToLoad: () {},
          ),
        );
        break;
      case 9:
        if (screenWiseModel!.overRideTimer!) {
          timer = Timer(Duration(seconds: screenWiseModel!.overRideTimerValue!),
              () {
            _failed(9, route: route);
          });
        }
        dog.i("Case AppLovin Reward Full Video");
        AppLovinReward().callAds(
          adCallerInterface: AdCallerInterface(
            onRewardSkip: () {
              context.read<LoaderProvider>().isAdLoading = false;
              if (screenWiseModel!.overRideReward!) {
                indexIncrement(route: route);
              }
            },
            onClose: () {
              if (screenWiseModel!.overRideTimer!) {
                timer?.cancel();
              }
              if (!screenWiseModel!.overRideReward!) {
                indexIncrement(route: route);
              }
            },
            onError: () {
              if (screenWiseModel!.overRideTimer!) {
                timer?.cancel();
              }
              _failed(9, route: route);
            },
            onStarted: () {},
            onLoaded: () {
              if (screenWiseModel!.overRideTimer!) {
                timer?.cancel();
              }
            },
            onFailedToLoad: () {},
          ),
        );
        break;
      case 13:
        if (screenWiseModel!.overRideTimer!) {
          timer = Timer(Duration(seconds: screenWiseModel!.overRideTimerValue!),
              () {
            _failed(13, route: route);
          });
        }
        dog.e("----- Case IronSource Reward ------------");
        IronRewardListener ironRewardListener = IronRewardListener.onInit(
          onRewarded: () {
            dog.e("----- Reward on IronSource ------------");
            if (!screenWiseModel!.overRideReward!) {
              indexIncrement(route: route);
            }
          },
          onClose: () {
            if (screenWiseModel!.overRideTimer!) {
              timer?.cancel();
            }
            dog.e("----- Close on IronSource ------------");
            if (screenWiseModel!.overRideReward!) {
              indexIncrement(route: route);
            }
          },
          onFailed: () {
            if (screenWiseModel!.overRideTimer!) {
              timer?.cancel();
            }
            dog.e("----- Failed on IronSource ------------");
            AdLogger.logAd(provider: ironSourceInterKey, status: adFailedKey);
            _failed(13, route: route);
          },
          onLoaded: () {
            dog.e("----- Loaded on IronSource ------------");
            if (screenWiseModel!.overRideTimer!) {
              timer?.cancel();
            }
          },
        );
        IronSource.setRVListener(ironRewardListener);
        IronSource.loadRewardedVideo();
        IronSource.showRewardedVideo();
        break;
      default:
        indexIncrement(route: route, isDefault: true);
    }
  }

  _failed(int from, {String? route}) {
    dog.i("Failed From =====> $from");
    Map? failedMapArray = screenWiseModel!.localFail;
    int caseIndex = failedMapArray![from.toString()];
    dog.i("Before Loop breaker======>");

    if (loopBreaker(retry: screenWiseModel!.maxFailed)) {
      dog.i("Loop Break======>");
      if (onJobComplete != null) {
        onJobComplete!();
      }
    } else {
      dog.i("After Loop Breaker======>");
      switch (caseIndex) {
        case 0:
          if (screenWiseModel!.overRideTimer!) {
            timer = Timer(
                Duration(seconds: screenWiseModel!.overRideTimerValue!), () {
              _failed(0, route: route);
            });
          }
          dog.i(" -------  Case Google -------- ");
          GoogleCallerX().loadGoogleAd(
            adType: GoogleAdType.fullScreen,
            callerInterface: AdCallerInterface(
              onClose: () {
                if (screenWiseModel!.overRideTimer!) {
                  timer?.cancel();
                }
                indexIncrement(route: route);
              },
              onError: () {
                if (screenWiseModel!.overRideTimer!) {
                  timer?.cancel();
                }
                _failed(0, route: route);
              },
              onStarted: () {},
              onLoaded: () {
                if (screenWiseModel!.overRideTimer!) {
                  timer?.cancel();
                }
                AdLogger.logAd(provider: "Google", status: "Load");
              },
              onFailedToLoad: () {},
            ),
          );
          break;
        case 1:
          if (screenWiseModel!.overRideTimer!) {
            timer = Timer(
                Duration(seconds: screenWiseModel!.overRideTimerValue!), () {
              _failed(1, route: route);
            });
          }
          dog.i("Case Facebook");
          FacebookCallerX().loadFacebook(
            adType: FacebookAdType.fullScreen,
            callerInterface: AdCallerInterface(
              onClose: () {
                if (screenWiseModel!.overRideTimer!) {
                  timer?.cancel();
                }
                indexIncrement(route: route);
              },
              onError: () {
                if (screenWiseModel!.overRideTimer!) {
                  timer?.cancel();
                }
                _failed(1, route: route);
              },
              onStarted: () {},
              onLoaded: () {
                if (screenWiseModel!.overRideTimer!) {
                  timer?.cancel();
                }
              },
              onFailedToLoad: () {},
            ),
          );
          break;
        case 2:
          if (screenWiseModel!.overRideTimer!) {
            timer = Timer(
                Duration(seconds: screenWiseModel!.overRideTimerValue!), () {
              _failed(2, route: route);
            });
          }
          dog.i("Case Unity");

          UnityCallerX().loadUnityAd(
            adType: UnityAdType.fullScreen,
            callerInterface: AdCallerInterface(
              onClose: () {
                if (screenWiseModel!.overRideTimer!) {
                  timer?.cancel();
                }
                indexIncrement(route: route);
              },
              onError: () {
                if (screenWiseModel!.overRideTimer!) {
                  timer?.cancel();
                }
                _failed(2, route: route);
              },
              onStarted: () {},
              onLoaded: () {
                if (screenWiseModel!.overRideTimer!) {
                  timer?.cancel();
                }
              },
              onFailedToLoad: () {},
            ),
          );
          break;

        case 3:
          if (screenWiseModel!.overRideTimer!) {
            timer = Timer(
                Duration(seconds: screenWiseModel!.overRideTimerValue!), () {
              _failed(3, route: route);
            });
          }
          IronSourceFullScreenX ironSourceFullScreenX =
              IronSourceFullScreenX.onInit(
            onClose: () {
              if (screenWiseModel!.overRideTimer!) {
                timer?.cancel();
              }
              indexIncrement(route: route);
              AdLogger.logAd(
                  provider: ironSourceInterKey, status: adDismissedKey);
            },
            onFailed: () {
              if (screenWiseModel!.overRideTimer!) {
                timer?.cancel();
              }
              dog.e("----- Failed on IronSource ------------");
              AdLogger.logAd(provider: ironSourceInterKey, status: adFailedKey);
              _failed(3, route: route);
            },
            onLoaded: () {
              if (screenWiseModel!.overRideTimer!) {
                timer?.cancel();
              }
              AdLogger.logAd(provider: ironSourceInterKey, status: adLoadedKey);
              IronSource.showInterstitial();
            },
          );
          IronSource.setISListener(ironSourceFullScreenX);
          IronSource.loadInterstitial();
          break;
        case 4:
          if (screenWiseModel!.overRideTimer!) {
            timer = Timer(
                Duration(seconds: screenWiseModel!.overRideTimerValue!), () {
              _failed(4, route: route);
            });
          }
          dog.i("Case Google Reward Normal");

          GoogleCallerX().loadGoogleAd(
            adType: GoogleAdType.rewardNormal,
            callerInterface: AdCallerInterface(
              onRewardSkip: () {
                NavigationService.navigatorKey.currentContext!
                    .read<LoaderProvider>()
                    .isAdLoading = false;
                if (screenWiseModel!.overRideReward!) {
                  indexIncrement(route: route);
                }
              },
              onClose: () {
                if (screenWiseModel!.overRideTimer!) {
                  timer?.cancel();
                }
                indexIncrement(route: route);
              },
              onError: () {
                if (screenWiseModel!.overRideTimer!) {
                  timer?.cancel();
                }
                _failed(4, route: route);
              },
              onStarted: () {},
              onLoaded: () {
                if (screenWiseModel!.overRideTimer!) {
                  timer?.cancel();
                }
              },
              onFailedToLoad: () {},
            ),
          );
          break;
        case 5:
          if (screenWiseModel!.overRideTimer!) {
            timer = Timer(
                Duration(seconds: screenWiseModel!.overRideTimerValue!), () {
              _failed(5, route: route);
            });
          }
          dog.i("Case Google Reward Video");
          GoogleCallerX().loadGoogleAd(
            adType: GoogleAdType.rewardVideo,
            callerInterface: AdCallerInterface(
              onRewardSkip: () {
                NavigationService.navigatorKey.currentContext!
                    .read<LoaderProvider>()
                    .isAdLoading = false;
                if (screenWiseModel!.overRideReward!) {
                  indexIncrement(route: route);
                }
              },
              onClose: () {
                if (screenWiseModel!.overRideTimer!) {
                  timer?.cancel();
                }
                indexIncrement(route: route);
              },
              onError: () {
                if (screenWiseModel!.overRideTimer!) {
                  timer?.cancel();
                }
                _failed(5, route: route);
              },
              onStarted: () {},
              onLoaded: () {
                if (screenWiseModel!.overRideTimer!) {
                  timer?.cancel();
                }
              },
              onFailedToLoad: () {},
            ),
          );
          break;
        case 6:
          if (screenWiseModel!.overRideTimer!) {
            timer = Timer(
                Duration(seconds: screenWiseModel!.overRideTimerValue!), () {
              _failed(6, route: route);
            });
          }
          dog.i("Case Unity Reward Video");
          UnityCallerX().loadUnityAd(
            adType: UnityAdType.rewardVideo,
            callerInterface: AdCallerInterface(
              onRewardSkip: () {
                NavigationService.navigatorKey.currentContext!
                    .read<LoaderProvider>()
                    .isAdLoading = false;
                if (screenWiseModel!.overRideReward!) {
                  indexIncrement(route: route);
                }
              },
              onClose: () {
                if (screenWiseModel!.overRideTimer!) {
                  timer?.cancel();
                }
                indexIncrement(route: route);
              },
              onError: () {
                if (screenWiseModel!.overRideTimer!) {
                  timer?.cancel();
                }
                _failed(6, route: route);
              },
              onStarted: () {},
              onLoaded: () {
                if (screenWiseModel!.overRideTimer!) {
                  timer?.cancel();
                }
              },
              onFailedToLoad: () {},
            ),
          );
          break;
        case 7:
          if (screenWiseModel!.overRideTimer!) {
            timer = Timer(
                Duration(seconds: screenWiseModel!.overRideTimerValue!), () {
              _failed(7, route: route);
            });
          }
          dog.i("Case Unity Normal Full Video");
          UnityCallerX().loadUnityAd(
            adType: UnityAdType.normalFullScreen,
            callerInterface: AdCallerInterface(
              onClose: () {
                if (screenWiseModel!.overRideTimer!) {
                  timer?.cancel();
                }
                indexIncrement(route: route);
              },
              onError: () {
                if (screenWiseModel!.overRideTimer!) {
                  timer?.cancel();
                }
                _failed(7, route: route);
              },
              onStarted: () {},
              onLoaded: () {
                if (screenWiseModel!.overRideTimer!) {
                  timer?.cancel();
                }
              },
              onFailedToLoad: () {},
            ),
          );
          break;
        case 8:
          dog.i(screenWiseModel!.overRideTimer.toString());
          dog.i(screenWiseModel!.toJson());
          if (screenWiseModel!.overRideTimer!) {
            timer = Timer(
                Duration(seconds: screenWiseModel!.overRideTimerValue!), () {
              dog.i("Timer Failed =========> ${screenWiseModel!.maxFailed}");
              _failed(8, route: route);
            });
          }
          dog.i("Case AppLovin Normal Full Video");
          AppLovinFullScreenX().callAds(
            adCallerInterface: AdCallerInterface(
              onClose: () {
                if (screenWiseModel!.overRideTimer!) {
                  timer?.cancel();
                }
                indexIncrement(route: route);
              },
              onError: () {
                if (screenWiseModel!.overRideTimer!) {
                  timer?.cancel();
                }
                _failed(8, route: route);
              },
              onStarted: () {},
              onLoaded: () {
                if (screenWiseModel!.overRideTimer!) {
                  timer?.cancel();
                }
              },
              onFailedToLoad: () {},
            ),
          );
          break;
        case 9:
          if (screenWiseModel!.overRideTimer!) {
            timer = Timer(
                Duration(seconds: screenWiseModel!.overRideTimerValue!), () {
              _failed(9, route: route);
            });
          }
          dog.i("Case AppLovin Reward Full Video");
          AppLovinReward().callAds(
            adCallerInterface: AdCallerInterface(
              onRewardSkip: () {
                NavigationService.navigatorKey.currentContext!
                    .read<LoaderProvider>()
                    .isAdLoading = false;
                if (screenWiseModel!.overRideTimer!) {
                  timer?.cancel();
                }
                if (screenWiseModel!.overRideReward!) {
                  indexIncrement(route: route);
                }
              },
              onClose: () {
                if (!screenWiseModel!.overRideReward!) {
                  indexIncrement(route: route);
                }
              },
              onError: () {
                if (screenWiseModel!.overRideTimer!) {
                  timer?.cancel();
                }
                _failed(9, route: route);
              },
              onStarted: () {},
              onLoaded: () {
                if (screenWiseModel!.overRideTimer!) {
                  timer?.cancel();
                }
              },
              onFailedToLoad: () {},
            ),
          );
          break;

        case 13:
          if (screenWiseModel!.overRideTimer!) {
            timer = Timer(
                Duration(seconds: screenWiseModel!.overRideTimerValue!), () {
              _failed(13, route: route);
            });
          }
          dog.e("----- Case IronSource Reward ------------");
          IronRewardListener ironRewardListener = IronRewardListener.onInit(
            onRewarded: () {
              dog.e("----- Reward on IronSource ------------");
              if (!screenWiseModel!.overRideReward!) {
                indexIncrement(route: route);
              }
            },
            onClose: () {
              dog.e("----- Close on IronSource ------------");
              if (screenWiseModel!.overRideReward!) {
                indexIncrement(route: route);
              }
            },
            onFailed: () {
              if (screenWiseModel!.overRideTimer!) {
                timer?.cancel();
              }
              dog.e("----- Failed on IronSource ------------");
              AdLogger.logAd(provider: ironSourceInterKey, status: adFailedKey);
              _failed(13, route: route);
            },
            onLoaded: () {
              dog.e("----- Loaded on IronSource ------------");
              if (screenWiseModel!.overRideTimer!) {
                timer?.cancel();
              }
            },
          );
          IronSource.setRVListener(ironRewardListener);
          IronSource.loadRewardedVideo();
          IronSource.showRewardedVideo();
          break;
        default:
          indexIncrement(route: route, isDefault: true);
      }
    }
  }
}
