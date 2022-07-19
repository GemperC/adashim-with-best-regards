import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adashim',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Adashim'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    checkPermission_contacts();
    getAllContacts();

  }

  getAllContacts() async {
    List<Contact> _contacts = await ContactsService.getContacts();
    setState(() {
      contacts = _contacts;
    });
  }

  checkPermission_contacts() async {
    var contactStatus = await Permission.contacts.status;

    if (!contactStatus.isGranted){
      await Permission.contacts.request();}
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text("My Contacts"),
            ListView.builder(
              shrinkWrap: true,
              itemCount: contacts.length,
              itemBuilder: (context, index){
                Contact contact = contacts[index];
                return ListTile(
                  title: Text(contact.displayName.toString()),
                  subtitle: Text(
                      (contact.phones?.elementAt(0).value).toString()
                  ),
                );
              },
            )
          ],
        ),
      )
    );
  }
}


