import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'app.dart';

Future<void> main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(createApp());
}