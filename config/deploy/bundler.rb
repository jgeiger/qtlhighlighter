namespace :bundle do
  desc <<-DESC
    Install the current Bundler environment. By default, gems will be \
    installed to the shared/bundle path. Gems in the development and \
    test group will not be installed. The install command is executed \
    with the --deployment and --quiet flags. You can override any of \
    these defaults by setting the variables shown below. If capistrano \
    can not find the 'bundle' cmd then you can override the bundle_cmd \
    variable to specifiy which one it should use.

      set :bundle_gemfile,      fetch(:latest_release)+"/Gemfile"
      set :bundle_dir,          fetch(:shared_path)+"/bundled_gems"
      set :bundle_flags,       "--deployment --quiet"
      set :bundle_without,      [:development, :test]
      set :bundle_cmd,          "bundle" # e.g. change to "/opt/ruby/bin/bundle"
  DESC
  task :install, :except => { :no_release => true } do

    bundle_gemfile = (fetch(:bundle_gemfile, nil) || fetch(:latest_release)+"/Gemfile")
    bundle_dir     = fetch(:bundle_dir, "#{fetch(:shared_path)}/bundled_gems")
    bundle_without = [*fetch(:bundle_without, [:development, :test])].compact
    bundle_flags   = fetch(:bundle_flags, "--deployment --quiet")
    bundle_cmd     = fetch(:bundle_cmd, "bundle")

    args = ["--gemfile #{bundle_gemfile}"]
    args << "--path #{bundle_dir}" unless bundle_dir.to_s.empty?
    args << bundle_flags.to_s
    args << "--without #{bundle_without.join(" ")}" unless bundle_without.empty?

    run "#{bundle_cmd} install #{args.join(' ')}"
  end
end
