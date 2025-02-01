import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/widgets/custome_small_light.dart'; // تأكد من استيراد الملف الصحيح
import 'package:smart_home/widgets/custome_big_ac.dart'; // تأكد من استيراد الملف الصحيح

class DevicesWrap extends StatelessWidget {
  final String currentId;
  const DevicesWrap({super.key, required this.currentId});

  @override
  Widget build(BuildContext context) {
    // ✅ الحصول على مرجع لقاعدة البيانات
    DatabaseReference devicesRef = FirebaseDatabase.instance.ref('devices');

    return StreamBuilder<DatabaseEvent>(
      stream: devicesRef
          .orderByChild("roomId")
          .equalTo(currentId)
          .onValue, // الاستماع للتغييرات في قاعدة البيانات
      builder: (context, snapshot) {
        // ✅ فحص حالة الاتصال
        bool isLoading = snapshot.connectionState == ConnectionState.waiting;
        bool hasData =
            snapshot.hasData && snapshot.data!.snapshot.value != null;

        // ✅ تخزين البيانات في متغيرات
        Map<dynamic, dynamic>? devices = hasData
            ? snapshot.data!.snapshot.value as Map<dynamic, dynamic>?
            : null;

        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!hasData || devices == null) {
          return const Center(child: Text("لا توجد أجهزة متاحة"));
        }

        // ✅ تحويل البيانات إلى قائمة
        List<MapEntry<dynamic, dynamic>> deviceList = devices.entries.toList();

        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: deviceList.map((entry) {
            // ✅ استخراج بيانات الجهاز
            String deviceId = entry.key; // معرّف الجهاز
            Map<dynamic, dynamic> deviceData = entry.value; // بيانات الجهاز

            // ✅ استخراج اسم الجهاز ونوعه
            String deviceName = deviceData['name'] ?? "جهاز غير معروف";
            String deviceType =
                deviceData['type'] ?? "light"; // نوع الجهاز (افتراضي: light)

            // ✅ التحقق من نوع الجهاز واستخدام الـ Widget المناسب
            if (deviceType == "ac") {
              return CustomeBigContiner(
                massageText: deviceName,
                deviceId: deviceId,
                // تمرير معرّف الجهاز هنا
              );
            } else {
              return CustomeSmallContiner(
                messageText: deviceName,
                deviceId: deviceId, // تمرير معرّف الجهاز هنا
              );
            }
          }).toList(),
        );
      },
    );
  }
}
