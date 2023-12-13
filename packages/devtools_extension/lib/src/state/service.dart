import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:vm_service/vm_service.dart';

part 'service.g.dart';

@Riverpod(keepAlive: true)
Future<VmService> service(ServiceRef ref) async {
  await serviceManager.onServiceAvailable;
  return serviceManager.service!;
}
