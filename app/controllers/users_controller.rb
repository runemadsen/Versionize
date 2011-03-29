class UsersController < ApplicationController
  
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
  
  def new
    @user = User.new
  end
  
  def create
    
    invite = Invite.where(:code => params[:code], :to_email => params[:user][:email]).first
    
    if invite.nil?
      flash[:error] = "You have entered a wrong invitation code, or you code doesn't match your email adress"
      redirect_to new_user_path
    else
      begin
        @user = User.new(params[:user])
        @user.save
        flash[:notice] = "Account registered! Please log in!"
        redirect_to '/'
      rescue Exception => e 
        flash[:notice] = "Something went wrong: #{e}"
        redirect_to new_user_path
      end
    end
  end
  
  def show
    @user = @current_user
  end

  def edit
    @user = @current_user
  end
  
  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to user_path(@user)
    else
      render :action => :edit
    end
  end
end