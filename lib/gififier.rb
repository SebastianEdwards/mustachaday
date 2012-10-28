require 'rmagick'
require 'securerandom'

class GIFifier
  def initialize(base64_encoded_images, output_dir)
    @output_dir = output_dir
    base64_encoded_images.each do |image|
      images << Magick::Image.read_inline(image)[0]
    end
  end

  def filename
    @filename ||= generate_filename
  end

  def generate!
    output_path = File.join(@output_dir, filename)
    images.write(output_path)
  end

  private
  def generate_filename
    SecureRandom.hex(16) + '.gif'
  end

  def images
    @images ||= Magick::ImageList.new
  end
end
