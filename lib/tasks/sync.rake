# require 'YAML'
#
# namespace :sync do
#
#   desc "Pull pg backup from production server"
#   task :from_production do
#     fetch_from( 'pna-prod' )
#   end
#
#   desc "Pull pg backup from staging server"
#   task :from_staging do
#     fetch_from( 'pna-dev' )
#   end
#
#   desc "Push pg backup to local db"
#   task :to_dev do
#     info = YAML.load_file( File.join( Rails.root, 'config', 'database.yml' ) )
#     puts %x(pg_restore --verbose --clean --no-acl --no-owner -h localhost -U #{info['username']} -d #{info['database']} latest.dump)
#   end
#
#   def fetch_from( app )
#     puts %x(heroku pg:backups capture --app #{app})
#     puts %x(curl -o latest.dump \`heroku pg:backups public-url --app #{app}`)
#   end
# end
