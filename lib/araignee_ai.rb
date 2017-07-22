Dir.glob(File.join(File.dirname(__FILE__), 'araignee/ai/**/*.rb')).each do |file|
  require file.to_s
end
