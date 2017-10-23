Dir.glob(File.join(File.dirname(__FILE__), 'araignee/ai/core/**/*.rb')).each do |file|
  require file.to_s
end
