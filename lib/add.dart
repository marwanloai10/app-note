import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/homepage.dart';

class addcategory extends StatefulWidget {
  const addcategory({super.key});

  @override
  State<addcategory> createState() => _addcategoryState();
}

class _addcategoryState extends State<addcategory> {


GlobalKey<FormState> formstate = GlobalKey<FormState>();// تعريف key
TextEditingController categoryName = TextEditingController(); // تعريف TextEditingController
CollectionReference categories = FirebaseFirestore.instance.collection('categories');//  اسم ال collection المنشأة
bool isloading = false;// تعريق متغير لل dialog

 Future<void> adddcategory() async{
           if(formstate.currentState!.validate()){
             try{
               isloading = true; // عند الضغط على زر ال add  يعمل ال dialog
               setState(() {});// وهذه الدالة لازمه عشان يعمل تغيير على ال ui
               DocumentReference reference = await categories.add({'name': categoryName.text ,
                 'id': FirebaseAuth.instance.currentUser!.uid});
               // قم باضافة هذا الdocument على كولكشن ال category وخد مع الاضافة الid هي الخاص بالمستخدم حتى يعرف كل مستخدم الاشياء التي ضافها هو فقط و  والمعرف هذا خاص بكل مستخد وبشبه رقم الهوية



               Navigator.of(context).pushAndRemoveUntil(
                   MaterialPageRoute(builder: (context)=>Homepage()),(Route)=>false
               );// بعد الاضافة يتم الانتقال الى صفحة الhomepage
             }catch(e){
               isloading = false;
               setState(() {});
               //هنا في حال حدث خطا وما اضاف ما بدي ال dialog يضل شغال
               print("$e");
               AwesomeDialog(
                 context: context,
                 dialogType: DialogType.warning,
                 animType: AnimType.rightSlide,
                 title: 'warning',
                 desc: ' Error',// يطبع الخطأ الذي سوف يظهر ان لم تنجح عمليه الاضافة
                 btnCancelOnPress: () {},
                 btnOkOnPress: () {},
               ).show();
             }

           }}
    @override
 void dispose() {
categoryName.dispose();
  super.dispose();
}




                // هذه الدالة تقوم باضافه categry الى صفحة ال homwpage و تتم اضافتو على الفايربيس ومعمول للحقل validate

  //---------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){//زر عشان يرجعني ع صفحة الhomepage
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context)=>Homepage()));
          }, icon: Icon(Icons.arrow_back_sharp,color: Colors.blue,size: 30.0,))
        ],
        title: Text('Add category'),
      ),
      body: isloading ? Center(child: CircularProgressIndicator(),): Form(
        key: formstate,// عشان ال validate
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40.0,vertical: 20.0),
              width: 350.0,
              child: TextFormField(
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Cannot be empty';
                  }
                  return null;
                },
                controller: categoryName,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: '   Enter name category',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                ),
              ),
            ),

            Container(
              height: 50.0,
              width: 100.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.0)
              ),
              child: MaterialButton(color: Colors.blue
                ,onPressed: (){
                  print("===============================");
                  adddcategory();// استدعاء دالة الاضافه عند الضغط على الزر
                },
              child: Text('save '),),
            )

          ],
        ),
      ),
    );
  }
}
