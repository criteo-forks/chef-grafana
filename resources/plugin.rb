actions :install, :update, :remove
default_action :install

state_attrs :name

# Resource properties
attribute :name, name_attribute: true, kind_of: String, required: true
attribute :grafana_cli_bin, kind_of: String, required: false

attr_accessor :installed
