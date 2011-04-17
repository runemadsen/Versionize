class UsersController < ApplicationController
  
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
  
  def show
    # Public facing user profiles
  end

  def edit
    #  Edit logged in user
    @user = @current_user
  end
  
  def new
    @user = User.new
    render :layout => "front"
  end
  
  def create
    
    invite = Invite.where(:code => params[:code], :to_email => params[:user][:email]).first
    
    if !invite.nil? || params[:code] == "ITPINVITE"
      begin
        @user = User.create(params[:user])
        if @user.id.nil?
          raise Exception, "Your passwords doesn't match"
        end
        UserSession.create(:email => @user.email, :password => @user.password, :remember_me => true)
        flash[:notice] = "Account created!"
        redirect_to '/'
      rescue Exception => e 
        flash[:error] = "#{e}"
        redirect_to new_user_path
      end
    else
      flash[:error] = "You have entered a wrong invitation code, or you code doesn't match your email adress"
      redirect_to new_user_path
    end
    
  end
  
  def update
    @user = @current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to user_path(@user)
    else
      render :action => :edit
    end
  end
end