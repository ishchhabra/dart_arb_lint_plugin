import 'package:analyzer/source/source.dart';

/// Extension to the [Source] class to method.
extension SourceExtension on Source {
  /// Whether the source is an arb file.
  bool get isArb => fullName.endsWith('.arb');
}
