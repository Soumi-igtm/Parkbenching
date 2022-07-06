import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parkbenching/view/constant/color.dart';
import 'package:parkbenching/view/widget/custom_app_bar.dart';
import 'package:parkbenching/view/widget/my_text.dart';
import 'package:intl/intl.dart';
import 'constant/common.dart';
import 'constant/images.dart';

class BenchHistory extends StatefulWidget {
  final String uid;
  const BenchHistory({Key? key, required this.uid}) : super(key: key);

  @override
  State<BenchHistory> createState() => _BenchHistoryState();
}

class _BenchHistoryState extends State<BenchHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Bench History"),
      body: StreamBuilder<QuerySnapshot>(
          stream: benchesCollection.where("uid", isEqualTo: widget.uid).orderBy("addedOn", descending: true).snapshots(),
          builder: (context, rSnapshot) {
            if (!rSnapshot.hasData) return const Center(child: CircularProgressIndicator());
            List<DocumentSnapshot> benchList = rSnapshot.data!.docs;
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              itemCount: benchList.length,
              itemBuilder: (context, index) {
                return StreamBuilder<DocumentSnapshot>(
                    stream: usersCollection.doc(benchList[index]["uid"]).snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return Container();
                      DocumentSnapshot uData = snapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: uData["image"].isEmpty
                                ? Image.asset(
                                    kProfileIcon,
                                    height: 40,
                                    fit: BoxFit.fitHeight,
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: CachedNetworkImage(
                                      imageUrl: uData["image"],
                                      placeholder: (context, s) => Image.asset(kProfileIcon),
                                      height: 40,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                            title: MyText(
                                text: uData["name"].isEmpty ? "No Name" : uData["name"],
                                size: 16,
                                maxLines: 1,
                                overFlow: TextOverflow.ellipsis,
                                weight: FontWeight.bold),
                            subtitle: MyText(text: DateFormat.yMMMMd().format(benchList[index]["addedOn"].toDate()), size: 12),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 200,
                            child: PageView.builder(
                                itemCount: benchList[index]["images"].length,
                                itemBuilder: (context, i) {
                                  return Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: CachedNetworkImage(
                                          imageUrl: benchList[index]["images"][i],
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        top: 6,
                                        right: 6,
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: const ShapeDecoration(shape: StadiumBorder(), color: kPrimaryColor),
                                          child: MyText(
                                            text: "${i + 1} / ${benchList[index]["images"].length}",
                                            size: 12,
                                            weight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                }),
                          ),
                        ],
                      );
                    });
              },
              separatorBuilder: (BuildContext context, int index) => const Divider(),
            );
          }),
    );
  }
}
