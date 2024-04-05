
// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_ease_seller/config/configuration.dart';
import 'package:shop_ease_seller/config/routes.dart';
import 'package:shop_ease_seller/widgets/reuabletextfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  Future <void> requestAdmin( )async {
    Map<String,dynamic> sellermap={
      "email":emailcontroller.text.trim(),
       "password":passwordcontroller.text.trim(),
       "companyname":companynamecontroller.text.trim(),
       "phone":phonecontroller.text.trim(),
       "adress":adresscontroller.text.trim(),
       "description":businesssescriptioncontroller.text.trim(),
       "url":urlcontroller.text.trim(),
       "isapproved":false
    };
  if(
    sellermap["email"]==""||
     sellermap["password"]==""||
      sellermap["companyname"]==""||
       sellermap["phone"]==""||
        sellermap["adress"]==""||
         sellermap["description"]==""||
          sellermap["url"]==""||
          cpasswordcontroller.text.trim() ==""
  ){
     showDialog(context: context, builder: (BuildContext context) { 
        return AlertDialog(
          content: Container(
            color: Theme.of(context).colorScheme.secondary,
           child: const Column(
            mainAxisSize:MainAxisSize.min,
            children: [
              Text("fill all fields")
            ],
           ),
          ),
        );
       }, );
  }
  else
    {
    await FirebaseFirestore.instance.collection("adminrequests").add(sellermap);
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: emailcontroller.text.trim(), password: passwordcontroller.text.trim());
    await FirebaseFirestore.instance.collection("seller").add(sellermap);
  emailcontroller.clear();
  passwordcontroller.clear();
  cpasswordcontroller.clear();
  companynamecontroller.clear();
  phonecontroller.clear();
  adresscontroller.clear();
  businesssescriptioncontroller.clear();
  urlcontroller.clear();
  Navigator.pushNamed(context, Routes.login);
  }
  
  }
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController cpasswordcontroller = TextEditingController();
  TextEditingController companynamecontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController adresscontroller = TextEditingController();
  TextEditingController businesssescriptioncontroller = TextEditingController();
  TextEditingController urlcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
    appBar: AppBar(
      title: const Text("R E G I S T E R",
      style: TextStyle(fontWeight: FontWeight.bold),),
      backgroundColor: Theme.of(context).colorScheme.primary,
    ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.all(MyConstants.screenHeight(context)*0.01),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ReusableTextfield(
                      controller: emailcontroller,
                      isobscure: false,
                      inputtype: TextInputType.emailAddress,
                      hint: "email"),
                  ReusableTextfield(
                      controller: companynamecontroller,
                      isobscure: false,
                      inputtype: TextInputType.visiblePassword,
                      hint: "Company name"),
                  ReusableTextfield(
                      controller: phonecontroller,
                      isobscure: false,
                      inputtype: TextInputType.emailAddress,
                      hint: "phone number"),
                  ReusableTextfield(
                      controller: adresscontroller,
                      isobscure: false,
                      inputtype: TextInputType.visiblePassword,
                      hint: "adress"),
                   ReusableTextfield(
                      controller: businesssescriptioncontroller,
                      isobscure: false,
                      inputtype: TextInputType.emailAddress,
                      hint: "busines description"),
                  ReusableTextfield(
                      controller: urlcontroller,
                      isobscure: false,
                      inputtype: TextInputType.visiblePassword,
                      hint: "bussiness url(optional)"),   
                  ReusableTextfield(
                      controller: passwordcontroller,
                      isobscure: true,
                      inputtype: TextInputType.emailAddress,
                      hint: "password"),
                  ReusableTextfield(
                      controller: cpasswordcontroller,
                      isobscure: true,
                      inputtype: TextInputType.visiblePassword,
                      hint: "conform password"),
                  Padding(
                padding:
                    EdgeInsets.all(MyConstants.screenHeight(context) * 0.01),
                child: MaterialButton(
                    onPressed: requestAdmin,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            MyConstants.screenHeight(context) * 0.01)),
                    color: Theme.of(context).colorScheme.primary,
                    elevation: 10,
                    child: Text(
                      "Request",
                      style: TextStyle(
                          fontSize: MyConstants.screenHeight(context) * 0.025),
                    )),
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}