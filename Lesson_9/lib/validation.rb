module Validation
  def self.included(base)
    base.extend(ClassMethods)
    base.send :include, InstanceMethods
  end

  class ValidationError < StandardError
  end

  module InstanceMethods
    def validate!
      validations = self.class.class_variable_get('@@validations')
      errors = []

      validations.each do |validation|
        value = instance_variable_get("@#{validation[:attribute]}")
        error = find_error(value, validation[:type], validation[:param])

        errors << "#{self.class}:@#{validation[:attribute]} -> #{error}" unless error.nil?
      end

      raise ValidationError, errors unless errors.empty?
      true
    end

    def valid?
      validate!
      true
    rescue ValidationError
      false
    end

    private

    def find_error(value, type, param)
      case type
      when :presence then error = 'Пустая строка или nil' if value.nil? || value.empty?
      when :format then error = "Не соответствует формату #{param}" unless param.match(value.to_s)
      when :type then error = "Ожидается тип #{param}" unless value.is_a?(param)
      when :first_last_uniq then error = "Первый и последний эл-ты идентичны" if value[0] == value[-1]
      when :each_type
        indexes = []
        value.each_with_index do |v,index|
          indexes << index unless v.is_a?(param)
        end
        error = "Ожидается тип #{param} (#{indexes})" unless indexes.empty?
      end

      error
    end
  end

  module ClassMethods
    def validate(attribute, type, param = nil)
      validate_attr = '@@validations'
      validations = class_variable_defined?(validate_attr) ? class_variable_get(validate_attr) : []

      validations << {
        attribute: attribute,
        type: type,
        param: param
      }
      class_variable_set(validate_attr, validations)
    end
  end
end

#class A
#  include Validation

#  attr_accessor :x, :y

#  validate :x, :presence
#  validate :x, :format, /ss/
#  validate :x, :type, String

#  def initialize
#    @x = 's'
#    @y = 1
#  end
#end

#a = A.new
#puts a.x
#a.validate!
