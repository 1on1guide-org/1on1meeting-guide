RUBY_ENGINE == 'opal' ? (require 'datetimeformat-InlineMacroProcessor/extension') : (require_relative 'datetimeformat-InlineMacroProcessor/extension')

Asciidoctor::Extensions.register do
  inline_macro DatetimeformatInlineMacroProcessor
end
