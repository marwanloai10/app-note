import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/homepage.dart';

class editecategory extends StatefulWidget {
  final  String aldName ;//تمريره ك constractor
  final String docid;//تمريره ك constractor
  const editecategory({super.key, required this.docid, required this.aldName});//      ا وبصير ال docid مطلوب و ال aldname مطلوب  كلمه required اما لو مش اجباري منرفع كلمة required

  @override
  State<editecategory> createState() => _editecategoryState();
}

class _editecategoryState extends State<editecategory> {


  GlobalKey<FormState> formstate = GlobalKey<FormState>();// تعريف key
  TextEditingController categoryName = TextEditingController(); // تعريف TextEditingController
  CollectionReference categories = FirebaseFirestore.instance.collection('categories');//  اسم ال collection المنشأة
  bool isloading = false;// تعريق متغير لل dialog

  Future<void> editeecategory() async{
    if(formstate.currentState!.validate()){
      try{
        isloading = true; // عند الضغط على زر ال add  يعمل ال dialog
        setState(() {});// وهذه الدالة لازمه عشان يعمل تغيير على ال ui
        await categories.doc(widget.docid).update({'name':categoryName.text});// هنا ما حطيناه بمتغير لان ال update لا ترجعقيمه يعني void
            //وهنا التعديل يكون بناءا على ال id الخاص ب ال document


        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context)=>Homepage()),(Route)=>false
        );
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
          desc: ' Error',// يطبع الخطأ الذي سوف يظهر ان لم تنجح عمليه التعديل
          btnCancelOnPress: () {},
          btnOkOnPress: () {},
        ).show();
      }

    }}
  @override
  void initState() {
    super.initState();
    categoryName.text= widget.aldName;// يعني القيمة الابتدائية للcategory هي القيمة القديمة تظهر اول ما تفتح صفحة الupdate
  }
  //----------------------------------------
   @override
  void dispose() {
     categoryName.dispose();
    super.dispose();
  }
// هذه الدالة تقوم بايقاف الTextEditingControler بتنظ الموارد وبتحرر الذاكرة
  //---------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                  editeecategory();//استدعاء دالة التعديل عند الضغط على الزر
                },
                child: Text('save'),),
            )

          ],
        ),
      ),
    );
  }
}
