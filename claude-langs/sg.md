# Ast-grep (`sg`)
## sg guidelines
- purpose: high-speed structural code search and analysis through ast pattern matching. enables agents to rapidly extract, locate, and understand code patterns across large codebases without parsing overhead.
- core value: transforms code comprehension from linear text scanning to structural pattern recognition - like having grep that understands syntax trees instead of strings.
## sg syntax
sg --pattern '$FUNC($$$ARGS)' --lang python --json
sg --pattern 'if ($COND) { $$$BODY }' --lang javascript --json
sg --pattern 'class $NAME extends $PARENT' --lang java --json
## sg patterns
- $VAR - Matches any single node (identifier, expression, statement)
- $$$VAR - Matches zero or more nodes (variadic)
- $$VAR - Matches one or more nodes
- _ - Matches any single node without capturing
- Literal code matches exactly as written
## sg examples
<!--find all function calls named 'process'-->
sg --pattern 'process($$$)' --lang python --json
<!--extract all class definitions-->
sg --pattern 'class $NAME { $$$BODY }' --lang javascript --json
<!--locate specific import patterns-->
sg --pattern 'import { $$$IMPORTS } from "$MODULE"' --lang javascript --json
<!--find method definitions with specific signatures-->
sg --pattern 'def $METHOD(self, data: $TYPE) -> $RETURN' --lang python --json
