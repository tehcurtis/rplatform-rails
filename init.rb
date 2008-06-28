# load Facebook YAML configuration file (credit: Evan Weaver)

begin
  yamlFile = YAML.load_file("#{RAILS_ROOT}/config/facebook.yml")
rescue Exception => e
  raise StandardError, "config/facebook.yml could not be loaded."
end

if yamlFile
  if yamlFile[RAILS_ENV]
    NETWORKS.merge!(yamlFile[RAILS_ENV])
  else
    raise StandardError, "config/facebook.yml exists, but doesn't have a configuration for RAILS_ENV=#{RAILS_ENV}."
  end
else
  raise StandardError, "config/facebook.yml does not exist."
end


# inject methods to Rails MVC classes
ActionView::Base.send(:include, RFacebook::Rails::ViewExtensions)
ActionController::Base.send(:include, RFacebook::Rails::ControllerExtensions)
ActiveRecord::Base.send(:include, RFacebook::Rails::ModelExtensions)

# inject methods to Rails session management classes
CGI::Session.send(:include, RFacebook::Rails::SessionExtensions)

# TODO: document SessionStoreExtensions as API so that anyone can patch their own custom session container in addition to these
CGI::Session::PStore.send(:include, RFacebook::Rails::SessionStoreExtensions)
CGI::Session::ActiveRecordStore.send(:include, RFacebook::Rails::SessionStoreExtensions)
CGI::Session::DRbStore.send(:include, RFacebook::Rails::SessionStoreExtensions)
CGI::Session::FileStore.send(:include, RFacebook::Rails::SessionStoreExtensions)
CGI::Session::MemoryStore.send(:include, RFacebook::Rails::SessionStoreExtensions)
CGI::Session::MemCacheStore.send(:include, RFacebook::Rails::SessionStoreExtensions) if defined?(CGI::Session::MemCacheStore)
