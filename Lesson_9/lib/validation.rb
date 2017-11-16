module Validation
  def self.included(base)
    base.extend(ClassMethods)
    base.send :include, InstanceMethods
  end

  class ValidationError < StandardError
  end

  module InstanceMethods
    def validate!
      validations = self.class.instance_variable_get('@validations')

      errors = []
      validations.each do |validation|
        #validation[:value] = instance_variable_get("@#{validation[:attribute]}")
        value = instance_variable_get("@#{validation[:attribute]}")
        error = send validation[:type], value, validation

        errors << error unless error.nil?
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

    def presence(value)
      params[:message] ||= 'Пустая строка или nil'
      params[:message] if value.nil? || value.empty?
    end

    def format(value, params)
      params[:message] ||= "Не соответствует формату #{params[:param]}"
      params[:message] unless params[:param].match(value.to_s)
    end

    def type(value, params)
      params[:message] ||= "Ожидается тип #{params[:param]}"
      params[:message] unless value.is_a?(params[:param])
    end

    def first_last_uniq(value)
      params[:message] ||= 'Первый и последний эл-ты идентичны'
      params[:message] if value.first == value.last
    end

    def each_type(value, params)
      params[:message] ||= "Содержит тип, отличающийся от #{params[:param]}"
      params[:message] if value.reject { |v| v.is_a?(params[:param]) }.length.empty?
    end
  end

  module ClassMethods
    def validate(*params)
      @validations ||= []

      @validations << {
        attribute: params[0],
        type: params[1],
        param: params[2] || nil,
        message: params.last.is_a?(Hash) && params.last.key?(:message) ? params.last[:message] : nil
      }
    end
  end
end
