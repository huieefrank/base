# == Schema Information
# Schema version: 20100602032230
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe User do
  before(:each) do
    @valid = {
      :name => "value for name",
      :email => "value@email.com",
      :password =>"foobar",
      :password_confirmation =>"foobar"
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@valid)
  end
  
  it "should require a name" do
  	no_name_user = User.new(@valid.merge(:name =>""))
  	no_name_user.should_not be_valid
  end
  
  it "should require a email " do
  	no_email_user =User.new(@valid.merge(:email=>""))  
  end
  
  
  it "should reject a long name  " do
  	long_name = "a" *51
  	long_name_user = User.new(@valid.merge(:name=>long_name))
  	long_name_user.should_not be_valid
  end
  
  
  it "should accept valid email address " do
  	addresses = %w[frank@sina.com THE_USER@gmail.com first.last@jp.org]
  	addresses.each do |address|
  		valid_email_user =User.new(@valid.merge(:email =>address))
  		valid_email_user.should be_valid
  	end
  end
  
  it "should reject  invalid address " do
  	addresses =%w[frank@sina,com The_user_foo.org example@jp.]
  	addresses.each do |address|
  		invalid_email_user = User.new(@valid.merge(:email =>address)) 
  		invalid_email_user.should_not be_valid
  	end
  end  		
  
  it "should reject duplicat email address " do
  	User.create(@valid)
  	user_with_duplicat_email = User.new(@valid)
  	user_with_duplicat_email.should_not be_valid
  end
  
  it "should reject email adrress identical up to case" do
  	upcased_email = @valid[:email].upcase
  	User.create!(@valid.merge(:email =>upcased_email))
  	user_with_duplicat_email = User.new(@valid)
  	user_with_duplicat_email.should_not be_valid
  end
  
  
  
  
  
  describe "password validations" do
  	
  	it "should require a password " do
  		user_not_with_password = User.new(@valid.merge(:password =>"",
  		                                               :password_confirmation =>""))
  		user_not_with_password.should_not be_valid
  	end
  	
  	
  	it "should require a matching password confirmation " do
  		user_not_with_password_confirmation = User.new(@valid.merge(
  		                                             :password_confirmation=>""))
  	    user_not_with_password_confirmation.should_not be_valid
  	end
  	
  	it "should reject too short passwords " do
  		short = "a"*5
  		User.new(@valid.merge(:password =>short, 
  		                      :password_confirmation => short)).should_not be_valid
  	end
  	
  	it "should reject too long passwords " do
  		long = "a"*31
  		hash = @valid.merge(:password =>long , :password_confirmation =>long)
  		User.new(hash).should_not be_valid
  	end		                                             		                                           	
  end
  
  
  
  
  
  describe "password  encryption " do
  	
  	before(:each) do
  		@user = User.create!(@valid)
  	end
  	
  	it "should respond to encrypted password attribute" do
  		@user.should respond_to(:encrypted_password)
  	end
  	
  	it "should set the encrypted password " do
  		@user.encrypted_password.should_not be_blank
  	end 
  	
  	describe "has_password? method" do
  		
  		it "should be ture if the passwords match" do
  		     @user.has_password?(@valid[:password]).should be_true
  		end
  		
  		it "should be false if the password do not match " do
  			@user.has_password?("invalid").should be_false
  		end
  		
  	end
  	
  	describe "authenticate method " do
  	
  		it "should return nil if no email/password match " do
  		    wrong_password_user = User.authenticate(@valid[:email],"wrong")
  		    wrong_password_user.should be_nil
  		end
  		
  		it "should return nil for a email address with no user" do
  			nonexistent_user = User.authenticate("bar@foo.com", @valid[:password])
  			nonexistent_user.should be_nil
  		end
  		
  		it "should return the user on email/passwprd mactch " do
  			matching_user = User.authenticate(@valid[:email],@valid[:password])
  			matching_user.should ==@user
  		end
  			
  	end
  			
  end
end  