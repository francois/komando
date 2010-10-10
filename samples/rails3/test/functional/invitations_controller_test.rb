require 'test_helper'

class InvitationsControllerTest < ActionController::TestCase

  test "Inviting a user should invite by email and flag as invited" do

    post :create, :user => {:email => "jill@teksol.info"}

    assert_redirected_to root_url
  end

  test "Confirming invitation with invalid token renders 404" do
    user = User.invited.create!(:email => "jones@teksol.info")

    put :update, :id => user.id, :token => user.token.succ,
      :user => {:username => "", :password => ""}

    assert_response :not_found
    assert_template "404.html"
  end

  test "Confirming invitation with invalid ID renders 404" do
    user = User.invited.create!(:email => "jones@teksol.info")

    put :update, :id => user.id.succ, :token => user.token,
      :user => {:username => "", :password => ""}

    assert_response :not_found
    assert_template "404.html"
  end

end
