# ========================
# = Setup the Load Paths =
# ========================
$:.unshift *Dir[File.dirname(__FILE__) + "/../vendor/*/*/lib"]
$:.unshift *Dir[File.dirname(__FILE__) + "/../lib"]

# =========================
# = Setup the environment =
# =========================
APP_ENV = Sinatra::Application.environment.to_s

# ============================
# = Database Gem Pre-loading =
# ============================
require 'active_record'
require 'sinatra/activerecord'
require 'db/db_configurator'

# =============================================
# = Connect to the database with ActiveRecord =
# =============================================
set :database, DbConfigurator.new(APP_ENV).url_for_connection

# =========================================
# = Go get all of our ActiveRecord Models =
# =========================================
Dir.glob((Sinatra::Application.root || Dir.pwd) + '/app/models/*').each { |model| require model }

# ==================
# = Remaining Gems =
# ==================
require 'yaml'
require 'yajl/json_gem'
require 'active_record_extensions'
mime :json, "application/json"
