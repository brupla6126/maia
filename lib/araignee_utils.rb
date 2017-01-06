Dir.glob(File.join(File.dirname(__FILE__), 'araignee/utils/**/*.rb')).each do |file|
  require file.to_s
end

include Araignee::Utils
