module Brancher
  module MultipleDatabaseConfigurationRenaming
    module ClassMethods
      def establish_connection(spec = nil)
        DatabaseRenameService.rename!(configurations, spec.to_s) if spec && spec.is_a?(Hash).!

        super
      end
    end

    def self.prepended(base)
      base.singleton_class.send(:prepend, ClassMethods)
    end
  end
end
