import 'dart:async'; // استيراد Timer
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/const.dart'; // تأكد من استيراد الثوابت الخاصة بك

class CustomeSmallContiner extends StatefulWidget {
  final String messageText;
  final String deviceId; // معرّف الجهاز لربط التحديث بالجهاز الصحيح

  const CustomeSmallContiner({
    super.key,
    required this.messageText,
    required this.deviceId,
  });

  @override
  State<CustomeSmallContiner> createState() => _CustomeSmallContinerState();
}

class _CustomeSmallContinerState extends State<CustomeSmallContiner> {
  bool isSwitched = false; // حالة مفتاح التشغيل
  StreamSubscription<DatabaseEvent>? _subscription;
  Timer? _timer; // مؤقت لتحديث الوقت
  int elapsedMinutes = 0; // عدد الدقائق منذ التشغيل
  int elapsedHours = 0; // عدد الساعات منذ التشغيل
  DateTime? startTime; // وقت بداية التشغيل

  @override
  void initState() {
    super.initState();
    _fetchDeviceState();
  }

  // ✅ جلب الحالة الأولية للجهاز
  void _fetchDeviceState() {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("devices/${widget.deviceId}");

    _subscription = ref.onValue.listen((event) {
      final data = event.snapshot.value;

      if (data != null && data is Map) {
        bool newState = data['isOn'] ?? false;

        if (mounted) {
          setState(() {
            isSwitched = newState;

            if (isSwitched) {
              // إذا تم تشغيل الجهاز، احسب المدة منذ وقت التشغيل المحفوظ
              startTime = DateTime.tryParse(data['startTime'] ?? "") ??
                  DateTime.now(); // وقت التشغيل المحفوظ
              _startTimer();
            } else {
              _stopTimer(); // عند إطفاء الجهاز، أوقف المؤقت
            }
          });
        }
      }
    }, onError: (error) {
      print("خطأ أثناء جلب البيانات: $error");
    });
  }

  // ✅ تحديث حالة الجهاز في Firebase
  Future<void> updateDeviceState(bool value) async {
    if (isSwitched == value) return;

    try {
      DatabaseReference ref =
          FirebaseDatabase.instance.ref("devices/${widget.deviceId}");
      await ref.update({
        'isOn': value,
        'startTime':
            value ? DateTime.now().toIso8601String() : null, // حفظ وقت التشغيل
      });

      if (mounted) {
        setState(() {
          isSwitched = value;
          if (isSwitched) {
            startTime = DateTime.now(); // حفظ وقت بداية التشغيل
            _startTimer(); // بدء العداد
          } else {
            _stopTimer(); // إيقاف العداد عند الإغلاق
          }
        });
      }
    } catch (e) {
      print("فشل في تحديث الحالة: $e");
    }
  }

  // ✅ بدء العداد التصاعدي عند تشغيل الجهاز
  void _startTimer() {
    if (_timer != null) _timer!.cancel(); // إيقاف أي عداد سابق

    // حساب الوقت المنقضي منذ تشغيل الجهاز
    if (startTime != null) {
      Duration elapsed = DateTime.now().difference(startTime!);
      elapsedMinutes = elapsed.inMinutes % 60;
      elapsedHours = elapsed.inHours;
    } else {
      elapsedMinutes = 0;
      elapsedHours = 0;
    }

    // تشغيل العداد كل دقيقة
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) {
        setState(() {
          elapsedMinutes++;
          if (elapsedMinutes >= 60) {
            elapsedMinutes = 0;
            elapsedHours++;
          }
        });
      }
    });
  }

  // ✅ إيقاف العداد عند إطفاء الجهاز
  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      elapsedMinutes = 0;
      elapsedHours = 0;
    });
  }

  @override
  void dispose() {
    _subscription?.cancel(); // إلغاء الاشتراك عند التخلص من الـ State
    _timer?.cancel(); // إيقاف العداد
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: klistappColor,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
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
                      "images/lamp.png",
                      fit: BoxFit.cover,
                      width: 60,
                      height: 60,
                    ),
                  ),

                  // ✅ مفتاح التبديل
                  Transform.scale(
                    scale: 0.9,
                    child: Switch(
                      value: isSwitched,
                      onChanged: (value) {
                        updateDeviceState(value);
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
                        widget.messageText,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 5),

                      // ✅ عرض حالة الجهاز
                      Text(
                        isSwitched
                            ? "Open | $elapsedHours H ${elapsedMinutes} Min"
                            : "Closed",
                        style: TextStyle(
                          color: isSwitched
                              ? const Color.fromARGB(128, 76, 175, 79)
                              : const Color.fromARGB(84, 244, 67, 54),
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
