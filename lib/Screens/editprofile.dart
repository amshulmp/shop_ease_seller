import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_ease_seller/config/configuration.dart';
import 'package:shop_ease_seller/widgets/reuabletextfield.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  Future <void> update(String id) async{
   
      
    
    await FirebaseFirestore.instance.collection("seller").doc(id).update({
    
    "companyname": companyController.text.trim(),
    "phone": phoneController.text.trim(),
    "adress": addressController.text.trim(),
    "description": descriptionController.text.trim(),
    "url": urlController.text.trim(),
  });
    }

  @override
  Widget build(BuildContext context) {
      final String documentId = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(
          "E D I T   P R O F I L E",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(MyConstants.screenHeight(context) * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            
            
              ReusableTextfield(
                  controller: phoneController,
                  isobscure: false,
                  inputtype: TextInputType.phone,
                  hint: "phone"),
              ReusableTextfield(
                  controller: addressController,
                  isobscure: false,
                  inputtype: TextInputType.phone,
                  hint: "adress"),
              ReusableTextfield(
                  controller: companyController,
                  isobscure: false,
                  inputtype: TextInputType.text,
                  hint: "company name"),
              ReusableTextfield(
                  controller: descriptionController,
                  isobscure: false,
                  inputtype: TextInputType.multiline,
                  hint: "description"),
              ReusableTextfield(
                  controller: urlController,
                  isobscure: false,
                  inputtype: TextInputType.url,
                  hint: "url"),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding:
                      EdgeInsets.all(MyConstants.screenHeight(context) * 0.01),
                  child: MaterialButton(
                      onPressed: () {
                        if (
                            phoneController.text == "" ||
                            addressController.text == "" ||
                            companyController.text == "" ||
                            descriptionController.text == "" ||
                            urlController.text == "") {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Container(
                                  color: Theme.of(context).colorScheme.secondary,
                                  child: const Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [Text("fill all fields")],
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                        
                          update(documentId);
                         Navigator.pop(context);
                        }
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              MyConstants.screenHeight(context) * 0.01)),
                      color: Theme.of(context).colorScheme.primary,
                      elevation: 10,
                      child: Text(
                        "save",
                        style: TextStyle(
                            fontSize: MyConstants.screenHeight(context) * 0.025),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
