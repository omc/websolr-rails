# Post-require hooks for acts_as_solr and sunspot if this 
# gem is loaded and WEBSOLR_URL is defined.

if ENV["WEBSOLR_URL"] && !$websolr_already
  $websolr_already = true
  
  def websolr_install_sunspot
    puts "Using websolr-rails for sunspot at #{ENV["WEBSOLR_URL"]}"
    Sunspot.config.solr.url = ENV["WEBSOLR_URL"]
  end
    
  def websolr_install_acts_as_solr
    puts "Using websolr-rails for acts_as_solr at #{ENV["WEBSOLR_URL"]}"
    eval <<-RUBY
      module ::ActsAsSolr
        class Post        
            def self.execute(request)
              begin
                connection = Solr::Connection.new(ENV["WEBSOLR_URL"])
                return connection.send(request)
              rescue 
                raise "Couldn't connect to the Solr server at #{url}. #{$!}"
                false
              end
            end
          end
        end
      end
    RUBY
  end   
  
  begin
    ActsAsSolr
    websolr_install_acts_as_solr
  rescue NameError
  end

  begin
    Sunspot
    websolr_install_acts_as_solr
  rescue NameError
  end
  
  module Kernel #:nodoc: all
    alias_method :require_without_solr_hooks, :require
    def require(string)
      require_without_solr_hooks(string)
      case string
      when "acts_as_solr"
        websolr_install_acts_as_solr
      when "sunspot"
        websolr_install_sunspot
      end
    end
  end
  
end