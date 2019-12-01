import 'package:sqflite/sqlite_api.dart';

import 'package:flutter_database/database/base_provider.dart';
import 'package:flutter_database/database/user.dart';

class UserDbProvider extends BaseDbProvider {
  ///表名
  final String name = 'UserInfo';

  final String columnId = "id";
  final String columnName = "name";
  final String columnDesc = "desc";

  UserDbProvider();

  //获取表名称
  @override
  tableName() {
    return name;
  }

  //创建表操作
  @override
  createTableString() {
    return '''
        create table $name (
        $columnId integer primary key,$columnName text not null,
        $columnDesc text not null)
      ''';
  }

  ///查询数据
  Future selectUser(int id) async {
    Database db = await getDataBase();
    return await db.rawQuery("select * from $name where $columnId = $id");
  }

  //查询数据库所有
  Future<List<Map<String, dynamic>>> selectMapList() async {
    var db = await getDataBase();
    var result = await db.query(name);
    return result;
  }

  //获取数据库里所有user
  Future<List<User>> getAllUser() async{
    var userMapList = await selectMapList();
    var count  = userMapList.length;
    List<User> userList= List<User>();

    for(int i=0;i<count;i++){
      userList.add(User.fromMapObject(userMapList[i]));
    }
    return userList;
  }

  //根据id查询user
  Future<User> getUser(int id) async {
    var noteMapList = await selectUser(id); // Get 'Map List' from database
    var user = User.fromMapObject(noteMapList[id]);
    return user;
  }

  //增加数据
  Future<int> insertUser(User user) async {
    var db = await getDataBase();
    var result = await db.insert(name, user.toMap());
    return result;
  }

  //更新数据
  Future<int> update(User user) async {
    var database = await getDataBase();
    var result = await database.rawUpdate(
        "update $name set $columnName = ?,$columnDesc = ? where $columnId= ?",
        [user.name, user.desc, user.id]);
    return result;
  }

  //删除数据
  Future<int> deleteUser(int id) async {
    var db = await getDataBase();
    var result = await db.rawDelete('DELETE FROM $name WHERE $columnId = $id');
    return result;
  }
}
