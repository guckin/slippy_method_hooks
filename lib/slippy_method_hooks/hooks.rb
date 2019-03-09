require 'slippy_method_hooks/errors'
require 'timeout'
module SlippyMethodHooks
  def self.included(mod)
    mod.extend(ClassMethods)
  end

  def self.extend(mod)
    mod.extend(ClassMethods)
  end

  module ClassMethods
    def time_box_method(time, *names, &blk)
      names.each do |name|
        meth = instance_method(name)
        define_method(name) do |*args, &block|
          begin
            Timeout.timeout(time) do
              meth.bind(self).call(*args, &block)
            end
          rescue Timeout::Error
            error_args = [TimeoutError, 'execution expired', caller]
            raise(*error_args) unless block_given?

            return instance_exec(*error_args, &blk)
          end
        end
      end
    end

    def rescue_on_fail(*names, &blk)
      unless blk
        raise NoBlockGiven,
              '.rescue_on_fail must be called with a block',
              caller
      end
      names.each do |name|
        meth = instance_method(name)
        define_method(name) do |*args, &block|
          begin
            meth.bind(self).call(*args, &block)
          rescue StandardError => e
            return instance_exec(e, &blk)
          end
        end
      end
    end

    def after(*names)
      names.each do |name|
        meth = instance_method(name)
        define_method name do |*args, &block|
          result = meth.bind(self).call(*args, &block)
          yield result
        end
      end
    end

    def before(*names)
      names.each do |name|
        meth = instance_method(name)
        define_method name do |*args, &block|
          yield
          meth.bind(self).call(*args, &block)
        end
      end
    end
  end
end
