import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? _sharedPreferences;

enum SharedPreferenceIOType { STRING, INTEGER, BOOL, DOUBLE, LIST }

getData(String _key, SharedPreferenceIOType type) async {
  _sharedPreferences = await SharedPreferences.getInstance();
  /*if (type == SharedPreferenceIOType.STRING) {
    return _sharedPreferences.getString(_key) ?? '';
  }*/
  if (type == SharedPreferenceIOType.STRING) {
    try {
      if (_sharedPreferences?.getString(_key) == null ||
          _sharedPreferences?.getString(_key) == "") {
        return _sharedPreferences?.getString(_key) ?? '';
      } else {
        String? keyData = _sharedPreferences?.getString(_key);
        return keyData;

        /// Comment By Manasa
        /*if (keyData != null) {
          //return await DataEncryption.decryptTextData(keyData);------- Comment by Manasa
          //return await DataEncryption.decryptTextData(keyData);
        }
        else {
          // Handle the case when keyData is null
          return null; // or throw an exception, or return a default value
        }*/

        // return await DataEncryption.decryptTextData(keyData!);
        //  return await MyEncryptionDecryption.decryptAES(_sharedPreferences?.getString(_key));
      }
    } on Exception catch (e) {
      return _sharedPreferences?.getString(_key) ?? '';
    }
  } else if (type == SharedPreferenceIOType.INTEGER) {
    return _sharedPreferences?.getInt(_key) ?? -1;
  } else if (type == SharedPreferenceIOType.BOOL) {
    return _sharedPreferences?.getBool(_key) ?? false;
  } else if (type == SharedPreferenceIOType.DOUBLE) {
    return _sharedPreferences?.getDouble(_key) ?? 0.0;
  }
}

saveData(String _key, _value, type) async {
  _sharedPreferences = await SharedPreferences.getInstance();
  /*if (type == SharedPreferenceIOType.STRING) {
    try {
      await _sharedPreferences.setString(_key, _value);
    } catch (e) {
      print('INVALID DATA TYPE :: ${_key}');
    }
  }*/

  if (type == SharedPreferenceIOType.STRING) {
    if (_value == null || _value == "") {
      await _sharedPreferences?.setString(_key, "");
    } else {
      try {
        //await _sharedPreferences?.setString(_key, DataEncryption.encryptTextData(_value));-----  Comment By Manasa
        await _sharedPreferences?.setString(_key, _value);
        // await _sharedPreferences?.setString(_key, MyEncryptionDecryption.encryptAES(_value));
      } catch (e) {
        print('INVALID DATA TYPE :: ${_key}');
        await _sharedPreferences?.setString(_key, _value);
      }
    }
  } else if (type == SharedPreferenceIOType.INTEGER) {
    try {
      await _sharedPreferences?.setInt(_key, _value ?? -1);
    } catch (e) {
      print('INVALID DATA TYPE :: ${_key}');
    }
  } else if (type == SharedPreferenceIOType.BOOL) {
    try {
      await _sharedPreferences?.setBool(_key, _value ?? false);
    } catch (e) {
      print('INVALID DATA TYPE :: ${_key}');
    }
  } else if (type == SharedPreferenceIOType.DOUBLE) {
    try {
      await _sharedPreferences?.setDouble(_key, _value ?? 0.0);
    } catch (e) {
      print('INVALID DATA TYPE :: ${_key}');
    }
  }
}

SPInfo sp = SPInfo();

class SPInfo {
  SharedPreferences? _sharedPreferences;

  getData(String key, SharedPreferenceIOType type) async {
    _sharedPreferences = await SharedPreferences.getInstance();

    if (type == SharedPreferenceIOType.STRING) {
      return _sharedPreferences?.getString(key) ?? '';
    } else if (type == SharedPreferenceIOType.INTEGER) {
      return _sharedPreferences?.getInt(key) ?? -1;
    } else if (type == SharedPreferenceIOType.BOOL) {
      return _sharedPreferences?.getBool(key) ?? false;
    } else if (type == SharedPreferenceIOType.DOUBLE) {
      return _sharedPreferences?.getDouble(key) ?? 0.0;
    }
  }

  saveData(String key, value, SharedPreferenceIOType type) async {
    _sharedPreferences = await SharedPreferences.getInstance();

    if (type == SharedPreferenceIOType.STRING) {
      await _sharedPreferences?.setString(key, value ?? "");
    } else if (type == SharedPreferenceIOType.INTEGER) {
      await _sharedPreferences?.setInt(key, value ?? -1);
    } else if (type == SharedPreferenceIOType.BOOL) {
      await _sharedPreferences?.setBool(key, value ?? false);
    } else if (type == SharedPreferenceIOType.DOUBLE) {
      await _sharedPreferences?.setDouble(key, value ?? 0.0);
    }
  }

  clearStorage() {
    _sharedPreferences?.clear();
  }

/*updateSpValues()async{
    AppLoginUserData.loginData = jsonDecode(await getData("AUTH_RES", SharedPreferenceIOType.stringType)) ;
    AppLoginUserData.authToken =  await getData("AUTH_TOKEN", SharedPreferenceIOType.stringType);
    AppLoginUserData.id = await getData("ID", SharedPreferenceIOType.integerType);
  }*/
}
