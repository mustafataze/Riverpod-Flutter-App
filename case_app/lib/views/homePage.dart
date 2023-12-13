import 'package:case_app/models/userModel.dart';
import 'package:case_app/controller/userController.dart';
import 'package:case_app/views/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final _data = ref.watch(userDataProvider);
    return Scaffold(backgroundColor: Colors.blue[50],
        body: _data.when(
            data: (_data) {
              List<UserModel> user = _data.map((e) => e).toList();
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Expanded(
                        child: ListView.builder(
                            itemCount: user.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 4,
                                margin: EdgeInsets.symmetric(vertical: 20),
                                child: ListTile(
                                  leading: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(user[index].avatar)),
                                  title: Text(user[index].firstname),
                                  subtitle: Text(user[index].lastname),
                                  trailing: Text(user[index].email),
                                ),
                              );
                            })),
                    OutlinedButton.icon(
                        onPressed: () async {
                          SharedPreferences pref =
                              await SharedPreferences.getInstance();
                          await pref.clear();
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                              (route) => false);
                        },
                        icon: Icon(Icons.login),
                        label: Text("Logout")),
                  ],
                ),
              );
            },
            error: ((error, stackTrace) => Text(error.toString())),
            loading: () => Center(
                  child: CircularProgressIndicator(),
                )));
  }
}
