import 'package:flutter/material.dart';


class RefusePermissionPage extends StatelessWidget {

  const RefusePermissionPage({
    Key? key,
    this.color = const Color(0xFF2DBD3A),
    this.child,
  }) : super(key: key);

  final Color color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Center(child: Padding( padding: const EdgeInsets.all(30.0), child: Column(

        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text('This app needs contacts permissions in order to work',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 15),
          Text('Go to your phone\'s Settings -> Apps -> Adaship -> Permissions -> Contacts -> Allow',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
        ])));
  }
}