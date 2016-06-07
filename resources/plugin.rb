actions :install, :update, :remove
default_action :create

state_attrs :name

# Resource properties
attribute :name, name_attribute: true, kind_of: String, required: true

attr_accessor :installed
