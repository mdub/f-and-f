require "google/cloud/vision"

ENV["GOOGLE_CLOUD_PROJECT"] ||= "faith-and-farming"
ENV["GOOGLE_CLOUD_KEYFILE"] ||= "tmp/faith-and-farming-18907b6ec564.json"

vision = Google::Cloud::Vision.new
image = vision.image "book/page-585.png"
doc = image.document
