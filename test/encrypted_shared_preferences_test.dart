import 'package:encrypt/encrypt.dart';
import 'package:encrypt_shared_preferences/enc_shared_pref.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
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
    sharedPref.removeAllListeners();
    listener(String key,value,oldValue) {
      expect(key, "dataKey");
      expect(value, "dataValue");
      expect(oldValue, null);
    }

    sharedPref.addListener(listener);
    sharedPref.setString("dataKey", "dataValue");
    sharedPref.removeAllListeners();
  });

  test('check single key stream listener', () async {
    await sharedPref.clear();
    sharedPref.listenKey('token').listen((event) {
      expect(event.value, 'fake_token_value');
    });
    sharedPref.setString('token', 'fake_token_value');
  });

  test('check stream single', () async {
    await sharedPref.clear();
    sharedPref.listenableSingle.listen(expectAsync1((event) {
      expect(event.value,"stream_single_value");
    }));

    sharedPref.setString("steam_single", "stream_single_value");
  });
  

  test('check stream', () async {
    await sharedPref.clear();

    sharedPref.listenable.listen(expectAsync1((event) {
      expect(event.length, 1);
    }));
    sharedPref.setString("dataKey", "dataValue");
  });

  test('check add listener', () async {
    sharedPref.removeAllListeners();
    expect(sharedPref.listeners, 0);
    sharedPref.addListener((key, value, oldValue) {});
    sharedPref.addListener((key, value, oldValue) {});
    expect(sharedPref.listeners, 2);
  });
}
