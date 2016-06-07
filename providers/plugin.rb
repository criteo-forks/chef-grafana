include GrafanaCookbook::Plugin

use_inline_resources if defined?(use_inline_resources)

def whyrun_supported?
  true
end

action :install do
  unless @current_resource.installed
    plugin_name = new_resource.name
    raise "#{plugin_name} is not available" unless plugin_available?(plugin_name)
    converge_by("Installing plugin #{plugin_name}") do
      manage_plugin(plugin_name, 'install')
    end
  end
end

action :update do
  if @current_resource.installed
    plugin_name = new_resource.name
    converge_by("Upgrading plugin #{plugin_name}") do
      manage_plugin(plugin_name, 'update')
    end
  else
    Chef::Log.warn "Impossible to upgrade plugin #{plugin_name} because it is not installed. We will install it."
    converge_by("Installing plugin #{plugin_name}") do
      manage_plugin(plugin_name, 'install')
    end
  end
end

action :remove do
  if @current_resource.installed
    plugin_name = new_resource.name
    converge_by("Removing plugin #{plugin_name}") do
      manage_plugin(plugin_name, 'remove')
    end
  end
end

# Override Load Current Resource
def load_current_resource
  @current_resource = Chef::Resource::GrafanaPlugin.new(@new_resource.name)
  @current_resource.name(@new_resource.name)
  @current_resource.installed = plugin_installed?(@new_resource.name)
end
