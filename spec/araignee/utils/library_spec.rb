require 'araignee/utils/library'

include Araignee, Araignee::Utils

library = File.join File.dirname(__FILE__), 'data'

RSpec.configure do |config|
  # puts "library: #{library}"
  config.before(:suite) do
    # puts "creating directories"
    system 'mkdir', '-p', "#{library}/a/b/c"
    system 'mkdir', '-p', "#{library}/a/b/recursos"
    system 'mkdir', '-p', "#{library}/a/b/reportes"
    system 'mkdir', '-p', "#{library}/a/b/vinculos"
    system 'touch', "#{library}/a/abc.txt"
    system 'ls', '-l', "#{library}/a"
  end
  config.after(:suite) do
    # puts "deleting directories"
    system 'rm', '-rf', library
  end
end

RSpec.describe Library do
  describe '#get_container_path' do
    it 'returns path valid' do
      host = '200/123/123/12'
      ruta = Library.get_container_path(library, host)
      expect(ruta).to eq("#{library}/200/123/123/12")
    end
  end

  describe '#get_file_path' do
    it 'returns file path valid' do
      host = 've/info/avn/www'
      path = Library.get_file_path(library, host, 'recursos/651210c3bce306b032752b3841210525.zip')

      expect(path).to eq("#{library}/ve/info/avn/www/recursos/651210c3bce306b032752b3841210525.zip")
    end
  end

  describe '#search' do
    context 'search files not recursively' do
      it 'returns children directories' do
        Library.search "#{library}/a", false do |_directory, subdirectories|
          # puts "#{directory} subdirectories: #{subdirectories}"

          expect(subdirectories).to include("#{library}/a/b")
          expect(subdirectories).not_to include("#{library}/a/b/c")
          expect(subdirectories).not_to include("#{library}/a/c")
          expect(subdirectories).not_to include("#{library}/a/abc.txt")

          subdirectories
        end
      end
    end

    context 'search files recursively' do
      it 'returns children directories of /a' do
        Library.search "#{library}/a", true do |directory, subdirectories|
          # puts "#{directory} subdirectories: #{subdirectories}"
          if directory == "#{library}/a"
            expect(subdirectories).to include("#{library}/a/b")
            expect(subdirectories).not_to include("#{library}/a/b/c")
            expect(subdirectories).not_to include("#{library}/a/c")
            expect(subdirectories).not_to include("#{library}/a/abc.txt")
          end
          subdirectories.reject { |dir| %w(recursos reportes vinculos).include? dir.split(File::SEPARATOR).last }
        end
      end

      it 'should have found children directories' do
        Library.search "#{library}/a", true do |directory, subdirectories|
          if directory == "#{library}/a/b"
            expect(subdirectories).not_to include("#{library}/a/b")
            expect(subdirectories).to include("#{library}/a/b/c")
            expect(subdirectories).to include("#{library}/a/b/recursos")
            expect(subdirectories).to include("#{library}/a/b/reportes")
            expect(subdirectories).to include("#{library}/a/b/vinculos")
            expect(subdirectories).not_to include("#{library}/a/c")
          end
          subdirectories.reject { |dir| %w(recursos reportes vinculos).include? dir.split(File::SEPARATOR).last }
        end
      end

      it 'should not search excluded directories' do
        Library.search "#{library}/a", true do |directory, subdirectories|
          unless ["#{library}/a", "#{library}/a/b"].include? directory
            expect(directory).not_to eq("#{library}/a/b/recursos")
            expect(directory).not_to eq("#{library}/a/b/reportes")
            expect(directory).not_to eq("#{library}/a/b/vinculos")
          end
          subdirectories.reject { |dir| %w(recursos reportes vinculos).include? dir.split(File::SEPARATOR).last }
        end
      end
    end
  end
end
