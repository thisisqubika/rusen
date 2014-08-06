module Rusen
  module Notifiers

    NOTIFIERS = {
      :pony =>  :PonyNotifier,
      :mail =>  :MailNotifier,
      :io =>    :IONotifier,
      :log4r => :Log4rNotifier,
    }

    def self.load_klass(ident, klass_sym = nil)
      klass_sym ||= NOTIFIERS[ident]
      if klass_sym
        require "rusen/notifiers/#{ident}_notifier" unless Notifiers.constants.include?(klass_sym)
        Notifiers.const_get(klass_sym)
      else
        return nil
      end
    end

    def self.check_deprecation(ident)
      if ident == :email
        warn ':email is a deprecated output type. :pony replaces :email.  A new alternative is :mail (mail gem).'
        return :pony
      end
      return ident
    end
  end
end
