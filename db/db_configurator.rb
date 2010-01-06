class DbConfigurator
  
  def initialize(environment)
    @environment = environment
  end
  
  def url_for_connection
    conf = YAML.load_file('config/database.yml')[@environment]
    conf.symbolize_keys!
    return "#{conf[:adapter]}://#{conf[:username]}#{(conf[:password].nil? || conf[:password].empty?) ? '' : ":#{conf[:password]}"}@#{conf[:host]}/#{conf[:database]}"
  end
  
end