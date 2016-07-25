require 'yaml'
require 'securerandom'

namespace :setup do
  desc "Setting developing environment for Biblechallenges"
  task :config do
    puts "do you want to setup heroku? (Y/N)"
    git_setup 
    puts "do you want to setup application variables? (Y/N)"
    config_values_setup
    puts "do you want to setup database? (N/Y) You many lose your current Biblechallenges data."
    db_setup
    puts "do you want to download data from production? (Y/N) You many lose your current  Biblechallenges data."
    download_db
    puts "Biblechallenges application launching..............."
    system "rails s"
  end

  def git_setup
    STDOUT.flush
    input = STDIN.gets.chomp
    case input.upcase
    when "Y"
      puts "setting up heroku remote..........."
      system "git remote add staging git.heroku.com/bc-staging.git"
      puts "staging: git.heroku.com/bc-staging.git"
      system "git remote add production git@heroku.com:biblechallenges.git"
      puts "production: git@heroku.com:biblechallenges.git"
      puts "done..........."
    when "N"
      puts "aborting the task....."
    else
      puts "please enter Y or N"
      git_setup
    end
  end

  def config_values_setup 
    STDOUT.flush
    input = STDIN.gets.chomp
    case input.upcase
    when "Y"
      if File.exist?('config/application.example.yml')
        File.delete('config/application.yml') if File.exist?('config/application.yml')
        env = File.open("config/application.yml","w+")
        puts "setting up application variables .........."
        puts "creating config/application.yml .........."

        File.open("config/application.example.yml", "r").each_line do |line|
          key, value = line.split ":"
          if key == "SSL_CERT_FILE"
            #value = key + ': #"/usr/local/etc/openssl/cert.pem"'
            env.puts "#{value}"
            puts "............................."
          else
            value = key + ': "' + SecureRandom.hex(10) +'"'
            env.puts "#{value}"
            puts "............................."
          end
        end

        env.puts 'APP_URL: "http://localhost/3000"'
        puts "done.............................."
        env.close
      else
        puts "error: can not find config/application.example.yml." 
      end
    when "N"
      puts "aborting the task....."
    else
      puts "please enter Y or N"
      config_values_setup 
    end
  end

  def db_setup
    STDOUT.flush
    input = STDIN.gets.chomp
    case input.upcase
    when "Y"
      puts "setting up database..................."
      if File.exist?('./config/database.yml')
        system "bundle exec rake db:create && db:create"
        puts "creating db........."
        puts "done.............................."

        system "bundle exec rake db:migrate"
        puts "migrating db........."
        puts "done.............................."

        puts "preparing test database..................."
        system "RAILS_ENV=test bin/rake db:migrate"
        puts "done.............................."
      else
        puts "error: check config/database.yml"
      end
      puts "done..........................."
    when "N"
      puts "aborting the task....."
    else
      puts "please enter Y or N"
      db_setup
    end
  end

  def download_db
    STDOUT.flush
    input = STDIN.gets.chomp
    case input.upcase
    when "Y"
       puts "If any problem occurs, Check your access to the heroku app first..."
      puts "downloading db..................."
      if File.exist?('./config/database.yml')
        system "rake db:restore"
        puts "done..........................."
      else
        puts "error: check the file ./config/database.yml"
      end
    when "N"
      puts "aborting the task....."
    else
      puts "please enter Y or N"
      download_db
    end
  end
end
