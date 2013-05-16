require 'multi_json/adapter'

module MultiJson
  module Adapters
    class JsonCommon < Adapter
      defaults :load, :create_additions => false, :quirks_mode => true

      GEM_VERSION = '1.7.7'

      def activate
        if JSON::VERSION < GEM_VERSION
          Kernel.warn "You are using an old or stdlib version of the #{gem_name} gem.\n" +
            "If you are using Bundler, please add this to your Gemfile:\n\n" +
            "  gem '#{gem_name}', '~> #{GEM_VERSION}'\n\n" +
            "For standalone Ruby code, please specify the gem version in your code before\n" +
            "requiring it, like so:\n\n" +
            "  gem '#{gem_name}', '~> #{GEM_VERSION}'\n" +
            "  require '#{gem_name}'\n\n"
        end
      end

      def load(string, options={})
        string = string.read if string.respond_to?(:read)

        if string.respond_to?(:force_encoding)
          string = string.dup.force_encoding(::Encoding::ASCII_8BIT)
        end

        options[:symbolize_names] = true if options.delete(:symbolize_keys)
        ::JSON.parse(string, options)
      end

      def dump(object, options={})
        options.merge!(::JSON::PRETTY_STATE_PROTOTYPE.to_h) if options.delete(:pretty)
        object.to_json(options)
      end
    end
  end
end
