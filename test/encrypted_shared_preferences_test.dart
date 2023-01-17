import 'dart:math';

import 'package:encrypt/encrypt.dart';
import 'package:encrypt_shared_preferences/enc_shared_pref.dart';
import 'package:encrypt_shared_preferences/listener.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  final sharedPref = await EncryptedSharedPreferences.getInstance();
  sharedPref.setEncryptionKey("xxxx xxxx xxxxxx");
  sharedPref.setEncryptionMode(AESMode.cfb64);

  test('check data string saved', () async {
    sharedPref.setString("dataKey", "dataValue");
    expect(sharedPref.getString('dataKey'), "dataValue");
  });

  test('check data int saved', () async {
    sharedPref.setInt("age", 99);
    expect(sharedPref.getInt('age'), 99);
  });

  test('check data double saved', () async {
    sharedPref.setDouble("pi", 3.14);
    expect(sharedPref.getDouble('pi'), 3.14);
  });

  test('check data boolean saved', () async {
    sharedPref.setBoolean("isPremium", true);
    expect(sharedPref.getBoolean('isPremium'), true);
  });

  test('check data clear', () async {
    var res = await sharedPref.clear();
    expect(res, true);
    expect(sharedPref.getString('dataKey'), null);
  });

  test('check data removed', () async {
    sharedPref.setString("dataKey", "dataValue");
    expect(sharedPref.getString('dataKey'), "dataValue");
    await sharedPref.remove('dataKey');
    expect(sharedPref.getString('dataKey'), null);
  });

  test('check get all keys', () async {
    await sharedPref.clear();
    sharedPref.setString("dataKey", "dataValue");
    var keys = await sharedPref.getKeys();
    expect(keys.length, 1);
  });

  test('check get all key values', () async {
    await sharedPref.clear();
    await sharedPref.setString("dataKey", "dataValue");
    await sharedPref.setString("dataKey1", "dataValue1");
    var keys = await sharedPref.getKeyValues();
    expect(keys.length, 2);
  });

  test('check invoke listener', () async {
    await sharedPref.clear();
    listener(String key,value,oldValue) {
      expect(key, "dataKey");
      expect(value, "dataValue");
      expect(oldValue, null);
    }

    sharedPref.listenableSingle.listen((event) {
      expect(event.key, "dataKey");
      expect(event.value, "dataValue");
      expect(event.oldValue, null);
    });

    sharedPref.addListener(listener);
    sharedPref.setString("dataKey", "dataValue");
    sharedPref.removeAllListeners();
  });

  test('check stream single', () async {
    await sharedPref.clear();
    sharedPref.listenableSingle.listen((event) {
      expect(event.key, "dataKey");
      expect(event.value, "dataValue");
      expect(event.oldValue, null);
    });
    sharedPref.setString("dataKey", "dataValue");
    sharedPref.setCanListenSingle(false);
  });

  test('check stream', () async {
    await sharedPref.clear();

    sharedPref.listenable.listen((event) {
      print(event);
      expect(event.length, 3);
    });
    sharedPref.setString("dataKey", "dataValue");
    sharedPref.setString("dataKey1", "dataValue1");
    sharedPref.setString("dataKey2", "dataValue2");
  });

  test('check add listener', () async {
    sharedPref.removeAllListeners();
    expect(sharedPref.listeners, 0);
    sharedPref.addListener((key, value, oldValue) {});
    sharedPref.addListener((key, value, oldValue) {});
    expect(sharedPref.listeners, 2);
  });

}
