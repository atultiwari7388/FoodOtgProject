import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_otg/common/dashed_divider.dart';
import 'package:food_otg/constants/constants.dart';
import 'package:food_otg/utils/app_styles.dart';

class CouponScreen extends StatelessWidget {
  final Function(String) onCouponSelected;

  CouponScreen({required this.onCouponSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Available Coupons"),
      ),
      body: Container(
        padding: EdgeInsets.all(12.h),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('coupons').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            return ListView.separated(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var couponData =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                return ListTile(
                  title: Text(couponData['couponName'],
                      style: appStyle(17, kDark, FontWeight.normal)),
                  subtitle: Text(
                      "${couponData['discountValue'].toString()} % OFF on minimum purchase ${couponData["minPurchaseAmount"].toString()}",
                      style: appStyle(10, kSecondary, FontWeight.normal)),
                  onTap: () {
                    onCouponSelected(couponData['couponName']);
                    Navigator.of(context).pop();
                  },
                  trailing: Container(
                    height: 35.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFF976E38),
                          Color(0xFFF8E79F),
                          Color(0xFF976E38),
                        ],
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        onCouponSelected(couponData['couponName']);
                        Navigator.of(context).pop();
                      },
                      child: Text("Apply",
                          style: appStyle(16, kDark, FontWeight.w500)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return DashedDivider();
              },
            );
          },
        ),
      ),
    );
  }
}
