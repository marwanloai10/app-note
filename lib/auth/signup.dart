import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/homepage.dart';
import 'login.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class signin extends StatefulWidget {
  const signin({super.key});

  @override
  State<signin> createState() => _signinState();
}

class _signinState extends State<signin> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: Form(
          key: formstate,
          child: ListView(
            children: [
              Column(
                children: [
                  SizedBox(height: 70.0),
                  Container(
                    height: 80,
                    child: Image.asset('images/nnote.png'),
                  ),
                ],
              ),
              SizedBox(height: 25.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Register',
                    style:
                    TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    'Enter Your Personal Information',
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 13.0,
                        color: Colors.grey),
                  ),
                  SizedBox(height: 15.0),
                  Text(
                    'Username',
                    style:
                    TextStyle(fontSize: 17.5, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5.0),
                  TextFormField(
                    validator: (value) {
                      if (value == "") {
                        return ("can not to be Empty");
                      }
                      return null;
                    },
                    controller: username,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      hintText: '   Enter your name',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Email',
                    style:
                    TextStyle(fontSize: 17.5, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5.0),
                  TextFormField(
                    validator: (value) {
                      if (value == "") {
                        return ("can not to be Empty");
                      }
                      return null;
                    },
                    controller: email,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      hintText: '   Enter your email',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Password',
                    style:
                    TextStyle(fontSize: 17.5, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5.0),
                  TextFormField(
                    validator: (value) {
                      if (value == "") {
                        return ("can not to be Empty");
                      }
                      return null;
                    },
                    controller: password,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        padding: EdgeInsets.only(right: 10),
                        onPressed: () {},
                        icon: Icon(
                          Icons.remove_red_eye_outlined,
                          size: 20.0,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      hintText: '   Enter Password',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Container(
                    width: 400,
                    height: 55,
                    decoration: BoxDecoration(
                      color: Color(0xFF4e95f4),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: MaterialButton(
                      onPressed: () async {
                        if (formstate.currentState!.validate()) {
                          try {
                            final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(//هذه الدالة بترجه UserCredintional يخزن في CREDENTIOANAL
                              email: email.text,// تاخد الايميل من ال TEXT FILED
                              password: password.text,// تاخد الباسورد من ال TEXT FILED
                            );
                             await FirebaseAuth.instance.currentUser?.sendEmailVerification();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context)=>Login()),(Route)=>false );// في حال ادخل والامور تمام ينقله على صفحةا ال LOGIN
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              print('The password provided is too weak.');
                              AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.rightSlide,
                                  title: 'warning',
                                  desc: 'The password provided is too weak.',
                                  btnCancelOnPress: () {},
                                 btnOkOnPress: () {},
                                ).show();// في حال ادخل المستخدم كلمة مرور ضيفه يظهر هذا الDialog
                             } else if (e.code == 'email-already-in-use') {
                              print('The account already exists for that email.');
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'warning',
                                desc: 'The account already exists for that email.',
                                btnCancelOnPress: () {},
                                btnOkOnPress: () {},
                              ).show();// في حال كان الحساب المدخل موجود يظهر dialog بان الحساب موجد
                            }
                          } catch (e) {
                            print(e);// في حال وجود خطأ اخر يطبعه
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: 'warning',
                              desc: '$e',
                              btnCancelOnPress: () {},
                              btnOkOnPress: () {},
                            ).show();
                          }
                        }
                        },child: Text('Register', style: TextStyle(color: Colors.white), ),
                    ),

                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Have an account?',
                        style: TextStyle(fontSize: 15),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => Login()));
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF4e95f4),
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
