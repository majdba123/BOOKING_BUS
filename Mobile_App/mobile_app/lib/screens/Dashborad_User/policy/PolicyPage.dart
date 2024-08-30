import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';

class PolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'السياسات',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
      ),
      body: Stack(
        children: [
          Container(
            width: screenWidth,
            height: screenHeight,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/background_mappp.png",
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                textDirection: TextDirection.rtl,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionTitle('سياسات الحجز'),
                  PolicyExpansionTile(
                    title: '1. الأسعار والرسوم',
                    details: [
                      'يتضمن السعر الإجمالي جميع رسوم الضرائب الأساسية لحجز الباصات ولا يتضمن الرسوم للعفش الإضافي/الوزن الإضافي أو راكب غير مذكور في التذكرة.',
                      'يتعين عليك دفع إجمالي المبلغ المستحق كي يتم تأكيد الحجز قبل موعد 72 ساعة من موعد الحجز.',
                    ],
                  ),
                  PolicyExpansionTile(
                    title: '2. إلغاء الحجز',
                    details: [
                      'لن يتم استرجاع مبلغ الحجز في حالة التغيب عن رحلة السفر وعدم الإشعار قبل 48 ساعة من موعد الحجز.',
                      'لمعرفة إمكانية إلغاء الحجز خلال 48 ساعة المتبقية لموعد الرحلة يرجى التواصل عن طريق إدارة الحجز أو إرسال تذكرة دعم لمحاولة استرجاع رسوم الحجز.',
                    ],
                  ),
                  PolicyExpansionTile(
                    title: '3. تفاصيل الحجز',
                    details: [
                      'يمكنك الحجز من أي مكان في العالم ولكن انطلاق الرحلة سوف يكون من المدينة المخصصة التي تم اختيارها وإلى الوجهة المباشرة أو غير المباشرة للحجز.',
                      'تأكد من استخدام جواز السفر ساري المفعول لمدة 6 أشهر على الأقل قبل تاريخ المغادرة، تأشيرة الدخول صحيحة، تأشيرة الخروج والعودة وجميع الأوراق القانونية.',
                      'يجب أن يكون الرضيع برفقة مسافر بالغ لا يقل عمره عن 18 سنة على الأقل.',
                    ],
                  ),
                  SizedBox(height: 20),
                  SectionTitle('سياسات الإلغاء'),
                  PolicyExpansionTile(
                    title: '1. إجراءات الإلغاء',
                    details: [
                      'سوف يتم إلغاء الحجز في حال طلب إلغاء الحجز أثناء المدة المسموحة أو تعديل على الرحلة.',
                      'الإلغاء عبر التطبيق يخضع لسياسات شركة الباصات وتطبيق مُرتحل.',
                      'غير مسؤولين قانونياً عن القبول بأي طلبات إلغاء يتم إجراؤها عبر أي وسائط أخرى خارج التطبيق.',
                    ],
                  ),
                  SizedBox(height: 20),
                  SectionTitle('سياسات الاسترجاع'),
                  PolicyExpansionTile(
                    title: '1. إجراءات الاسترجاع',
                    details: [
                      'سوف يتم استرجاع أو دفع رسوم الحجز في حالة تغير المواعيد وسعر التذكرة الجديدة أقل أو أكثر من سعر التذكرة السابق.',
                      'بعض الحجوزات غير قابلة للاسترداد وذلك تبعاً للسياسات الخاصة بشركات النقل.',
                    ],
                  ),
                  PolicyExpansionTile(
                    title: '2. التعامل مع الاسترجاع',
                    details: [
                      'يتم استرداد مبالغ الحجز عن طريق شركات الباصات بشكل مباشر إلى الركاب وليس عن طريق تطبيق مُرتحل.',
                      'ينبغي عليك التواصل مع فريق تطبيق مٌرتحل لتأكيد عملية استرداد قيمة الحجز.',
                    ],
                  ),
                  SizedBox(height: 20),
                  SectionTitle('سياسات التعديل'),
                  PolicyExpansionTile(
                    title: '1. إجراء التعديلات',
                    details: [
                      'بإمكانك إجراء أي تعديلات على حجز رحلتك بحسب المواعيد والجداول المتوفرة في تطبيق مُرتحل.',
                      'يجب دفع رسوم الفارق بين سعر التذكرة الجديد أو القديم ليتم عملية التعديل على الحجز أثناء الفترة المسموح بتعديل الحجز فيها.',
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        textDirection: TextDirection.rtl,
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}

class PolicyExpansionTile extends StatelessWidget {
  final String title;
  final List<String> details;

  PolicyExpansionTile({required this.title, required this.details});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        textDirection: TextDirection.rtl,
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      children: details.map((detail) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Text(
            detail,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        );
      }).toList(),
    );
  }
}
