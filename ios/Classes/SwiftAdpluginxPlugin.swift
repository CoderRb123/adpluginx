import Flutter
import UIKit


public class SwiftAdpluginxPlugin: NSObject, FlutterPlugin{
    
    
    
   
  
   
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "adpluginx", binaryMessenger: registrar.messenger())
    let instance = SwiftAdpluginxPlugin()
   
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

//  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
//
//      switch call.method{
//      case "connectToVpn":
//          guard let args = call.arguments as? [String : Any] else {return}
//          let country = args["country"] as! String
//          let config = VPNConfigurator.init()
//          self.startVPN(location: VirtualLocation(name: Optional(country)),
//                success: {
//
//              result("Success")
//             },
//             completion: { err in
//              result("Error")
//              return;
//          })
//      case "isVpnConnected":
//          result(self.isConnectedToVpn)
//      default:
//          result(FlutterMethodNotImplemented)
//      }
//
//  }
    
  
//    public func stopVpnOnAppClose(){
//        NotificationCenter.default.addObserver(forName: UIApplication.willTerminateNotification, object: nil, queue: nil) { _ in
//            self.stopVPN { err  in
//                print(err)
//             }
//              print("terminated")
//       }
//    }
    
//    private var isConnectedToVpn: Bool {
//        if let settings = CFNetworkCopySystemProxySettings()?.takeRetainedValue() as? Dictionary<String, Any>,
//            let scopes = settings["__SCOPED__"] as? [String:Any] {
//            for (key, _) in scopes {
//             if key.contains("tap") || key.contains("tun") || key.contains("ppp") || key.contains("ipsec") {
//                    return true
//                }
//            }
//        }
//        return false
//    }
}
