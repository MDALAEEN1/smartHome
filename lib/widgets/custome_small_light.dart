import 'dart:async'; // استيراد مكتبة StreamSubscription
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/const.dart'; // تأكد من استيراد الثوابت الخاصة بك

class CustomeSmallContiner extends StatefulWidget {
  final String messageText;
  final String
      deviceId; // معرّف الجهاز لربط التحديث بالجهاز الصحيح في قاعدة البيانات

  const CustomeSmallContiner({
    super.key,
    required this.messageText,
    required this.deviceId, // تمرير معرّف الجهاز
  });

  @override
  State<CustomeSmallContiner> createState() => _CustomeSmallContinerState();
}

class _CustomeSmallContinerState extends State<CustomeSmallContiner> {
  bool isSwitched = false; // متغير لحالة التبديل
  StreamSubscription<DatabaseEvent>?
      _subscription; // متغير لحفظ الاشتراك في Firebase

  @override
  void initState() {
    super.initState();
    _fetchDeviceState();
  }

  // ✅ جلب الحالة الأولية للجهاز من Firebase Realtime Database
  void _fetchDeviceState() {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("devices/${widget.deviceId}");

    _subscription = ref.onValue.listen((event) {
      final data = event.snapshot.value;

      if (data != null && data is Map) {
        if (mounted) {
          setState(() {
            isSwitched = data['isOn'] ?? false;
          });
        }
      }
    }, onError: (error) {
      print("خطأ أثناء جلب البيانات: $error");
    });
  }

  // ✅ تحديث حالة الجهاز في Firebase Realtime Database
  Future<void> updateDeviceState(bool value) async {
    if (isSwitched == value) return; // تجنب إرسال طلب إذا لم تتغير الحالة

    try {
      DatabaseReference ref =
          FirebaseDatabase.instance.ref("devices/${widget.deviceId}");
      await ref.update({
        'isOn': value,
      });

      if (mounted) {
        setState(() {
          isSwitched = value;
        });
      }
    } catch (e) {
      print("فشل في تحديث الحالة: $e");
    }
  }

  @override
  void dispose() {
    _subscription?.cancel(); // إلغاء الاشتراك عند التخلص من الـ State
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        width: 180,
        height: 185,
        decoration: BoxDecoration(
          color: kAppColor, // لون الخلفية من الثوابت
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ✅ الصورة مع زر التبديل
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ✅ صورة الجهاز
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      "images/lamp.png", // مسار صورة الجهاز
                      fit: BoxFit.cover,
                      width: 60, // تحديد حجم الصورة
                      height: 60,
                    ),
                  ),

                  // ✅ مفتاح التبديل
                  Transform.scale(
                    scale: 0.9,
                    child: Switch(
                      value: isSwitched,
                      onChanged: (value) {
                        updateDeviceState(
                            value); // تحديث الحالة في Realtime Database عند تغيير التبديل
                      },
                      activeColor: Colors.green,
                      activeTrackColor: Colors.lightGreenAccent,
                      inactiveThumbColor: Colors.grey,
                      inactiveTrackColor: Colors.grey.shade300,
                    ),
                  ),
                ],
              ),
            ),

            // ✅ نصوص الجهاز
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.messageText, // نص الرسالة
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 22, // تقليل حجم الخط لتحسين العرض
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow
                            .ellipsis, // تقصير النص الطويل بدلًا من كسره
                        maxLines: 1,
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "open | 1H 30Min", // نص إضافي
                        style: TextStyle(
                          color: Colors.black26,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
