require 'spec_helper'

describe "Users" do
	describe "Sign up" do
		
		describe "failure " do
			
			it "should not make a new user " do
				lambda do					
					visit signup_url
					click_button
					response.should render_template('new')
					response.should have_tag("div#errorExplanation")
				end.should_not change(User,:count)
			end
		end
		
		describe "success " do 
			it "should  make a new user " do
				lambda do
					visit signup_url
					fill_in "姓名" ,    :with =>"Example User"
					fill_in "电子邮件",    :with =>"user@example.com"
					fill_in "密码",  :with =>"foobar"
					fill_in "Confirmation", :with =>"foobar"
					click_button
					response.should have_tag("div.flash.success")
				end.should change(User, :count).by(1)
			end
		end
	end	
end
