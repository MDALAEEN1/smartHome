import 'package:flutter/material.dart';
import 'package:smart_home/const.dart';
import 'package:smart_home/firebase/get_RealTime.dart';
import 'package:smart_home/widgets/custome_icon.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  String currentId = "bed room";
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ العنوان والبيانات العلوية
              _buildTopSection(),

              // ✅ قائمة الغرف (ديناميكية)
              _buildRoomList(),

              // ✅ الأجهزة الذكية
              DevicesWrap(currentId: currentId),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ دالة لإنشاء القسم العلوي
  Widget _buildTopSection() {
    List<Map<String, String>> info = [
      {"value": "10", "label": "Index Temp"},
      {"value": "39.1%", "label": "Outdoor Humidity"},
      {"value": "25", "label": "Outdoor Temp"},
    ];

    return Container(
      height: 225,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          )
        ],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ✅ العنوان وصورة المستخدم
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 100, width: 170, color: kAppColor),
                const CircleAvatar(
                  radius: 35,
                  child: ClipOval(
                    child: Image(
                      image: AssetImage("images/woman.png"),
                      fit: BoxFit.cover,
                      width: 70,
                      height: 70,
                    ),
                  ),
                ),
              ],
            ),
            // ✅ معلومات الطقس
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: info
                  .map(
                      (data) => buildInfoColumn(data["value"]!, data["label"]!))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ قائمة الغرف باستخدام `ListView.builder`
  Widget _buildRoomList() {
    List<Map<String, String>> rooms = [
      {"icon": "images/home.png", "label": "bed room", "id": "bed room"},
      {"icon": "images/kitchen.png", "label": "kitchen", "id": "kitchen"},
      {
        "icon": "images/interior-design.png",
        "label": "living room",
        "id": "living room"
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 70,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: rooms.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 15),
              child: CustomIcon(
                iconPic: rooms[index]["icon"]!,
                background: currentId == rooms[index]['id']!
                    ? kAppColor
                    : kBackgroundColor,
                iconText: rooms[index]["label"]!,
                onTap: () {
                  setState(() {
                    currentId = rooms[index]["id"]!;
                    print(currentId);
                  });
                },
              ),
            );
          },
        ),
      ),
    );
  }

  // ✅ دالة لإنشاء عنصر معلومات
  Widget buildInfoColumn(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(color: Colors.black54)),
        const SizedBox(height: 10),
      ],
    );
  }
}
