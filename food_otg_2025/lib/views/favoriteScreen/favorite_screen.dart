import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_otg_2025/common/reusable_text.dart';
import 'package:food_otg_2025/services/collection_refrences.dart';

import '../../constants/constants.dart';
import '../../utils/app_styles.dart';

class WishlistScreen extends StatefulWidget {
  final String currentUserUid;

  WishlistScreen({required this.currentUserUid});

  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  Future<List<Map<String, dynamic>>> fetchWishlistAndDetails() async {
    var wishlistSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.currentUserUid)
        .collection('Wishlists')
        .get();

    List<Map<String, dynamic>> wishlistItems = [];

    for (var doc in wishlistSnapshot.docs) {
      String foodId = doc['foodId'];
      var foodDoc = await FirebaseFirestore.instance
          .collection('Items')
          .doc(foodId)
          .get();
      var foodDetails = foodDoc.data();
      if (foodDetails != null) {
        wishlistItems.add({
          'wishId': doc.id,
          'foodId': foodId,
          'foodDetails': foodDetails,
        });
      }
    }

    return wishlistItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Wishlist'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchWishlistAndDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Your wishlist is empty.'));
          }

          var wishlistItems = snapshot.data!;

          return ListView.builder(
            itemCount: wishlistItems.length,
            itemBuilder: (context, index) {
              var wishlistItem = wishlistItems[index];
              var foodDetails = wishlistItem['foodDetails'];

              return FavoriteFoodTileWidget(
                  food: foodDetails, wishlistItem: wishlistItem);
            },
          );
        },
      ),
    );
  }
}

class FavoriteFoodTileWidget extends StatefulWidget {
  const FavoriteFoodTileWidget(
      {Key? key, required this.food, required this.wishlistItem});

  final dynamic food;
  final dynamic wishlistItem;

  @override
  State<FavoriteFoodTileWidget> createState() => _FavoriteFoodTileWidgetState();
}

class _FavoriteFoodTileWidgetState extends State<FavoriteFoodTileWidget> {
  Future<void> removeFromWishlist(String wishId) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUId)
        .collection("Wishlists")
        .doc(wishId)
        .delete()
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Food removed from wishlist'),
      ));
      setState(() {}); // Refresh the screen
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to remove food from wishlist: $error'),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      // clipBehavior: Clip.hardEdge,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 8.h),
          height: 75.h,
          width: width,
          decoration: BoxDecoration(
            color: kOffWhite,
            borderRadius: BorderRadius.circular(9.r),
          ),
          child: Container(
            padding: EdgeInsets.all(4.r),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(12.r)),
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 70.h,
                        width: 70.w,
                        child: Image.network(widget.food["image"],
                            fit: BoxFit.cover),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          padding: EdgeInsets.only(left: 6.w, bottom: 2.h),
                          color: kGray.withOpacity(0.6),
                          height: 16.h,
                          width: width,
                          child: RatingBarIndicator(
                            rating: widget.food["rating"].toDouble(),
                            itemCount: 5,
                            itemSize: 15.h,
                            itemBuilder: (ctx, i) =>
                                const Icon(Icons.star, color: Colors.amber),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ReusableText(
                        text: widget.food["title"],
                        style: appStyle(11, kDark, FontWeight.w400)),
                    ReusableText(
                        text: "Delivery Time ${widget.food["time"]}",
                        style: appStyle(11, kGray, FontWeight.w400)),
                  ],
                )
              ],
            ),
          ),
        ),
        //Available price
        Positioned(
          right: 10.w,
          top: 10.h,
          child: CircleAvatar(
            backgroundColor: kLightWhite,
            child: Center(
              child: Icon(Icons.favorite, color: kRed),
            ),
          ),
        ),

        Positioned(
          right: 70.w,
          top: 10.h,
          child: GestureDetector(
            onTap: () => removeFromWishlist(widget.wishlistItem['wishId']),
            child: CircleAvatar(
              backgroundColor: kLightWhite,
              child: Center(
                child: Icon(Icons.delete, color: kRed),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
