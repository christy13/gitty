class IssuesController < ApplicationController
  # GET /issues
  # GET /issues.json
  def index
    #@issues = Repository.find(params[:repo_name]).issues
    @issues = Issue.all
    Rails.logger.debug "Index issues: #{@issues.inspect}"

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @issues }
    end
  end

  # GET /issues/1
  # GET /issues/1.json
  def show
    @issue = Issue.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @issue }
    end
  end

  # GET /issues/new
  # GET /issues/new.json
  def new
    @profile = Profile.where(:name => params[:profile_name]).first
    @repository = @profile.repositories.where(:name => params[:repo_name]).first

    @issue = Issue.new
    @issue.repository = @repository

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @issue }
    end
  end

  # GET /issues/1/edit
  def edit
    @issue = Issue.find(params[:id])
  end

  # POST /issues
  # POST /issues.json
  def create
    @author = current_user.profile
    @profile = Profile.where(:name => params[:profile_name]).first
    @repository = @profile.repositories.where(:name => params[:repo_name]).first
    
    @issue = Issue.new params[:issue]
    @issue.repository = @repository
    @issue.author = @author

    respond_to do |format|
      if @issue.save
        @issue.publish_creation
        FeedSubscription.add @author, @issue
        
        format.html { redirect_to profile_repository_issues_path(@profile, 
            @repository),
            notice: 'Issue was successfully created.' }
        format.json { render json: @issue, status: :created, location: @issue }
      else
        format.html { render action: "new" }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /issues/1
  # PUT /issues/1.json
  def update
    @issue = Issue.find(params[:id])

    respond_to do |format|
      if @issue.update_attributes(params[:issue])
        format.html { redirect_to profile_repository_issues_path(@profile, 
            @repository), 
              notice: 'Issue was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /issues/1
  # DELETE /issues/1.json
  def destroy
    @issue = Issue.find(params[:id])
    @issue.destroy
    @issue.publish_deletion current_user.profile

    respond_to do |format|
      format.html { redirect_to profile_repository_issues_path(@profile, 
            @repository) }
      format.json { head :no_content }
    end
  end
end
