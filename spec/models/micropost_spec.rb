require 'spec_helper'

describe Micropost do
  let(:user) { FactoryGirl.create(:user)}
  
  describe "create a new Micropost" do
    before do 
      @micropost = user.microposts.build(content: "test post")
    end
    subject {@micropost}
  
    it { should respond_to(:content)}
    it { should respond_to(:user_id)}
    it { should be_valid}
    it { should respond_to(:user)}
    its(:user) {should eq user}
    
    
    describe "with invalid user id" do
      before do
        @micropost.user_id = nil
      end
      
      it {should_not be_valid}
    end
    
    describe "with blank content" do
      before do
        @micropost.content = " "
      end
      it { should_not be_valid}
    end
    
    describe "with long content" do
      before do
        @micropost.content = "a"*141
      end
      it { should_not be_valid}
    end
  end
end
