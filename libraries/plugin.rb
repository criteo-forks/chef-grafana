module GrafanaCookbook
  module Plugin
    module_function

    def plugin_available?(name, grafana_cli_bin='/usr/sbin/grafana-cli')
      cmd = Mixlib::ShellOut.new("#{grafana_cli_bin} plugins list-remote")
      cmd.run_command
      !cmd.stdout.split("\n").select { |item| item.include?('id:') && item.match(name) }.empty?
    end

    def plugin_installed?(name, grafana_cli_bin='/usr/sbin/grafana-cli')
      cmd = Mixlib::ShellOut.new("#{grafana_cli_bin} plugins ls")
      cmd.run_command
      !cmd.stdout.split("\n").select { |item| item.include?('@') && item.match(name) }.empty?
    end

    def build_cli_cmd(name, action, grafana_cli_bin='/usr/sbin/grafana-cli')
      "#{grafana_cli_bin} plugins #{action} #{name}"
    end

  end
end
