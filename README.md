# Deprecated

This code has been deprecated. We recommend the following replacements:

* [Sunspot](http://outoftime.github.com/sunspot/) now directly supports the `WEBSOLR_URL` environment variable, obviating the need for a configuration shim.
* [websolr-acts_as_solr](https://github.com/onemorecloud/websolr-acts_as_solr) is the current configuration shim for supporting the `WEBSOLR_URL` environment variable in `acts_as_solr`.
* [RSolr](https://github.com/mwmitchell/rsolr) is as lightweight a Ruby Solr client as you can find.

If you are using Websolr on Heroku, you should refer to [http://docs.heroku.com/websolr](http://docs.heroku.com/websolr) for the most up to date instructions.


----

# websolr-rails

This overrides `acts_as_solr` or Sunspot to use the value of the 
environment variable `WEBSOLR_URL` as the Solr Search server, 
provided that it's defined.

After installing the gem, you can include `websolr-rails` in your 
app by either starting the webapp like:

    WEBSOLR_URL=http://index.websolr.com/solr/<api-key> ./script/server
  
Or, you can put the following in /environment/production.rb, or an
initializer, etc:

    # production.rb
    ENV["WEBSOLR_URL"] = "http://index.websolr.com/solr/<api-key>"
    
    # WEBSOLR_URL must already be defined.
    require "websolr-rails"

## Semantic Versioning

This library obeys the definition of "Semantic Versioning" at http://semver.org/.  YMMV with its dependencies.

## Copyright

Copyright (c) 2009 Onemorecloud, LLC. See LICENSE for details.
