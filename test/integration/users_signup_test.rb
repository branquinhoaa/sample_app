require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  #By wrapping the post in the assert_no_difference method with the string argument ’User.count’, we arrange for a comparison between User.count before and after the contents inside the assert_no_difference block. 

  test "the name should not be null" do
    expected = CGI::escapeHTML('Name can\'t be blank')
    post users_path, params:{
      user:{
        name: "",
        email: "user@valid.com", password: "foobar", password_confirmation: "foobar"
        }
      } 
    assert @response.body.include?(expected)
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
        email: "user@example.com",
        password:              "password",
        password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
    assert is_logged_in?
  end

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: {
        user: {
          name: "",
          email: "user@invalid",
          password: "foo",
          password_confirmation: "bar" 
          }
        }
    end
    assert_template 'users/new'
  end
end