import 'package:sqflite/sqflite.dart';
class DbHelper{
	static Database? _db;
	static final int _version = 1;
	static final String _tableName = "settings";
	static Future<void> initDb() async{
		if(_db !=null){
			return;
		}
		try{
			String _path = await getDatabasesPath()+"settings.db";
			_db = await openDatabase(
				_path,
				version: _version,
				onCreate: (db,version) async{
					var tableExists = await db.rawQuery(
						"SELECT name FROM sqlite_master WHERE type='table' AND name='$_tableName'");

					if (tableExists.isEmpty) {
						// Table doesn't exist, create it and insert initial data
						await db.execute(
							"CREATE TABLE $_tableName("
								"id INTEGER PRIMARY KEY AUTOINCREMENT, "
								"language TEXT, "
								"darkmode INTEGER, "
								"styletime TEXT)"
						);

						await db.insert(_tableName, {
							'language': 'Vie',
							'darkmode': 0,
							'styletime': '24h',
						});
					}
				}
			);
		}catch(e){
			print(e);
		}
	}

	static Future<void> updateSetting(String key, dynamic value) async {
		try {
			await _db!.update(
				_tableName,
				{key: value},
				where: 'id = ?',
				whereArgs: [1],
			);
		} catch (e) {
			print('Error updating setting: $e');
		}
	}
	static Future<Map<String, dynamic>?> getSettings() async {
		try {
			List<Map<String, dynamic>> maps = await _db!.query(_tableName);
			if (maps.isNotEmpty) {
				return maps.first;
			}
		} catch (e) {
			print('Error getting settings: $e');
		}
		return null;
	}


}