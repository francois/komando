require 'test_helper'

class InvitationsControllerTest < ActionController::TestCase

  test "Requesting the signup page should render successfully" do
    get :new

    assert_response :success
    assert_template "signup"
  end

  test "Requesting the confirmation should render successfully" do
    user = User.invite!(:email => "jason@teksol.info")

    get :show, :id => user.token

    assert_response :success
    assert_template "confirm"
  end

  test "Requesting the confirmation page with a bad token should return a 404" do
    user = User.invite!(:email => "jason@teksol.info")
    get :show, :id => user.token.succ

    assert_response :not_found
    assert_template "404.html"
  end

  test "Inviting a user should invite by email and flag as invited" do
    post :create, :user => {:email => "jill@teksol.info"}

    assert_redirected_to root_url
  end

  test "Confirming invitation with correct token redirects to root" do
    user = User.invited.create!(:email => "jones@teksol.info")

    put :update, :id => user.token,
      :user => {:username => "jones", :password => "monkey"}

    assert_redirected_to root_url
  end

  test "Confirming invitation with invalid token renders 404" do
    user = User.invited.create!(:email => "jones@teksol.info")

    put :update, :id => user.token.succ,
      :user => {:username => "", :password => ""}

    assert_response :not_found
    assert_template "404.html"
  end

end
