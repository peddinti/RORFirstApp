require 'spec_helper'

describe "MicropostPages" do
  subject {page}
  
  let(:user) {FactoryGirl.create(:user)}
  before {sign_in user}
  
  describe "create micropost" do
    before {visit root_path}
    
    describe "with invalid content" do
      it "should not create post" do
        expect {click_button "Post"}.not_to change(Micropost, :count)
      end
      
      describe "error messages" do
        before {click_button "Post"}
        it {should have_content("error")}
      end
    end
    
    describe "with valid content" do
      before {fill_in 'micropost_content', with: "Test content"}
      it "should create post" do
        expect {click_button "Post"}.to change(Micropost, :count).by(1)
      end
    end
  end
end
