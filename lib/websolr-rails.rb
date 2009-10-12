# Post-require hooks for acts_as_solr and sunspot if this 
# gem is loaded and WEBSOLR_URL is defined.

if ENV["WEBSOLR_URL"]
  module Kernel
    alias_method :require_without_solr_hooks, :require
    def require(string)
      require_without_solr_hooks(string)
      case string
      when "acts_as_solr"
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
      when "sunspot"
        Sunspot.config.solr.url = ENV["WEBSOLR_URL"]
      end
    end
  end
end