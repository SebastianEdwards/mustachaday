require 'RMagick'
require 'securerandom'

class GIFifier
  def initialize(base64_encoded_images, storage)
    @storage = storage
    base64_encoded_images.each do |image|
      images << Magick::Image.read_inline(image)[0]
    end
  end

  def filename
    @filename ||= generate_filename
  end

  def generate!
    output_path = File.join('/', 'tmp', filename)
    images.write(output_path)
    @storage.store(filename, open(output_path))

    self
  end

  def url
    @storage.url + '/' + filename
  end

  private
  def generate_filename
    SecureRandom.hex(16) + '.gif'
  end

  def images
    @images ||= Magick::ImageList.new
  end
end
