require 'rusen'
require 'sidekiq'

Rusen.settings.outputs = [:mail]
Rusen.settings.sections = [:backtrace]

if Sidekiq::VERSION < '3'
  require_relative 'middleware/rusen_sidekiq'

  Sidekiq.configure_server do |config|
    config.server_middleware do |chain|
      chain.add Rusen::Middleware::RusenSidekiq
    end
  end
else
  Sidekiq.configure_server do |config|
    config.error_handlers << Proc.new { |ex, context| Rusen.notify(ex) }
  end
end