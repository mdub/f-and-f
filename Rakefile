require "google/cloud/vision"
require "yaml"

ENV["GOOGLE_CLOUD_PROJECT"] ||= "faith-and-farming"
ENV["GOOGLE_CLOUD_KEYFILE"] ||= "tmp/faith-and-farming-18907b6ec564.json"

def ocr(file)
  $vision ||= Google::Cloud::Vision.new
  $vision.image(file).document
end

page_images = FileList.new("book/page-*.png")
page_images.each do |page_image|
  page_data_file = page_image.sub("book", "data").sub(".png", ".yml")
  task "default" => page_data_file
  file page_data_file => page_image do
    puts "OCR-ing #{page_image}"
    doc = ocr(page_image)
    File.write(page_data_file, YAML.dump(doc.to_h))
  end
end
