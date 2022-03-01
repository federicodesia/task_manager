import 'package:hive/hive.dart';
// ignore: implementation_imports
import 'package:hive/src/hive_impl.dart';
import 'package:path_provider/path_provider.dart';

class HydratedHelper{

  Box<dynamic>? _hydratedBox;

  Future<Map<String, dynamic>?> readJsonState(String blocName) async{
    try{
      if(_hydratedBox == null){
        final storageDirectory = await getTemporaryDirectory();
        final hive = HiveImpl();
        hive.init(storageDirectory.path);
        _hydratedBox = await hive.openBox("hydrated_box");
      }

      if(_hydratedBox != null){
        final blocStateJson = _hydratedBox!.get(blocName);
        if(blocStateJson != null) return _castJson(blocStateJson);
      }
    }
    catch(error) {}
    return null;
  }

  static Map<String, dynamic>? _castJson(dynamic json) {
    final dynamic traversedJson = _traverseRead(json);
    return _cast<Map<String, dynamic>>(traversedJson);
  }

  static dynamic _traverseRead(dynamic value) {
    if (value is Map) {
      return value.map<String, dynamic>((dynamic key, dynamic value) {
        return MapEntry<String, dynamic>(
          _cast<String>(key) ?? '',
          _traverseRead(value),
        );
      });
    }
    if (value is List) {
      for (var i = 0; i < value.length; i++) {
        value[i] = _traverseRead(value[i]);
      }
    }
    return value;
  }

  static T? _cast<T>(dynamic x) => x is T ? x : null;
}