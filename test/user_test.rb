require 'test_helper'

class UserTest < Test::Unit::TestCase
  context "an user" do
    setup do
      @session = Atheme::Session.new
      @cookie = @session.login("oper", "oper123")
      raise "Cannot login into oper (pw: oper123)" unless @cookie.kind_of?(String)
    end

    should "call #myself, returning own Atheme::User" do
      assert_equal true, @session.myself.respond_to?(:name) && @session.myself.name == "oper"
    end

    should "logout successfully" do
      assert_equal true, @session.logout
      assert_equal false, @session.logged_in?
    end

    should "relogin successfully" do
      assert_equal true, @session.relogin(@cookie, "oper")
    end
  end
end