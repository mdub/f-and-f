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

  page_images = FileList.new("book/as-images/page-*.png")
  page_images.each do |page_image|
    page_data_file = page_image.sub("book/as-images", "book/gcv-data").sub(".png", ".yml")
    task "ocr" => page_data_file
    file page_data_file => page_image do
      puts "OCR-ing #{page_image}"
      doc = ocr(page_image)
      File.write(page_data_file, YAML.dump(doc.to_h))
    end
  end

end

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new("spec:fast") do |t|
  t.rspec_opts = "--tag ~slow"
end

RSpec::Core::RakeTask.new("spec:slow") do |t|
  t.rspec_opts = "--tag slow"
end

task "spec" => ["spec:fast", "spec:slow"]
task "default" => "spec"

directory "outputs"

task "problems" => "outputs" do
  sh "scripts/show problems -sd > outputs/problems.txt"
end

task "generate" => "problems"

task "gedcom" => "outputs" do
  sh "scripts/show gedcom > outputs/f-and-f.ged"
end

task "generate" => "gedcom"

task "names" => "outputs" do
  sh "scripts/show names -pde > outputs/names.txt"
end

task "generate" => "names"

task "families" => "outputs" do
  sh "scripts/show families -sd > outputs/families.txt"
end

task "generate" => "families"
