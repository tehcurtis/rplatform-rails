require 'rplatform'
require 'rplatform_rails/controller_extensions'
require 'rplatform_rails/model_extensions'
require 'rplatform_rails/session_extensions'
require 'rplatform_rails/status_manager'
require 'rplatform_rails/view_extensions'

# inject methods to Rails MVC classes
ActionView::Base.send(:include, RPlatform::Rails::ViewExtensions)
ActionController::Base.send(:include, RPlatform::Rails::ControllerExtensions)
ActiveRecord::Base.send(:include, RPlatform::Rails::ModelExtensions)

# inject methods to Rails session management classes
CGI::Session.send(:include, RPlatform::Rails::SessionExtensions)

# TODO: document SessionStoreExtensions as API so that anyone can patch their own custom session container in addition to these
CGI::Session::PStore.send(:include, RPlatform::Rails::SessionStoreExtensions)
CGI::Session::ActiveRecordStore.send(:include, RPlatform::Rails::SessionStoreExtensions)
CGI::Session::DRbStore.send(:include, RPlatform::Rails::SessionStoreExtensions)
CGI::Session::FileStore.send(:include, RPlatform::Rails::SessionStoreExtensions)
CGI::Session::MemoryStore.send(:include, RPlatform::Rails::SessionStoreExtensions)
CGI::Session::MemCacheStore.send(:include, RPlatform::Rails::SessionStoreExtensions) if defined?(CGI::Session::MemCacheStore)
