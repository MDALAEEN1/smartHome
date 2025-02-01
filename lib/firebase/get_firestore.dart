import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/widgets/custome_small_light.dart';

class DevicesWrap extends StatelessWidget {
  const DevicesWrap({super.key, String? roomId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('devices').snapshots(),
      builder: (context, snapshot) {
        // ✅ فحص حالة الاتصال
        bool isLoading = snapshot.connectionState == ConnectionState.waiting;
        bool hasData = snapshot.hasData && snapshot.data!.docs.isNotEmpty;

        // ✅ تخزين البيانات في متغيرات
        List<QueryDocumentSnapshot> devices =
            hasData ? snapshot.data!.docs : [];

        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!hasData) {
          return const Center(child: Text("لا توجد أجهزة متاحة"));
        }

        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: devices.map((device) {
            // ✅ استخراج اسم الجهاز في متغير
            String deviceName = device['name'];
            String deviceId = device.id; // استخراج معرّف الجهاز

            return CustomeSmallContiner(
              messageText: deviceName,
              deviceId: deviceId, // تمرير معرّف الجهاز هنا
            );
          }).toList(),
        );
      },
    );
  }
}
