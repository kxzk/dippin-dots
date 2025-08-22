;; extends

; Make the entire docstring — quotes + content — use @string.documentation
((expression_statement
   (string
     (string_start)  @string.documentation
     (string_content) @string.documentation
     (string_end)    @string.documentation))
 (#set! "priority" 130))
