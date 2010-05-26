class PostsController < ApplicationController
  def add_comment
    # This should be done RESTfully
    @comment = Comment.new
    @comment.body = params[:body]
    @comment.post = Post.find(params[:post_id])
    @comment.user = User.find(params[:user_id])
        
    respond_to do |format|
      if @comment.save
        flash[:notice] = 'Comment was successfully created.'
        format.html { redirect_to(@comment.post) }
        format.xml  { render :xml => @comment.post, :status => :created, :location => @comment.post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @comment.post.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def rate
    @post = Post.find(params[:id])
    @post.rate(params[:stars], current_user, params[:dimension])
    id = "ajaxful-rating-post-#{@post.id}"
    render :update do |page|
    page.replace_html id, ratings_for(@post, :wrap => false, :dimension => params[:dimension])
    page.visual_effect :highlight, id
    end
  end
  
  def index
    # TODO: Support:
      # View by Post Type (obv) post_type_id=num
      # Tag tag=string
      # Search search_term=string

      # Paginate page=num
      # Sort by | sort_by=["date", "rating", "author"] AJAX
      
    @post_type = PostType.find(params[:post_type_id])    
    @controller_name = @post_type.name.gsub(" ","_").downcase.pluralize
    @posts = @post_type.posts.paginate(:page => params[:page], :order => "id")
    @tags = @post_type.posts.tag_counts
    @my_posts = Post.find_all_by_user_and_post_type(@current_user.login, @post_type.name).last(5)
    
    # Todo: Order these in some useful way
    # Todo: If no id provided, redirect to community
    
    respond_to do |format|
      format.html # by_post_type.html.erb
      format.xml  { render :xml => @posts }
    end
  end
  
  #/decklists/tags/foo = /posts/tags?post_type_id=1?tag=foo
  def tags
    @post_type = PostType.find(params[:post_type_id])
    @controller_name = @post_type.name.gsub(" ","_").downcase.pluralize
    @tag_name = params[:tag] 
    @posts = (Post.find_tagged_with(@tag_name) & @post_type.posts).paginate(:page => params[:page], :order => "id")
    @tags = @post_type.posts.tag_counts
    @my_posts = (Post.find_tagged_with(@tag_name) & Post.find_all_by_user_and_post_type(@current_user.login, @post_type.name)).last(5)
    
    # Todo: Order these in some useful way
    # Todo: If no id provided, redirect to community
    
    respond_to do |format|
      format.html # by_post_type.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  def show
    @post = Post.find(params[:id])
    @post_type = @post.post_type.name
    @controller_name = @post_type.gsub(" ","_").downcase.pluralize
    if @controller_name = "decklists"
      @deck = @post.deck
      @main_deck_cards_by_type = @deck.get_cards_by_card_type
      @side_deck_cards = @deck.get_side_deck_cards
      @sixtyfirst_cards = @deck.get_sixtyfirst_cards
    end
    
    debugger

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @post = Post.new(params[:post])
    @post.post_type_id = params[:post_type_id]
    @post_type = PostType.find(params[:post_type_id]).name
    @post.user_id = @current_user.id
    @post_types = PostType.all
    @decks = @current_user.private_decks
  
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
    @controller_name = @post.post_type.controller_name
    
    respond_to do |format|
      format.html # edit.html.erb
    end
  end

  # ??? /posts/create
  def create
    @post = Post.new(params[:post])
    @controller_name = @post.post_type.controller_name
    
    respond_to do |format|
      if @post.save
        flash[:notice] = 'Post was successfully created.'
        format.html { redirect_back_or_default("/community") }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        format.html { render :controller => @controller_name, :action => "new" }
        format.xml  { render :xml => @card.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    @post = Post.find(params[:id])
    @controller_name = @post.post_type.name.gsub(" ","_").downcase.pluralize

    respond_to do |format|
      if @post.update_attributes(params[:post])
        flash[:notice] = 'Post was successfully updated.'
        format.html { redirect_to :controller => @controller_name,
                                  :action => "show",
                                  :id => @post.id }
        format.xml  { head :ok }
      else
        format.html { render :controller => @controller_name, 
                             :action => "edit" }
        format.xml  { render :xml => @post.errors,
                          :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @post = Post.find(params[:id])
    @controller_name = @post.post_type.name.gsub(" ","_").downcase.pluralize
    @post.destroy

    respond_to do |format|
      format.html { redirect_to :controller => @controller_name,
                                :action => "show",
                                :id => @post.id }
      format.xml  { head :ok }
    end
  end
end