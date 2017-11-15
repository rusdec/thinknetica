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
        validation[:value] = instance_variable_get("@#{validation[:attribute]}")
        error = send validation[:type], validation

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

    def presence(params)
      params[:message] ||= 'Пустая строка или nil'
      params[:message] if params[:value].nil? || params[:value].empty?
    end

    def format(params)
      params[:message] ||= "Не соответствует формату #{params[:param]}"
      params[:message] unless params[:param].match(params[:value].to_s)
    end

    def type(params)
      params[:message] ||= "Ожидается тип #{params[:param]}"
      params[:message] unless params[:value].is_a?(params[:param])
    end

    def first_last_uniq(params)
      params[:message] ||= 'Первый и последний эл-ты идентичны'
      params[:message] if params[:value].first == params[:value].last
    end

    def each_type(params)
      params[:message] ||= "Содержит тип, отличающийся от #{params[:param]}"
      values = params[:value]
      params[:message] if values.reject { |v| v.is_a?(params[:param]) }.length.empty?
    end
  end

  module ClassMethods
    def validate(*params)
      validate_attr = '@validations'
      validations = instance_variable_get(validate_attr) || []

      validations << {
        attribute: params[0],
        type: params[1],
        param: params[2] || nil,
        message: params.last.is_a?(Hash) && params.last.key?(:message) ? params.last[:message] : nil
      }

      instance_variable_set(validate_attr, validations)
    end
  end
end
