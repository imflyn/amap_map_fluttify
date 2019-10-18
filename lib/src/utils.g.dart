import 'dart:io';

import 'package:amap_map_fluttify/src/android/android.export.g.dart';
import 'package:amap_map_fluttify/src/ios/ios.export.g.dart';

typedef Future<T> AndroidFutureCallback<T>(List<Ref_Android> releasePool);
typedef Future<T> IOSFutureCallback<T>(List<Ref_iOS> releasePool);

Future<T> platform<T>({
  AndroidFutureCallback<T> android,
  IOSFutureCallback<T> ios,
}) async {
  if (android != null && Platform.isAndroid) {
    final releasePool = <Ref_Android>[];
    final result = await android(releasePool);
    releasePool.forEach((it) => ObjectFactory_Android.release(it));
    return result;
  } else if (ios != null && Platform.isIOS) {
    final releasePool = <Ref_iOS>[];
    final result = await ios(releasePool);
    releasePool.forEach((it) => ObjectFactory_iOS.release(it));
    return result;
  } else {
    return Future.value();
  }
}

Future release(Ref ref) {
  return platform(
    android: (pool) => ObjectFactory_Android.release(ref),
    ios: (pool) => ObjectFactory_iOS.release(ref),
  );
}

class Ref {
  int refId;
}

/// 回调参数的释放池
final kCallbackPool = <int, Ref>{};
