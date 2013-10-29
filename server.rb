require 'rubygems'
require 'sinatra'
require 'haml'


class App < Sinatra::Application

  upload_path = 'uploads'

  # Handle GET-request (Show the upload form)
  get "/upload" do
    haml :upload
  end

  # Handle POST-request (Receive and save the uploaded file)
  post "/upload" do
    dirname = params['folder'].empty? ? "default" : params['folder']
    dirpath = File.join upload_path, dirname
    Dir.mkdir dirpath unless File.directory? dirpath
    File.open(File.join(dirpath, params['myfile'][:filename]), "w") do |f|
      f.write(params['myfile'][:tempfile].read)
    end
    return "The file was successfully uploaded!"
  end

  get "/*" do
    dir = File.join params[:splat]
    path = File.join upload_path, dir
    logger.info path
    if File.exist? path and not File.directory? path
      send_file path, :disposition => 'inline'
    else
      Dir.entries(path).select{|e| e !~ /^\./}.map do |e|
        "<p><a href='#{File.join(dir,e)}'>#{e}</a></p>"
      end
    end
  end

end
