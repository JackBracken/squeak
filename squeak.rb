require 'bundler/setup'
require 'sinatra'
require 'haml'

require_relative 'models/init'

helpers do
  def title
    if @title
      "Jack Bracken &raquo; #{@title}"
    else
      "Jack Bracken"
    end
  end

  def pretty_date(time)
    time.strftime("%^b %e, %Y - %R")
  end

  def post_show_page?
    request.path_info =~ /\/posts\/\d+$/
  end

  def delete_post_button(post_id)
    haml :_delete_post_button, locals: { post_id: post_id}
  end
end

get '/' do
  @posts = Post.order("created_at DESC").limit(10)
  haml :index
end

get "/posts/new" do
  @title = "New Post"
  @post = Post.new
  haml :newpost
end

post "/posts" do
  @post = Post.new(params[:post])
  if @post.save
    redirect "posts/#{@post.id}"
  else
    haml :newpost
  end
end

get "/posts/:id" do
  @post = Post.find(params[:id])
  @title = @post.title
  haml :post
end

get "/posts/:id/edit" do
  @post = Post.find(params[:id])
  @title = "Edit Form"
  haml :edit_post
end

put "/posts/:id" do
  @post = Post.find(params[:id])
  if @post.update_attributes(params[:post])
    redirect "/posts/#{@post.id}"
  else
    haml :edit_post
  end
end

delete "/posts/:id" do
  @post = Post.find(params[:id]).destroy
  redirect "/"
end