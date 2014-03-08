require 'spec_helper'

describe Relationship do
  
  let(:follower) {FactoryGirl.create(:user)}
  let(:followed) {FactoryGirl.create(:user)}
  let(:relationship) {follower.relationships.create(followed_id: followed.id)}
  
  subject {relationship}
  
  it {should be_valid}
  describe "follower methods" do
    it {should respond_to(:follower_id)}
    it {should respond_to(:followed_id)}
    its (:followed) {should eq followed}
    its (:follower) {should eq follower}
  end
  
  describe "when follower id is not present" do
    before {relationship.follower_id = nil} 
    it {should_not be_valid}
  end
  
  describe "when followed id is not present" do
    before {relationship.followed_id = nil}    
    it { should_not be_valid}
  end
end
