#import "AdpluginxPlugin.h"
#if __has_include(<adpluginx/adpluginx-Swift.h>)
#import <adpluginx/adpluginx-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "adpluginx-Swift.h"
#endif

@implementation AdpluginxPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAdpluginxPlugin registerWithRegistrar:registrar];
}
@end
