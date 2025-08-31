import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/homepage.dart';
import 'package:untitled1/note/viewNote.dart';

class addnote extends StatefulWidget {
  final String docid ;
  const addnote({super.key, required this.docid});//عند استدعاء صفحة الaddnote لازم نمرر ال docid بشكل اجباري

  @override
  State<addnote> createState() => _addnoteState();
}

class _addnoteState extends State<addnote> {


  GlobalKey<FormState> formstate = GlobalKey<FormState>();// تعريف key
  TextEditingController note = TextEditingController(); // تعريف TextEditingController

  CollectionReference categories = FirebaseFirestore.instance.collection('categories');
  bool isloading = false;// تعريق متغير لل dialog

  Future<void> adddnote() async{
    if(formstate.currentState!.validate()){
      try{
        isloading = true; // عند الضغط على زر ال add  يعمل ال dialog
        setState(() {});// وهذه الدالة لازمه عشان يعمل تغيير على ال ui

        CollectionReference collectionNote = FirebaseFirestore.instance
            .collection('categories').
           doc(widget.docid).
            collection('note');// قم بالاضافة على كوكشن category بعدها ع الدكيومينت الي جواها بعدها الكولكش الي اسمها نوت
        DocumentReference reference = await collectionNote.add({'note': note.text });
       // هنا مخدناش ال id عشان جاي اصلا من الدوكيمنت اي دي



        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context)=>viewNote(CategoryId: widget.docid,)),(Route)=>false
        );// بعد اضافة النوت  يتم الانتقال الى صفحة ال viewNote
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
    note.dispose();//منعمل ايقاف لل TextEditingControler
    super.dispose();
  }





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
        title: Text('Add note '),
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
                controller: note,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: '   Enter your note',
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
                  adddnote();// استدعاء دالة الاضافه عند الضغط على الزر
                },
                child: Text('save note '),),
            )

          ],
        ),
      ),
    );
  }
}
