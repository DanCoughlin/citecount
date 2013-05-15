class ArticlesController < ApplicationController
  require 'numbers_in_words'
  require 'numbers_in_words/duck_punch'
  # GET /articles
  # GET /articles.json
  def index
    # get the source articles
    @total = Article.where(:reference_type => "source").count
    @art = Article.order("journal").where(:reference_type => "source").page(params[:page]).per(25)
    @articles = {}
    # create a hash of citation articles for each source article
    @art.each do |a|
      if @articles.has_key?(a.journal) == false
        @articles[a.journal] = {} 
        @articles[a.journal][:count] = 0
      end
      @articles[a.journal][:count] += 1
      # find all the citation articles for this article
      citation = Article.find(:all, :conditions=> {:id => a.citation_ids, :reference_type => 'citation'})

      # looping over the list of citations for this article
      citation.each do |c|
        if c.journal.blank? == false
          if @articles[a.journal].has_key?(c.journal) == false
            @articles[a.journal][c.journal] = 0
          end
          @articles[a.journal][c.journal] += 1
        end
      end
    end
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    @article = Article.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @article }
    end
  end

  # GET /articles/new
  # GET /articles/new.json
  def new
    @article = Article.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @article }
    end
  end

  # GET /articles/1/edit
  def edit
    @article = Article.find(params[:id])
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(params[:article])

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render json: @article, status: :created, location: @article }
      else
        format.html { render action: "new" }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /articles/1
  # PUT /articles/1.json
  def update
    @article = Article.find(params[:id])

    respond_to do |format|
      if @article.update_attributes(params[:article])
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    respond_to do |format|
      format.html { redirect_to articles_url }
      format.json { head :no_content }
    end
  end
end
