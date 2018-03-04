require "google/cloud/vision"
require "yaml"

ENV["GOOGLE_CLOUD_PROJECT"] ||= "faith-and-farming"
ENV["GOOGLE_CLOUD_KEYFILE"] ||= "tmp/faith-and-farming-18907b6ec564.json"

def ocr(file)
  $vision ||= Google::Cloud::Vision.new
  $vision.image(file).document
end

namespace "book" do

  desc "OCR book pages"
  task "ocr"

  page_images = FileList.new("book/page-*.png")
  page_images.each do |page_image|
    page_data_file = page_image.sub("book", "data").sub(".png", ".yml")
    task "ocr" => page_data_file
    file page_data_file => page_image do
      puts "OCR-ing #{page_image}"
      doc = ocr(page_image)
      File.write(page_data_file, YAML.dump(doc.to_h))
    end
  end

end

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task "default" => "spec"

task "renumber" do
  ["book/page-%03d.png", "data/page-%03d.yml"].each do |fmt|
    719.downto(0) do |n|
      old_name = fmt % n
      new_name = fmt % (n + 1)
      mv old_name, new_name
    end
  end
end