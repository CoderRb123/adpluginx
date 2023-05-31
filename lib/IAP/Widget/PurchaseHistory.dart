import 'package:adpluginx/IAP/Helpers/InAppHelper.dart';
import 'package:adpluginx/Model/InAppPurchaseModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pmvvm/pmvvm.dart';

class PurchaseHistory extends HookWidget {
  final Function(InAppPurchaseModel purcahses) onChildRender;
  final Widget appBar;

  const PurchaseHistory({
    Key? key,
    required this.onChildRender,
    required this.appBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userPurchases = useState<List<InAppPurchaseModel>>([]);
    useEffect(() {
      Future.microtask(() async {
        userPurchases.value = await InAppHelper.getUserPurchases();
      });
      return () {};
    }, []);
    return Scaffold(
      backgroundColor: const Color(0xFF131316),
      body: Stack(
        children: [
          Positioned(
            top: 30.h,
            left: 0,
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.transparent,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.45),
                    spreadRadius: 20.0,
                    offset: const Offset(0, 0),
                    blurRadius: 50.0,
                  )
                ],
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            children: [
              appBar,
              Expanded(
                child: userPurchases.value.isEmpty
                    ? Center(
                        child: Text(
                          "No Data Founded",
                          style: TextStyle(color: Colors.grey, fontSize: 15.sp),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: userPurchases.value.length,
                        itemBuilder: (context, index) {
                          InAppPurchaseModel i = userPurchases.value[index];
                          return onChildRender(i);
                        },
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
