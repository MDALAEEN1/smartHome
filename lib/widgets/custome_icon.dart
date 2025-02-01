import 'package:flutter/material.dart';
import 'package:smart_home/const.dart';

class CustomIcon extends StatelessWidget {
  const CustomIcon({
    Key? key,
    required this.iconPic, // الأيقونة
    this.iconText, // النص اختياري
    this.onTap,
    this.background, // اللون الخلفي اختياري
  }) : super(key: key);

  final String iconPic;
  final String? iconText; // النص اختياري
  final VoidCallback? onTap;
  final Color? background; // لون الخلفية اختياري

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: kBackgroundColor,
      highlightColor: kBackgroundColor,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // تحديد الحجم المناسب بناءً على المحتوى
          children: [
            Container(
              height: 40,
              padding: const EdgeInsets.all(8), // مساحة داخلية حول الأيقونة
              decoration: BoxDecoration(
                color: background ??
                    kAppColor, // استخدام اللون المحدد أو الافتراضي
                borderRadius: BorderRadius.circular(10), // حواف دائرية
              ),
              child: Container(
                height: 10,
                child: Image.asset(
                  iconPic,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.error,
                        color:
                            Colors.red); // أيقونة خطأ عند عدم العثور على الصورة
                  },
                ),
              ),
            ),
            if (iconText != null) // إذا كان هناك نص، يظهره
              const SizedBox(height: 4), // مسافة بين الأيقونة والنص
            Text(
              iconText ??
                  '', // عرض النص إذا كان موجودًا، وإذا لم يكن يظهر نص فارغ
              style: const TextStyle(
                color: Colors.black26, // لون النص
                fontWeight: FontWeight.bold, // سماكة النص
              ),
            ),
          ],
        ),
      ),
    );
  }
}
