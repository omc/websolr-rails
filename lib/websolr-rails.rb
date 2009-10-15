# Post-require hooks for acts_as_solr and sunspot if this 
# gem is loaded and WEBSOLR_URL is defined.

if ENV["WEBSOLR_URL"] && !$websolr_already
  $websolr_already = true
  require "uri"
  
  def websolr_install_sunspot
    eval <<-RUBY
      module Sunspot #:nodoc:
        module Rails #:nodoc:
          class Configuration
            def hostname
              URI.parse(ENV["WEBSOLR_URL"]).host
            end
            def port
              URI.parse(ENV["WEBSOLR_URL"]).port
            end
            def path
              URI.parse(ENV["WEBSOLR_URL"]).path
            end
          end
        end
      end
    RUBY
  end

  def websolr_install_acts_as_solr
    eval <<-RUBY
      module ActsAsSolr
        class Post        
          def self.execute(request)
            begin
              connection = Solr::Connection.new(ENV["WEBSOLR_URL"])
              return connection.send(request)
            rescue 
              raise "Couldn't connect to the Solr server at \#{url}. \#{$!}"
              false
            end
          end
        end
      end
    RUBY
  end
  
  websolr_install_sunspot
  websolr_install_acts_as_solr
  
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