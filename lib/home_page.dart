
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_database/database/user_table_provider.dart';
import 'package:flutter_database/user_detail.dart';

import 'database/user.dart';

class HomePage extends StatefulWidget {
  @override
  createState() => HomepageState();
}

class HomepageState extends State<HomePage> {
  UserDbProvider provider = UserDbProvider();
  List<User> userList;
  int count = 0;  //在为被初始化前item的数量为0

  @override
  Widget build(BuildContext context) {
    if (userList == null) {
      userList = List<User>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('sqflite'),
      ),
      body: getListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(User());
        },
        child:Icon(Icons.add),
      ),

    );
  }

  ListView getListView() {
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            color: Colors.white,
            elevation: 3.0,
            child: ListTile(
              leading: Text(position.toString()),
              title: Text(this.userList[position].name),
              subtitle: Text(this.userList[position].desc),
              trailing: GestureDetector(
                child: Icon(Icons.delete, color: Colors.red,),
                onTap: () {
                  _delete(context, userList[position]);
                },
              ),
              onTap: () {
                navigateToDetail(userList[position]);
              },
            ),
          );
        }
    );
  }

  //跳转到编辑添加数据页面
  void navigateToDetail(User user) async {
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) {
      return UserDetail(user);
    }));
    debugPrint("result:"+result.toString());
    if(result ==true){
      updateListView();
    }
  }

  //删除某条数据
  void _delete(BuildContext context, User user) async {
    var id = user.id;
    debugPrint("delete id :$id");
    int result = await provider.deleteUser(user.id);
    debugPrint("delete result :$result");
    if (result != 0) {
      updateListView(); //删除成功后更新列表
    }
  }


  void updateListView() {
    Future<List<User>> listUsersFuture = provider.getAllUser();
    listUsersFuture.then((userList) {
      setState(() {
        this.userList = userList;
        this.count = userList.length;
      });
    });
  }
}
