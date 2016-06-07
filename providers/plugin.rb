include GrafanaCookbook::Plugin

use_inline_resources if defined?(use_inline_resources)

def whyrun_supported?
  true
end

action :install do
  plugin_name = new_resource.name
  raise "#{plugin_name} is not available" unless plugin_available?(plugin_name)
  execute "Installing plugin #{plugin_name}" do
    command ::GrafanaCookbook::Plugin.build_cli_cmd(plugin_name, 'install')
    not_if { current_resource.installed }
  end
end

action :update do
  plugin_name = new_resource.name
  if @current_resource.installed
    execute "Updating plugin #{plugin_name}" do
      command ::GrafanaCookbook::Plugin.build_cli_cmd(plugin_name, 'update')
    end
  else
    Chef::Log.warn "Impossible to upgrade plugin #{plugin_name} because it is not installed. We will install it."
    run_action(:install)
  end
end

action :remove do
  plugin_name = new_resource.name
  execute "Removing plugin #{name}" do
    command ::GrafanaCookbook::Plugin.build_cli_cmd(plugin_name, 'remove')
    only_if { current_resource.installed }
  end
end

# Override Load Current Resource
def load_current_resource
  @current_resource = Chef::Resource::GrafanaPlugin.new(@new_resource.name)
  @current_resource.installed = plugin_installed?(@new_resource.name)
end
