import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../homepage.dart';
import 'signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isloading = false;



  //  التسجيل بواسطة google
  // Future signInWithGoogle() async {
  //   // Trigger the authentication flow
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //  if(googleUser==null){// في حال اي شي رجح null  ما يعملي مشاكل وما بنتقل للدوال الي بعدها (خلص بقف)
  //  return;
  //  }
  //
  //   // Obtain the auth details from the request
  //   final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
  //
  //   // Create a new credential
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );
  //
  //   // Once signed in, return the UserCredential
  //   return await FirebaseAuth.instance.signInWithCredential(credential);
  // Navigator.of(context).pushAndRemoveUntil(
  //             MaterialPageRoute(builder: (context)=>homepage()),(Route)=>false
  //         );
  //
  //
  // }








  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: isloading ? Center(child: CircularProgressIndicator(),) :// اذا ترو يعني لسا ما في داتا اذا اعرض ال loading واذا اجت الداتا اعرذ محتويات الصفحة التي في ال body
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              SizedBox(height: 70),
              Container(height: 80, child: Image.asset('images/nnote.png')),
              SizedBox(height: 25),
              Text('Login',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Text('Login to continue using the app',
                  style: TextStyle(fontSize: 13, color: Colors.grey)),
              SizedBox(height: 15),
              Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              TextFormField(
                controller: email,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Cannot be empty';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: 'Enter your Email',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              SizedBox(height: 10),
              Text('Password', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              TextFormField(
                controller: password,
                obscureText: true,
                validator: (val) {
                  if (val == null|| val.trim().isEmpty ) {//  اذا الحقل فاضي ويمسك الفراغات
                    return 'Cannot be empty';
                  }
                  return null;//ترجع null ⇒ الفحص ناجح وما في خطأ.
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: 'Enter your Password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.remove_red_eye_outlined),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () async {
                      if(email.text == ''){
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.info,
                          animType: AnimType.rightSlide,
                          title: 'warning',
                          desc: 'please, enter your email.',
                          btnCancelOnPress: () {},
                          btnOkOnPress: () {},
                        ).show();
                        return;// اذا ما في ايميل قم بايقاف الدالة التي تعمل عند الضغط على زر forget password و اظهار dialog يامر بادخال بريدك الالكتروني
                      }
                      try{
                        await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);//يقوم باعادة تعيين كلمة المرور بس لازم يكون الايميل موجود عشان نرسله رسالة التحقق ويظهر dialog انو تفحص ايميلك
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.success,
                          animType: AnimType.rightSlide,
                          title: 'warning',
                          desc: 'check your email to reset password .',
                          btnCancelOnPress: () {},
                          btnOkOnPress: () {},
                        ).show();
                      }catch(e){
                             print(e);
                             AwesomeDialog(
                               context: context,
                               dialogType: DialogType.info,
                               animType: AnimType.rightSlide,
                               title: 'warning',
                               desc: ' Please, check your email..',// هنا في حالة دخل بريد الكتروني خاطئ يظهر ديالوج يامرة بالتاكد من بريدة الالكتروني
                               btnCancelOnPress: () {},
                               btnOkOnPress: () {},
                             ).show();
                      }

                    },
                    child:
                    Text('Forgot Password?', style: TextStyle(fontSize: 12))),
              ),
              Container(
                height: 53,
                decoration: BoxDecoration(
                    color: Color(0xFF4e95f4),
                    borderRadius: BorderRadius.circular(20)),
                child: MaterialButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {//اذا ضغطت على الزر وانت مش حاطط اشي بالحقول بقلك انهم فاضيين
                        try {
                      isloading = true;// ال loading شغال لانو لسا ما جاب داتا ونحتاج دالة setstate لوجود تغير على ال ui
                      setState(() {});
                      final credential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(// هذه الدالة بتعمل تسجيل دخول ما عملت ريجستر وبيطلب كلمة المرور والايميل
                          email: email.text.trim(), // من ال text filed
                          password: password.text.trim());// من ال text filed

                          isloading = false;// ال loading شغال لانو لسا ما جاب داتا ونحتاج دالة setstate لوجود تغير على ال ui
                          setState(() {});

                         if(credential.user!.emailVerified){//  ال credintial بتخزن الايميل والباسورد وهنا المستخدم وصله الايميل وتحقق انقله على صفحة ال HOMEPAGE
                           Navigator.of(context).pushReplacement(
                               MaterialPageRoute(
                                   builder: (context) => Homepage()));// في حال الامور تمام وعمل login انقله على صفحة الhomepage
                         }else{
                           FirebaseAuth.instance.currentUser?.sendEmailVerification();// في حال ادخل الusername و ال password ابعتلي ايميل تحقق
                           AwesomeDialog(
                             context: context,
                             dialogType: DialogType.success,
                             animType: AnimType.rightSlide,
                             title: 'Error',
                             desc: 'please verified your email.',// dialog يظهر بعد ارسال الايميل
                             btnOkOnPress: () {},
                           ).show();

                         }
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            isloading = false;// في حال حدوث اي خطأ يطفي ال dialog وملزقة فيه دايما دالة الsetstate
                            setState(() {});
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: 'Error',
                              desc: 'No user found for that email.',
                              btnOkOnPress: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) => Login()),
                                );
                              },
                            ).show();
                          } else if (e.code == 'wrong-password') {
                            isloading = false;// في حال حدوث اي خطأ يطفي ال dialog وملزقة فيه دايما دالة الsetstate
                            setState(() {});

                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: 'Error',
                              desc: 'Wrong password provided for that user.',
                              btnOkOnPress: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) => Login()),
                                );
                              },
                            ).show();
                          } else {
                            // ✅ أي خطأ غير متوقع
                            isloading = false;// في حال حدوث اي خطأ يطفي ال dialog وملزقة فيه دايما دالة الsetstate
                            setState(() {});
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: 'Error',
                              desc: 'Not valid ',
                              btnOkOnPress: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) => Login()),
                                );
                              },
                            ).show();
                          }
                        }
                      }
                    },
                    child:
                    Text('Login', style: TextStyle(color: Colors.white))),
              ),
              SizedBox(height: 20),
              Center(
                  child: Text(
                      '_________________  Or Login with  _________________',
                      style: TextStyle(color: Colors.grey, fontSize: 12))),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // التسجيل في ال facebook
                  MaterialButton(
                    onPressed: () {},
                    child: Container(
                      alignment: Alignment.center,
                      height: 70,
                      width: 82,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.grey)),
                      child: Icon(Icons.facebook, color: Colors.blue, size: 50),
                    ),
                  ),
                  //التسجيل في google
                  MaterialButton(
                    onPressed: () {
                     print('-------------------------------');
                     //signInWithGoogle();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 70,
                      width: 82,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.grey)),
                      child: Icon(Icons.g_mobiledata,
                          color: Colors.orange, size: 50),
                    ),
                  ),
                  // التسجيل ب apple
                  MaterialButton(
                    onPressed: () {},
                    child: Container(
                      alignment: Alignment.center,
                      height: 70,
                      width: 82,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.grey)),
                      child: Icon(Icons.apple, color: Colors.black, size: 50),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Don\'t have an account?',
                      style: TextStyle(fontSize: 15)),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => signin()));
                    },
                    child: Text('Register',
                        style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF4e95f4),
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
