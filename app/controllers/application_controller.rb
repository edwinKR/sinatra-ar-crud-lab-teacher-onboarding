
require_relative '../../config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get '/' do
  end

  get '/articles' do
    @articles = Article.all
    erb :index
  end

  get '/articles/new' do 
    erb :new
  end

  # Create an action that responds to a POST request.
  # Remember, this Create action is after the submit button clicked from the new.erb view.
  post '/articles' do
    # CRUD action - CREATE
    # Create a new article based on the params from the form.
    # Also, save it to the database.
    puts "----------"
    puts params.inspect
    @article = Article.create(
      :title => params[:title],
      :content => params[:content]
    )
    puts "==============="
    puts @article.inspect

    # Now that the article item is created, finally redirect to the 'show' page.
    # In other words, redirect to another action which triggers the rendering of the 'show.erb'
    redirect to "/articles/#{@article.id}"
  end

  # The show action after the post request above. You are redirected to here.
  # This is a dynamic URL, meaning you can get access to the ID of the article via the 'params' hash.
  get '/articles/:id' do
    puts "<><><><><>"
    puts params[:id].inspect

    @article = Article.find_by_id(params[:id])
    erb :show
  end

  get '/articles/:id/edit' do
    @article = Article.find_by_id(params[:id])
    erb :edit
  end

  patch '/articles/:id' do
    puts "============="
    puts params
    @article = Article.find_by_id(params[:id])
    
    @article.title = params[:article_title]
    @article.content = params[:article_content]
    @article.save

    redirect to "/articles/#{@article.id}"
  end

  delete '/articles/:id/delete' do
    @article = Article.find_by_id(params[:id])
    @article.delete

    redirect to "/articles"
  end
end
