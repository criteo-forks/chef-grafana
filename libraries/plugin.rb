module GrafanaCookbook
  module Plugin
    def manage_plugin(name, action='install')
      _build_cli_cmd(name, action)
    end

    def plugin_available?(name)
      cmd = Mixlib::ShellOut.new('/usr/sbin/grafana-cli plugins list-remote')
      cmd.run_command
      !cmd.stdout.split("\n").select { |item| item.include?('id:') && item.match(name) }.empty?
    end

    def plugin_installed?(name)
      cmd = Mixlib::ShellOut.new('/usr/sbin/grafana-cli plugins ls')
      cmd.run_command
      !cmd.stdout.split("\n").select { |item| item.include?('@') && item.match(name) }.empty?
    end

    def _build_cli_cmd(name, action)
      execute "#{action} #{name}" do
        command "/usr/sbin/grafana-cli plugins #{action} #{name}"
      end
    end
  end
end
