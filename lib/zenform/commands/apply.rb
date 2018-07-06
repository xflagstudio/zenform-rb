require 'zenform/zendesk_client'
require 'zenform/commands/apply/base'
require 'zenform/commands/apply/ticket_field'
require 'zenform/commands/apply/ticket_form'
require 'zenform/commands/apply/trigger'

module Zenform
  module Commands
    module Apply
      class << self
        def run(project_path, shell)
          config = Zenform::ConfigParser.parse project_path
          client = Zenform::ZendeskClient.create(config["auth_info"].transform_keys(&:to_sym))
          return shell.say("Aborted!", :red) unless shell.yes? "Applying config to Zendesk account #{config["auth_info"]["domain"]}.\nAre you sure? (yes/n)"

          klasses = [
            Zenform::Commands::Apply::TicketField,
            Zenform::Commands::Apply::TicketForm,
            Zenform::Commands::Apply::Trigger
          ]
          klasses.each do |klass|
            subcommand = klass.new client, project_path, config[klass.to_s.split("::").last.underscore], shell
            shell.say "Creating #{subcommand.content_name} ..."
            shell.indent { subcommand.run }
          end
          shell.say("Updated!", :green)
        end
      end
    end
  end
end
