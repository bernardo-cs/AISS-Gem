require 'spec_helper'

describe Aiss::ByteUtils do
	
	before :each do
		@input_path = './files/testes/test.zip'
		@output_path = './files/testes/mail_body_from_string.zip'
		@byte_utils = Aiss::ByteUtils.new
	end

	describe "#convert_file_string" do
		it "should receive a path to a file and return it as a string" do
			@byte_utils.convert_file_string(@input_path).should be_a_kind_of(String)
		end
	end

	describe "#convert_string_file" do
		before :each do 
			File.delete(@output_path) if File.exists?(@output_path)
		end

		it "should receive an input_string and convert it to a file" do
			@byte_utils.convert_string_file("ola adeus lalal", @output_path)
			File.exists?(@output_path).should be_true
		end

		it "should convert a previously converted file to the same file " do
			create_string = @byte_utils.convert_file_string(@input_path)
			@byte_utils.convert_string_file(create_string, @output_path)
			File.size(@input_path).should be_close(File.size(@output_path)-5, File.size(@output_path)+5)
		end

		after :each do
			File.delete(@output_path) if File.exists?(@output_path)
		end
	end

	context "should be able to gracefully cyoher/base/string to file and back" do
		describe "#file_to_string_cypher_base64" do
			it "should receive a file and convert it to a string" do
				@byte_utils.file_to_string_cypher_base64(@input_path).should be_a_kind_of(String)
			end

			it "should receive a file and convert it to base64 decodablestring" do
				Base64.decode64(@byte_utils.file_to_string_cypher_base64(@input_path)).should be_a_kind_of(String)
			end
		end

		describe "#base64_decypher_string_to_file" do
			before :each do
				File.delete(@output_path) if File.exists?(@output_path)
			end

			it "should receice a base64 string and decode it into a file" do
				@byte_utils.base64_decypher_string_to_file(Base64.encode64("ola adeus"),@output_path)
				File.exists?(@output_path).should be_true
			end

			it "should be able to recreate a file that was previously converted to base64_string and cyphered" do
				fast_zip = Aiss::FastZip.new
				fast_zip.quick_zip  @output_path, 'body_text.txt', '/Users/bersimoes/Documents/Coding/aiss/files/testes'
				string64 = @byte_utils.file_to_string_cypher_base64(@input_path)

				@byte_utils.base64_decypher_string_to_file(string64, @output_path)
				File.read(@input_path).should eql(File.read(@output_path))
			end

			after :each do 
				File.delete(@output_path) if File.exists?(@output_path)
			end
		end
	end
end