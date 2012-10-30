class LocalStore
  def initialize(output_dir, web_dir)
    @output_dir = output_dir
    @web_dir = web_dir
  end

  def store(path, data)
    output_path = File.join(@output_dir, path)
    open(output_path, 'w') {|f| f.write(data.read) }
  end

  def url
    "/#{@web_dir}"
  end
end
