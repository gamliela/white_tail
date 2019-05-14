module WhiteTail
  module Utils
    def self.underscore(camel_cased_word)
      camel_cased_word.to_s.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
        gsub(/([a-z\d])([A-Z])/, '\1_\2').
        tr("-", "_").
        downcase
    end

    def self.camel_case(underscored_word)
      return underscored_word if underscored_word !~ /_/ && underscored_word =~ /[A-Z]+.*/
      underscored_word.split("_").map(&:capitalize).join
    end
  end
end
