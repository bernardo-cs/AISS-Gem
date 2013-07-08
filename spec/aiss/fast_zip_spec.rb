require 'spec_helper'

describe Aiss::FastZip do

	before :each do
			path_to_file = "./files/testes"
			file_name = "mail_body.txt"
			@file_text = File.read(path_to_file + "/" + file_name)
	    @zip = Aiss::FastZip.new path_to_file, file_name
	end

	describe "#new" do
	    it "takes 2 parameters and returns a Zip object" do
	        @zip.should be_an_instance_of Aiss::FastZip
	    end

	    it "shoulb be able to be initialized without parameters" do
	    	Aiss::FastZip.new.should be_an_instance_of Aiss::FastZip
	    end
	end

	describe "#zip" do
		it "receives .txt file and returnes it ziped" do
			File.delete(@zip.archive_path) if File.exists?(@zip.archive_path)
			@zip.zip
			File.exists?(@zip.archive_path).should be_true
			File.delete(@zip.archive_path)
		end
	end

	describe "#unzip" do
		it "unzips the a file zipped with #zip, asserts if the content is the same as before" do
			File.delete(@zip.archive_path) if File.exists?(@zip.archive_path)
			@zip.zip
			@zip.unzip
			File.read(@zip.unziped_file_path).should eql @file_text

			File.delete(@zip.archive_path)
			File.delete(@zip.unziped_file_path)
		end
	end

end