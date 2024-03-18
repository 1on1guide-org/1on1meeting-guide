require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'
require 'time'

include Asciidoctor

class DatetimeformatInlineMacroProcessor < Extensions::InlineMacroProcessor
  use_dsl

  named :datetimeformat
  name_positional_attributes 'format'

  def process parent, target, attributes
    doc = parent.document

    if target == 'now'
      time = Time.now
      format = attributes['format'] ? attributes['format'] : '%Y/%m/%d %H:%M:%S'
    elsif target == 'revdate'
      time = Time.parse(doc.revdate)
      format = attributes['format'] ? attributes['format'] : '%Y/%m/%d'
    elsif  target == 'docdatetime' ||  target == 'localdatetime'
      time = Time.strptime(doc.attributes[target], '%F %T %z')
      format = attributes['format'] ? attributes['format'] : '%Y/%m/%d %H:%M:%S'
    elsif target == 'docdate' || target == 'localdate'
      time = Time.parse(doc.attributes[target])
      format = attributes['format'] ? attributes['format'] : '%Y/%m/%d'
    elsif target == 'doctime' || target == 'localtime'
      time = Time.parse(doc.attributes[target])
      format = attributes['format'] ? attributes['format'] : '%H:%M:%S'
    end

    if format == '年月日時分秒'
      format = '%Y年%m月%d日 %H時%M分%S秒'
    elsif format == '年月日時分'
        format = '%Y年%m月%d日 %H時%M分'
    elsif format == '時分秒'
      format = '%H時%M分%S秒'
    elsif format == '時分'
      format = '%H時%M分'
    elsif format == '/:ss'
      format = '%Y/%m/%d %H:%M:%S'
    elsif format == ':ss'
      format = '%H:%M:%S'
    elsif format == '/:'
      format = '%Y/%m/%d %H:%M'
    elsif format == ':'
      format = '%H:%M'
    elsif format == 'T'
      format = '%Y-%m-%dT%H:%M:%S%:z'
    elsif format == '年月日'
      format = '%Y年%m月%d日'
    elsif format == '/'
      format = '%Y/%m/%d'
    elsif format == '-'
      format = '%Y-%m-%d'
    elsif format.include?("%")
      format = format
    end

    result = time.strftime(format)

    if format == 'httpdate'
      result = time.httpdate
    elsif format == 'iso8601'
      result = time.iso8601
    elsif format == 'rfc2822'
      result = time.rfc2822
    elsif format == 'rfc822'
      result = time.rfc822
    elsif format == 'xmlschema'
      result = time.xmlschema
    end

    create_inline parent, :quoted, result
  end

end
