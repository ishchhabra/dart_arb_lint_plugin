import 'package:arb_lint_plugin/src/rules/rules.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Registers the plugin with custom_lint.
PluginBase createPlugin() => ArbLintPlugin();

/// A lint plugin for *.arb files.
class ArbLintPlugin extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        const MatchingResourceRecordRule(),
      ];
}
