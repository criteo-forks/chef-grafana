module GrafanaCookbook
  module Plugin
    module_function

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

    def build_cli_cmd(name, action)
      "/usr/sbin/grafana-cli plugins #{action} #{name}"
    end

  end
end
