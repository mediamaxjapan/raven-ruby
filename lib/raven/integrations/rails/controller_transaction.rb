module Raven
  class Rails
    module ControllerTransaction
      def self.included(base)
        filter_method_name = (::Rails::VERSION::MAJOR == 3) ? :prepend_around_filter : :prepend_around_action
        filter_method = base.method(filter_method_name)
        filter_method.call do |controller, block|
          Raven.context.transaction.push "#{controller.class}##{controller.action_name}"
          block.call
          Raven.context.transaction.pop
        end
      end
    end
  end
end
