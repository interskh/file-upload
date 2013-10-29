require 'rubygems'
require 'sinatra'
require 'haml'


class App < Sinatra::Application

  # Handle GET-request (Show the upload form)
  get "/upload" do
    haml :upload
  end

  # Handle POST-request (Receive and save the uploaded file)
  post "/upload" do
    File.open('uploads/' + params['myfile'][:filename], "w") do |f|
      f.write(params['myfile'][:tempfile].read)
    end
    return "The file was successfully uploaded!"
  end

  get "/uploads/:file" do
    send_file(File.join('uploads', params[:file]), :disposition => 'inline')
  end

  get "/" do
    Dir.entries('uploads/').select{|e| e !~ /^\./}.map do |e|
      "<p><a href='/uploads/#{e}'>#{e}</a></p>"
    end
  end

end
