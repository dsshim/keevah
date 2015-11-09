module DefaultImages
  def self.random

    Dir.glob("app/assets/images/*.jpg")
      .map{|image| image.split("/").last}.sample
  end
end
