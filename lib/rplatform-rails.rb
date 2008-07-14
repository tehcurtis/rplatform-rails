require 'rplatform'
# load Facebook YAML configuration file (credit: Evan Weaver)
::NETWORKS = {}
if defined?(RAILS_ROOT) #find out something more elegant instead of this check...
  yamlFile = YAML.load_file("#{RAILS_ROOT}/config/facebook.yml")


  if File.exist?(yamlFile)
    if yamlFile[RAILS_ENV]
      NETWORKS.merge!(yamlFile[RAILS_ENV])
    else
      raise StandardError, "config/facebook.yml exists, but doesn't have a configuration for RAILS_ENV=#{RAILS_ENV}."
    end
  else
    raise StandardError, "config/facebook.yml does not exist."
  end
end

module RPlatform::Rails
  VERSION = '0.0.2'
  
  def self.fix_path(path)
    # check to ensure that the path is relative
    if matchData = /(\w+)(\:\/\/)([\w0-9\.]+)([\:0-9]*)(.*)/.match(path)
      relativePath = matchData.captures[4]
      RAILS_DEFAULT_LOGGER.info "** RFACEBOOK INFO: It looks like you used a full URL '#{path}' in facebook.yml.  RFacebook expected a relative path and has automatically converted this URL to '#{relativePath}'."
      path = relativePath
    end
  
    # check for the proper leading/trailing slashes
    if (path and path.size>0)
      # force leading slash, then trailing slash
      path = "/#{path}" unless path.starts_with?("/")
      path = "#{path}/" unless path.reverse.starts_with?("/")
    end
  
    return path
  end
end


NETWORKS.values.each do |network|
  network["canvas_path"] = RPlatform::Rails::fix_path(network["canvas_path"])
  network["callback_path"] = RPlatform::Rails::fix_path(network["callback_path"])
end