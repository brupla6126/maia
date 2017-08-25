# class Library
class Library
  def self.get_container_path(library, container)
    # Log[self.class].debug { "library: #{library}" }
    # Log[self.class].debug { "container: #{container}" }

    File.join(library, container)
  end

  def self.get_file_path(library, container, file)
    # Log[self.class].debug { "library: #{library}" }
    # Log[self.class].debug { "container: #{container}" }
    # Log[self.class].debug { "file: #{file}" }

    File.join(library, container, file)
  end

  def self.search(directory, recursive = false, &block)
    # select subdirectories
    subdirectories = Dir[File.join(directory, '*')].select { |file| File.directory? file }

    # block returns directories to follow
    follow = yield(directory, subdirectories) if block
    follow ||= []

    follow.each { |dir| search(dir, recursive, &block) } if recursive
  end
end
