require 'zip/zip'

module Aiss

class FastZip
    attr_accessor :input_folder, :file_name, :archive_name, :archive_path, :unziped_file_path, :unziped_path
	    
	    def initialize *args
	    	case args.size
	    	when 2
	    		init_folders *args
	    	when 0
	    	else
	    		error
	    	end
	    end

	    def init_folders input_folder,file_name
	        @input_folder = input_folder
	        @file_name = file_name

	        @archive_name = file_name.sub(".txt",".zip")
	        @archive_path = @input_folder + "/" + @archive_name

	        @unziped_folder = "unziped"
	        @unziped_path = input_folder + "/" + @unziped_folder
	        @unziped_file_path = @unziped_path + "/" + @file_name
	    end
	    
	    def zip
	    		File.delete(@archive_path) if File.exists?(@archive_path)
	    		Zip::ZipFile.open(@archive_path, Zip::ZipFile::CREATE) do |zipfile|
			    # Two arguments:
			    # - The name of the file as it will appear in the archive
			    # - The original file, including the path to find it
			    zipfile.add(@file_name, @input_folder + '/' + @file_name)
				end
	    end

			def unzip 
			  Zip::ZipFile.open(@archive_path) { |zip_file|
			   zip_file.each { |f|
			     f_path=@unziped_path + "/" + f.name
			     FileUtils.mkdir_p(File.dirname(f_path))
			     zip_file.extract(f, f_path) unless File.exist?(f_path)
			   }
			  }
			end

			# archive_path /bla/bla/ficheiro_zipado.zip
			# file_name    nome_do_ficheiro.txt
			# input_folder caminho/ate/ao/{nome_do_ficheiro.txt}
			def quick_zip archive_path, file_name, input_folder
					File.delete(archive_path) if File.exists?(archive_path)
	    		Zip::ZipFile.open(archive_path, Zip::ZipFile::CREATE) do |zipfile|
			    # Two arguments:
			    # - The name of the file as it will appear in the archive
			    # - The original file, including the path to find it
			    zipfile.add(file_name, input_folder + '/' + file_name)
				end
			end

			# archive_path /bla/bla/ficheiro_zipado.zip
			# unziped_path /bla/bla/ficheiros_descompactados
			def quick_unzip archive_path, unziped_path
				Zip::ZipFile.open(archive_path) { |zip_file|
			   zip_file.each { |f|
			     f_path=unziped_path + "/" + f.name
			     FileUtils.mkdir_p(File.dirname(f_path))
			     zip_file.extract(f, f_path) unless File.exist?(f_path)
			   }
			  }
			end

end

end