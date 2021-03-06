require 'bundler/setup'
require 'sinatra'
require 'haml'
require 'redcarpet'

configure :development do
  require "better_errors"
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path("..", __FILE__)
end

require_relative 'models/init'

class Squeak < Sinatra::Base

  helpers do
  def title
    if @title
      "Jack Bracken &raquo; #{@title}"
    else
      "Jack Bracken"
    end
  end

  def pretty_date(time)
    time.strftime("%B %e, %Y")
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
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, 
                              :autolink => true, 
                              :space_after_headers => true, 
                              :underline => true,
                              :no_intra_emphasis => true,
                              :fenced_code_blocks => true
                            )
    @post.body = markdown.render(@post.body)
    
    if @post.save
      redirect "posts/#{@post.id}/"
    else
      haml :newpost
    end
  end

  get "/posts/:id/?*" do
    post = Post.find(params[:id])
    haml :post, locals: {post: post}
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

end