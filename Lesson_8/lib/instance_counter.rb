module InstanceCounter
  def self.included(base)
    base.extend(ClassMethods)
    base.send :include, InstanceMethods
  end

  module InstanceMethods
    protected

    def register_instance
      instance = self.class.instance.nil? ? 0 : self.class.instance
      self.class.send :instance=, instance + 1
    end
  end

  module ClassMethods
    attr_reader :instance

    private

    attr_writer :instance
  end
end
