require "test_helper"
require "test_fakes"
require 'active_record/serializer_override'

class SerializerTest < ActiveModel::TestCase
  class UserWithSerializerOverride < User
    include ActiveRecord::SerializerOverride
    def active_model_serializer
      User.active_model_serializer
    end
  end

  def test_attributes_with_serializer
    user = UserWithSerializerOverride.new

    hash = {
      :state => 'InProgress',
      :signed_in => true,
      :data => user
    }

    assert_equal({
      :state => 'InProgress',
      :signed_in => true,
      :data => {:user => { :first_name => "Jose", :last_name => "Valim", :ok => true}}
    }.to_json, hash.to_json)
  end

  def test_attributes_without_serializer
    user = User.new

    hash = {
      :state => 'InProgress',
      :signed_in => true,
      :data => user
    }

    assert_equal({
      :state => 'InProgress',
      :signed_in => true,
      :data => {:attributes => { :first_name => "Jose", :last_name => "Valim", :password => "oh noes yugive my password"}}
    }.to_json, hash.to_json)
  end
end
