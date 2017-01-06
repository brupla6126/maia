Dir.glob(File.join(File.dirname(__FILE__), 'araignee/architecture/**/*.rb')).each do |file|
  require file.to_s
end

include Araignee::Architecture
