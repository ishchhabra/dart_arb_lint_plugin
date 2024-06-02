import 'dart:convert';
import 'dart:io';

import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';

import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:json_ast/json_ast.dart';

/// A custom lint rule that checks whether there is a matching resource record
/// for every metadata entry.
class MatchingResourceRecordRule extends LintRule {
  /// Creates a new [MatchingResourceRecordRule] instance.
  const MatchingResourceRecordRule() : super(code: _code);

  static const _code = LintCode(
    errorSeverity: ErrorSeverity.ERROR,
    name: 'missing_resource_record',
    problemMessage: '{0} does not have a corresponding resource record.',
  );

  @override
  List<String> get filesToAnalyze => ['*.arb'];

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    final fileContent = File(reporter.source.fullName).readAsStringSync();
    final arbContent = jsonDecode(fileContent) as Map<String, dynamic>;

    final node = JsonParser(fileContent).parse();
    _JsonASTVisitor(
      errorCode: code,
      errorReporter: reporter,
      json: arbContent,
      node: node,
    ).visit();
  }
}

class _JsonASTVisitor extends JsonASTVisitor {
  const _JsonASTVisitor({
    required this.errorCode,
    required this.errorReporter,
    required this.json,
    required super.node,
  });

  final LintCode errorCode;
  final ErrorReporter errorReporter;
  final Map<String, dynamic> json;

  @override
  void visitIdentifierNode(IdentifierNode node) {
    super.visitIdentifierNode(node);

    final key = node.value;
    if (!key.startsWith('@') || key == '@@locale') {
      return;
    }

    if (!json.containsKey(key.substring(1))) {
      errorReporter.reportErrorForSpan(errorCode, node.span, [key]);
    }
  }
}
