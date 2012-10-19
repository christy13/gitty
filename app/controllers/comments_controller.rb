class CommentsController < ApplicationController
  # GET /comments
  # GET /comments.json
  def index
    @profile = Profile.where(:name => params[:profile_name]).first!
    @repository = @profile.repositories.where(:name => params[:repo_name]).
                           first!
    @issue = @repository.issues.where(:number => params[:issue_number]).
                         first!
    @comments = @issue.comments

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @comments }
    end
  end

  # GET /comments/new
  # GET /comments/new.json
  def new
    @comment = Comment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:comment_id])
  end

  # POST /comments
  # POST /comments.json
  def create
    @profile = Profile.where(:name => params[:profile_name]).first!
    @repository = @profile.repositories.where(:name => params[:repo_name]).
                           first!
    @issue = @repository.issues.where(:number => params[:issue_number]).
                         first!
    @comment = Comment.new(params[:comment])
    @comment.commentable = @issue

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment, 
            notice: 'Comment was successfully created.' }
        format.json { render json: @comment, status: :created, 
            location: @comment }
      else
        format.html { render action: "new" }
        format.json { render json: @comment.errors, 
            status: :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.json
  def update
    @profile = Profile.where(:name => params[:profile_name]).first!
    @repository = @profile.repositories.where(:name => params[:repo_name]).
                           first!
    @issue = @repository.issues.where(:number => params[:issue_number]).
                         first!
    @comment = Comment.find(params[:comment_id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment = Comment.find(params[:comment_id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to comments_url }
      format.json { head :no_content }
    end
  end
end
