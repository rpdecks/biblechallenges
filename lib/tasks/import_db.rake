namespace :db do
  desc "Restore latest Heroku db backup locally"
  task restore: :environment do
    # Get the current db config
    #config = Rails.configuration.database_configuration[Rails.env]
    Bundler.with_clean_env do
      #heroku pg:backups capture -a biblechallenges
      `curl -o db.dump \`heroku pg:backups public-url -a biblechallenges\``
      `pg_restore --verbose --clean --no-acl --no-owner -d bc_development db.dump`
    end
  end
end
