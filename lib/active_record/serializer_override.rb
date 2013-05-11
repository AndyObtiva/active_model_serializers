# We do not recommend that you use AM::S in this way in general
# It is a mixin that overrides ActiveRecord::Base#to_json and #as_json.
#
# One exception is when a legacy app's controllers are rendering json for a model
# nested within a hash, which will not trigger ActiveModelSerializers unless
# you require this file and mixin this module into your ActiveRecord::Base models.
#
# Example:
#
# In controller actions of a legacy app, there is a lot of this:
# render :json => {param1 => value1, params2 => value2, data => active_record}
#
# Add an initializer file: "config/initializers/active_model_serializers.rb"
#
# with this content:
#
# require 'active_record/serializer_override'
# ActiveRecord::Base.send(:include, ActiveRecord::SerializerOverride)

module ActiveRecord
  module SerializerOverride
    def to_json(options = {})
      options ||= {}
      if respond_to?(:active_model_serializer)
        active_model_serializer.new(self).to_json(options)
      else
        super
      end
    end

    def as_json(options = {})
      options ||= {}
      if respond_to?(:active_model_serializer)
        active_model_serializer.new(self).as_json(options)
      else
        super
      end
    end
  end
end
