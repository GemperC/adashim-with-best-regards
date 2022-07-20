import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:adashim/pages/refuse_permissions.dart';

void main() => runApp(MainPage());

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Contact>? _contacts;
  List<Contact> _contactsFiltered = [];
  bool _permissionDenied = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchContacts();
    searchController.addListener(() {filterContacts();});
  }

  Future _fetchContacts() async {
    if (!await FlutterContacts.requestPermission()) {
      setState(() => _permissionDenied = true);
    } else {
      final contacts = await FlutterContacts.getContacts(withPhoto: true);
      setState(() => _contacts = contacts);
    }
  }

  filterContacts(){
    List<Contact> __contacts = [];
    __contacts.addAll(_contacts!);
    if (searchController.text.isNotEmpty){
      __contacts.retainWhere((contact) {
        String searchTerm = searchController.text.toLowerCase();
        String contactName = contact.displayName.toLowerCase();
        return contactName.contains(searchTerm);
      });

      setState((){
        _contactsFiltered = __contacts;
      });
    }
    else {
      setState((){
        _contactsFiltered = __contacts;
      });
    }


  }


  @override
  Widget build(BuildContext context) => MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: const Center( child:  Text('Adashim'))),
          body:Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
              child:Column(children: [
                Container(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                        labelText: "Search Contact",
                        border: OutlineInputBorder( borderSide: BorderSide( color: Theme.of(context).primaryColor)),
                        prefixIcon: Icon( Icons.search, color: Theme.of(context).primaryColor,)
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Expanded(child: _contactsList()) ,
              ],))));

  Widget _contactsList() {
    bool isSearching = searchController.text.isNotEmpty;
    if (_permissionDenied) return const RefusePermissionPage();
    if (_contacts == null) return const Center(child: CircularProgressIndicator());

    return ListView.builder(
      shrinkWrap: true,
        itemCount: isSearching == true ? _contactsFiltered.length : _contacts!.length,
        itemBuilder: (context, i) {
        Contact contact = isSearching == true ? _contactsFiltered[i] : _contacts![i];
          Uint8List? image =  isSearching == true ? _contactsFiltered[i].photo : _contacts![i].photo;
          return Row(children: [
                  Expanded(child: ListTile(
                      leading: (image == null)? const CircleAvatar(child: Icon(Icons.person),):CircleAvatar(
                          backgroundImage: MemoryImage(image)),
                      title: Text(contact.displayName),

                      onTap: () async {
                        final fullContact =
                        await FlutterContacts.getContact(_contacts![i].id);
                        await Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => ContactPage(fullContact!)));
                      }),

                  )
              ])
              ;});
  }
}

class ContactPage extends StatelessWidget {
  final Contact contact;
  ContactPage(this.contact);

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(contact.displayName)),
      body: Column(children: [
        Text('First name: ${contact.name.first}'),
        Text('Last name: ${contact.name.last}'),
        Text(
            'Phone number: ${contact.phones.isNotEmpty ? contact.phones.first.number : '(none)'}'),
        Text(
            'Email address: ${contact.emails.isNotEmpty ? contact.emails.first.address : '(none)'}'),
      ]));
}