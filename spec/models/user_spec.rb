require 'spec_helper'

describe User do
  before {@user = User.new(email: "testuser@test.com", name: "Test User", password: "testPassword", password_confirmation: "testPassword")}
  subject {@user}
  it { should respond_to(:name) }
  it { should respond_to(:email)}
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:password_confirmation) }
  
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
      # this action is performed after
      dup_user.save
    end
    it {should_not be_valid}
  end
  
  describe "when password is not present" do
    before do 
      @user.password = " "
      @user.password_confirmation = " "
    end
    it {should_not be_valid}
  end
  
  describe "short password" do
    before do
      @user.password = "a" * 5
      @user.password_confirmation = @user.password
    end
    it {should be_invalid}
  end
  
  describe "when passwords dont match" do
    before {@user.password = @user.password + "a"}
    it {should_not be_valid}
  end
  
  describe "return value of authenticate method" do
    before {@user.save}
    let(:found_user) {User.find_by(email: @user.email)}
    
    describe "with valid password" do
      it {should eq found_user.authenticate(@user.password)}
    end
    
    describe "with invalid password" do
      let(:invalid_user) {found_user.authenticate(@user.password+"a")}
      it {should_not eq invalid_user}
      specify { expect(invalid_user).to be_false}
    end
  end
  
  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end
end
