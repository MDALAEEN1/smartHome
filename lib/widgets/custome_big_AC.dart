import 'package:flutter/material.dart';
import 'package:smart_home/const.dart';
import 'package:smart_home/widgets/custome_icon.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class CustomeBigContiner extends StatefulWidget {
  final String massageText;
  final String deviceId;
  const CustomeBigContiner({
    super.key,
    required this.massageText,
    required this.deviceId,
  });

  @override
  State<CustomeBigContiner> createState() => _CustomeBigContinerState();
}

class _CustomeBigContinerState extends State<CustomeBigContiner> {
  bool isSwitched = false; // تعريف متغير لتتبع حالة التبديل
  double _value = 40.0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        width: 400,
        height: 200,
        decoration: BoxDecoration(
            color: kAppColor,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ] // الحواف الدائرية
            ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // الجزء الأيسر مع النصوص
                Expanded(
                  flex: 7,
                  // الصورة تأخذ جزءًا أقل
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(20), // تحديد الحواف الدائرية
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        "images/air-conditioner.png",
                        fit: BoxFit.cover, // ضبط الصورة لتتناسب مع الحاوية
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                Expanded(
                  flex: 22,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      children: [
                        CustomIcon(
                          iconPic: "images/sun.png",
                        ),
                        CustomIcon(
                          iconPic: "images/snowflake.png",
                        ),
                        CustomIcon(
                          iconPic: "images/drop.png",
                        ),
                        CustomIcon(
                          iconPic: "images/wind-sign.png",
                        ),
                        Transform.scale(
                          scale: 0.8,
                          child: Switch(
                            value: isSwitched,
                            onChanged: (value) {
                              setState(() {
                                isSwitched = value;
                              });
                            },
                            activeColor:
                                Colors.green, // لون الدائرة عند التفعيل
                            activeTrackColor: Colors
                                .lightGreenAccent, // لون المسار عند التفعيل
                            inactiveThumbColor:
                                Colors.grey, // لون الدائرة عند الإيقاف
                            inactiveTrackColor:
                                Colors.grey.shade300, // لون المسار عند الإيقاف
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // الصورة على اليمين
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.massageText,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 70,
                          ),
                          SfSlider(
                            activeColor: kBackgroundColor,
                            min: 0.0,
                            max: 100.0,
                            value: _value,
                            interval: 20,
                            showTicks: true,
                            showLabels: true,
                            enableTooltip: true,
                            minorTicksPerInterval: 1,
                            onChanged: (dynamic value) {
                              setState(() {
                                _value = value;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        "open | 1H 30Min",
                        style: TextStyle(
                          color: Colors.black26,
                          fontSize: 17,
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
