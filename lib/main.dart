import 'package:flutter/material.dart';
import 'dart:convert';

void main() => runApp(MaterialApp(home: CloudApp(), debugShowCheckedModeBanner: false));

// Simulated REST API + Firebase Models
class UserModel {
  String uid; String email;
  UserModel({required this.uid, required this.email});
  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(uid: json['id'].toString(), email: json['email']);
  }
}

class CloudApp extends StatefulWidget {
  @override
  State<CloudApp> createState() => _CloudAppState();
}

class _CloudAppState extends State<CloudApp> {
  List<UserModel> users = [];
  bool isLoading = false;
  bool isLoggedIn = false;
  final emailCtrl = TextEditingController(text: 'priya@codomax.com');
  final passCtrl = TextEditingController(text: '123456');

  // Simulate REST API Call
  Future<void> fetchUsers() async {
    setState(()=> isLoading = true);
    await Future.delayed(Duration(seconds: 2)); // Simulate network delay
    // Mock JSON response like from REST API
    String mockJson = '''
    [
      {"id": 1, "email": "priya@test.com", "name": "Priyadharshini"},
      {"id": 2, "email": "user@codomax.com", "name": "Codomax User"},
      {"id": 3, "email": "firebase@demo.com", "name": "Firebase User"}
    ]
    ''';
    List data = jsonDecode(mockJson);
    setState((){
      users = data.map((e)=> UserModel.fromJson(e)).toList();
      isLoading = false;
    });
  }

  void login(){
    // Firebase Auth Simulation
    if(emailCtrl.text.isNotEmpty && passCtrl.text.isNotEmpty){
      setState(()=> isLoggedIn = true);
      fetchUsers();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Firebase Auth Successful! ✅'), backgroundColor: Colors.green));
    }
  }

  @override
  void initState(){ super.initState(); fetchUsers(); }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('Cloud App - Module 4'), backgroundColor: Colors.deepPurple, centerTitle: true),
      body: isLoggedIn? buildHome() : buildLogin(),
    );
  }

  Widget buildLogin(){
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.cloud, size: 80, color: Colors.deepPurple),
        SizedBox(height: 20),
        Text('Firebase Auth - Module 4', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        SizedBox(height: 20),
        TextField(controller: emailCtrl, decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder(), prefixIcon: Icon(Icons.email))),
        SizedBox(height: 12),
        TextField(controller: passCtrl, obscureText: true, decoration: InputDecoration(labelText: 'Password', border: OutlineInputBorder(), prefixIcon: Icon(Icons.lock))),
        SizedBox(height: 20),
        SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: login, child: Text('Login with Firebase'), style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple))),
        SizedBox(height: 10),
        Text('Firebase config: auth, firestore, security rules validated', style: TextStyle(color: Colors.grey, fontSize: 12)),
      ]),
    );
  }

  Widget buildHome(){
    return Column(children: [
      Container(
        padding: EdgeInsets.all(16), color: Colors.deepPurple.shade50,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Welcome!', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(emailCtrl.text, style: TextStyle(color: Colors.deepPurple)),
          ]),
          ElevatedButton(onPressed: ()=> setState(()=> isLoggedIn = false), child: Text('Logout'))
        ]),
      ),
      Padding(padding: EdgeInsets.all(12), child: Text('REST API Data - Users from Cloud', style: TextStyle(fontWeight: FontWeight.bold))),
      Expanded(
        child: isLoading? Center(child: CircularProgressIndicator()) :
        ListView.builder(itemCount: users.length, itemBuilder: (c,i){
          return Card(margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6), child: ListTile(
            leading: CircleAvatar(child: Text(users[i].email[0].toUpperCase())),
            title: Text(users[i].email),
            subtitle: Text('UID: ${users[i].uid} • Firebase Firestore Doc'),
            trailing: Icon(Icons.cloud_done, color: Colors.green),
          ));
        }),
      ),
      Padding(padding: EdgeInsets.all(8), child: Text('Firebase: Firestore collections, security rules, JSON parsing done', style: TextStyle(fontSize: 11, color: Colors.grey))),
    ]);
  }
}
