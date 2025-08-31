import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:untitled1/add.dart';
import 'package:untitled1/note/viewNote.dart';

import 'auth/signup.dart';
import 'auth/login.dart';
import 'edite.dart';
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  List data=[];  // لغرض الاقسام فيها لتخزين الداتا التي في الفايرستور
  bool Isloading =true; // تعريف متغيير من نوع bool

//---------------------------------------------------------------
//  هذه الدالة تقوم بجلب الداتا من ال firestore وضروري نهمل setstate لانو بصير في تغيير على ال ui
  getdata ()async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('categories').
    where('id',isEqualTo: FirebaseAuth.instance.currentUser!.uid).get(); // تحديد الكولكشن الي بدنا نجيب منو الداتا  وهاي الداتا بترجع عهيئه اوبجكت انا بحطها في list وهات البيانات الخاصه بمعرف كل مستخدم



    //await Future.delayed(Duration(seconds: 2));// اعملي تاخير للداتا بمقدار ثانيتين
    data.addAll(querySnapshot.docs);
    Isloading =false; // يوضع قبل ال SetState عشان لما يخلص ال loding يصير التغيير على ال ui
    setState(() {
    });
  }
  //--------------------------------------------------------------
  // هذه الدالة تعمل عند فتح صفحة الصفحة مباشره ووضعنا فيها دالة جلب البيانات حتى يجلب البيانات اول ما تفتح الصفحة
  initState(){
    getdata();
    super.initState();
  }
  //------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: (){
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context)=>addcategory()),(Route)=>false
        );
      },child: Icon(Icons.add,color: Colors.white,),
      ),
      //هذا زر وظيفتو الانتقال الى صفحة ال addcategory
      //--------------------------------------------------------------------------------
      appBar: AppBar(
        title: Text('homepage'),
        backgroundColor: Colors.grey[200],
        actions: [
          IconButton(onPressed: ()async{
            //GoogleSignIn googleSignIn = GoogleSignIn(); // عشان لما اعمل تسجيل دخول باستخدام جوجل مرة تانيه يعرضلي قائمة بالبرد الاكترونية
            //googleSignIn.disconnect();// هاي الدالة معناها: افصل الحساب الحالي المرتبط بالتطبيق.
            // مش بس بتعمل sign out (تسجيل خروج)، كمان بتلغي الربط بين التطبيق وحساب Google، بحيث لو بدك تسجل دخول مرّة ثانية لازم المستخدم يختار حسابه من جديد ويعطي صلاحيات للتطبيق.
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context)=>Login()),(Route)=>false
            );

            await FirebaseAuth.instance.signOut();//   يقوم بعمل تسجيل خرووج ولكن يبقى الحساب موجود في الفايربيس وينقلة الى صفحة ال login

          }, icon: Icon(Icons.exit_to_app, size: 30.0,))
        ],
      ),
      body: Isloading == true ? Container(child: Center(child: CircularProgressIndicator())) :// هنا اذا ال loading قيمته true يعني لسا ما جاب الداتا اعرضيليCircularProgressIndicator واذا جاب الداتا اعرضها في  GridView.builder
      GridView.builder
        (gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisExtent: 160.0),
        itemCount: data.length,
        itemBuilder: (context,i){
          return InkWell(  // نوع زر
               onTap: (){// دالة تعمل عند الضغط على الزر
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                  viewNote(CategoryId: data[i].id,)));//الانتقال الى صفحة ال viewnote بعد الضغط على الnote
                },

                  onLongPress: (){// دالة تعمل عند الضغط المطول تظهر dialog يسألأك هل متأكد من عملية الحذف ؟
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.warning,
                      animType: AnimType.rightSlide,
                      title: 'warning',
                      desc: ' Choose what you want',
                      // خيار الحذف
                      btnCancelText: "Delete",
                      btnCancelOnPress: () async{
                        await FirebaseFirestore.instance.collection('categories').doc(data[i].id).delete();// نحدد الكولكشين التي بدنا نحذف منها وعند الحذ يلزمني معرف ال document وهو ال id وهو مهم جدا
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context)=>Homepage()),(Route)=>false
                          // بعد الحذف يقوم بالانتقال الى صفحة ال homepage
                        ); },
                      // خيار التعديل
                      btnOkText: "Update",
                      btnOkOnPress: () async {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context)=>editecategory(docid: data[i].id, aldName: data[i]['name'],)));//عند اختيار خيار تعديل انقلني على صفحة الupdate وهات معك الaldname ,ورقم ال doument

                      },
                    ).show();
                  },
            child: Card(
                color: Colors.white,
                child:  Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('images/folder.jpg',height: 100,),
                      Text('${data[i]['name']}',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),)

                    ],
                  ),
                )
            ),
          );
        }
      )
    );
  }
}
