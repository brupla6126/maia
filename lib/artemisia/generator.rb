require 'fileutils'

module Definition
  class Generator
    def initialize(template_path)
      @template_path = template_path
    end

    def clean
      #      Dir.rm_r @template_path
    end

    def write(path, filename, json)
      write_file(File.join(@template_path, path), filename, json)
    end

    private

    def write_file(path, filename, data)
      FileUtils.mkdir_p(path)

      file = File.join(path, filename)
      puts "file: #{file}"
      File.open(file, 'w') do |f|
        f.write(data)
      end
    end
  end
end
