['view_extensions', 'controller_extensions', 'model_extensions', 'session_extensions'].each do |l| 
  require File.join(File.dirname(__FILE__), l)
end

NETWORKS = {}

# parse for full URLs in facebook.yml (multiple people have made this mistake)
module RPlatform::Rails
  VERSION = '0.0.1'
  
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