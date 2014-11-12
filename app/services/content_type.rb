module ContentType
  def of(file)
    Cocaine::CommandLine.new("file -b --mime", ":file").
      run(file: file.path).split('; ').first
  end

  extend self
end
