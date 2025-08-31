import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:untitled1/add.dart';
import 'package:untitled1/note/addNote.dart';
import 'package:untitled1/note/editeNote.dart';


class viewNote extends StatefulWidget {
  final String CategoryId ;
  const viewNote({super.key, required this.CategoryId});//   اجباري التمرير  required

  @override
  State<viewNote> createState() => _viewNoteState();
}

class _viewNoteState extends State<viewNote> {

  List data=[];
  bool Isloading =true;

//---------------------------------------------------------------
  getdata ()async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('categories').
     doc(widget.CategoryId).collection('note').get();// معنها جيب من كولكشن category الdocument id و ال document فيه كولكشن هات ال DOCUMENTS  التي فيه



    //await Future.delayed(Duration(seconds: 2));// اعملي تاخير للداتا بمقدار ثانيتين
    data.addAll(querySnapshot.docs);
    Isloading =false;
    setState(() {
    });
  }
  //--------------------------------------------------------------
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
          onPressed: ()async{
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context)=>addnote(docid: widget.CategoryId)) );//عند الضغط على الزر ينقله الى صفحة ال addnote
            data.clear();
            Isloading = true;
            setState(() {});
            getdata();

          },child: Icon(Icons.add,color: Colors.white,),
        ),
        //--------------------------------------------------------------------------------
        appBar: AppBar(
          title: Text('viewNote'),
          backgroundColor: Colors.grey[200],
          actions: [
            IconButton(onPressed: (){
                Navigator.of(context).push(
               MaterialPageRoute(builder: (context)=>addnote(docid: widget.CategoryId)));

            }, icon: Icon(Icons.exit_to_app, size: 30.0,))
          ],
        ),
        body: Isloading == true ? Container(child: Center(child: CircularProgressIndicator())) :// هنا اذا ال loading قيمته true يعني لسا ما جاب الداتا اعرضيليCircularProgressIndicator واذا جاب الداتا اعرضها في  GridView.builder
        GridView.builder
          (gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisExtent: 160.0),
            itemCount: data.length,
            itemBuilder: (context,i){
              return InkWell(// نوع زر
               onTap: (){
                 Navigator.of(context).push(MaterialPageRoute(builder: (context)=>editenote(
                     notedocid: data[i].id,
                     categrydocid: widget.CategoryId,
                     oldnote: data[i]['note'])));
               },
                onLongPress:(){
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    animType: AnimType.rightSlide,
                    title: 'warning',
                    desc: ' Choose what you want',
                    // خيار الحذف
                    btnOkText: "Delete",
                    btnOkOnPress: () async{
                      await FirebaseFirestore.instance.
                      collection('categories')
                      .doc(widget.CategoryId).
                      collection('note')
                     .doc(data[i].id).
                      delete();
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=>viewNote(CategoryId: widget.CategoryId))

                      ); },
                    btnCancelText: "Cancel",
                    btnCancelOnPress: (){}


                  ).show();
                } ,
                child: Card(
                    color: Colors.white,
                    child:  Container(
                      padding: EdgeInsets.all(20.0),//عشان النص ما يطلع برا الcard
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('${data[i]['note']}',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),)

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
