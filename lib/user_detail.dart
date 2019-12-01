import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_database/database/user_table_provider.dart';

import 'database/user.dart';

class UserDetail extends StatefulWidget {
  final User user;
  UserDetail(this.user);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UserDetailState(user);
  }
}

class UserDetailState extends State<UserDetail> {
  UserDbProvider provider = UserDbProvider();
  User user;

  UserDetailState(this.user);

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    nameController.text = user.name;
    descriptionController.text = user.desc;

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('User detail'),
      ),
      body: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          new Container(
            padding: const EdgeInsets.all(20),
            child: new TextField(
                controller: nameController,
                decoration: new InputDecoration(helperText: "请输入名字"),
                onChanged:(value){
                  updateName();  // 更新userName
                } ),
          ),
          new Container(
            padding: const EdgeInsets.all(20),
            child: TextField(
                controller: descriptionController,
                onChanged: (value){
                  updateDescription();
                },
                decoration: new InputDecoration(helperText: "请描述")),
          ) ,
          
          new Container(
            padding: const EdgeInsets.all(10),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: RaisedButton(
                    color: Theme.of(context).primaryColorDark,
                    textColor: Theme.of(context).primaryColorLight,
                    child: Text(
                      '删除',
                    ),
                    onPressed: () {
                      setState(() {
                        _delete();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RaisedButton(
                    color: Theme.of(context).primaryColorDark,
                    textColor: Theme.of(context).primaryColorLight,
                    child: Text(
                      '保存',
                    ),
                    onPressed: () {
                      setState(() {
                        _save();
                      });
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // Update the title of Note object
  void updateName() {
    user.name = nameController.text;
  }

  // Update the description of Note object
  void updateDescription() {
    user.desc = descriptionController.text;
  }

  void _delete() async {
    moveToLastScreen();

    if (user.id == null) {
      _showAlertDialog('没有用户可被删除');
      return;
    }

    int result = await provider.deleteUser(user.id);
    if (result != 0) {
      _showAlertDialog("删除成功");
    } else {
      _showAlertDialog('错误');
    }
  }

  void _save() async {

    int result;
    if (user.id == null) {
      user.id = new DateTime.now().millisecondsSinceEpoch;  //id 为当前时间戳
      result = await provider.insertUser(user);
    } else {
      result = await provider.update(user);
    }

    moveToLastScreen();

    int t = user.id;
    String n = user.name;
    String d = user.desc;
    debugPrint("t:$t n:$n d:$d");
    debugPrint("result: $result");
    if (result != 0) {
      _showAlertDialog("保存成功");
    } else {
      _showAlertDialog("保存失败");
    }


  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void _showAlertDialog(String message) {
    AlertDialog alertDialog = AlertDialog(
      // title: Text(tittle),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
