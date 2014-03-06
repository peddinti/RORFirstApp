require 'spec_helper'

describe User do
  before {@user = User.new(email: "testuser@test.com", name: "Test User")}
  subject {@user}
  it { should respond_to(:name) }
  it { should respond_to(:email)}
  
  it {should be_valid}
  
  describe "when name is not present" do
    before {@user.name = " "}
    it {should_not be_valid}
  end
  
  describe "when email is not present" do
    before {@user.email = " "}
    it {should_not be_valid}
  end
  
  describe "when name is too long" do
    # name shoudn't be greater than 50
    before {@user.name = "a" * 51}
    it {should_not be_valid}
  end
  
  describe "email format is valid" do
    it "should be valid" do
      valid_emails = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn foo.bar@f.b.org]
      valid_emails.each do |valid_email|
        @user.email = valid_email
        expect(@user).to be_valid
      end
    end
  end
  
  describe "email format is invalid" do
    it "should be invalid" do
      invalid_emails = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
      invalid_emails.each do |invalid_email|
        @user.email = invalid_email
        expect(@user).not_to be_valid
      end
    end
  end
  
  describe "email is duplicate" do
    before do
      dup_user = @user.dup
      # since original email address is in lower case we need to ensure duplication works with uppercase
      dup_user.email = dup_user.email.upcase
      dup_user.save
    end
    it {should_not be_valid}
  end
end
