require "thor"
require "zenform"
require "zenform/commands/apply"

module Zenform
  class CLI < Thor
    desc "apply --config-path [CONFIG_PATH]", "Update Zendesk contents according to the config files in CONFIG_PATH (default CONFIG_PATH is #{Zenform::ConfigParser::DEFAULT_CONFIG_PATH})"
    option :config_path, default: Zenform::ConfigParser::DEFAULT_CONFIG_PATH
    def apply()
      Zenform::Commands::Apply.run(options[:config_path], shell)
    end
  end
end
