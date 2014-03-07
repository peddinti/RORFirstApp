require 'spec_helper'

describe "UserPages" do
  subject {page}
  describe "sign up page" do
    before { visit signup_path }
    it {should have_content('Sign Up')}
    it {should have_title(full_title('Sign Up'))}
  end
  
  describe "profile page" do
    let(:user) {FactoryGirl.create(:user)}
    let!(:micropost_1) {FactoryGirl.create(:micropost, user: user, content: "Foo")}
    let!(:micropost_2) {FactoryGirl.create(:micropost, user: user, content: "Bar")}
    
    before {visit user_path(user)}
    it {should have_content(user.name)}
    it {should have_title(user.name)}
    
    describe "microposts" do
      it {should have_content(micropost_1.content)}
      it {should have_content(micropost_2.content)}
      it {should have_content(user.microposts.count)}
    end
  end
  
  describe "Sign Up" do
    before {visit signup_path}
    let (:submit) {"Create my account"}
    
    describe "with invaid information" do
      it "should not create account" do
        expect {click_button submit}.not_to change(User,:count)
      end
    end
    
    describe "with valid information" do
      before do
        fill_in "Name", with: "Test User" 
        fill_in "Email", with: "testuser@test.com"
        fill_in "Password", with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end
      it "should create account" do
        expect {click_button submit}.to change(User,:count).by(1)
      end
      
      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'testuser@test.com') }
        
        it { should have_link('Sign out') }
        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
        
        describe "followed by signout" do
          before { click_link "Sign out" }
          it { should have_link('Sign in') }
        end
      end
    end
  end
  
  describe "edit user" do
    let (:user) {FactoryGirl.create(:user)}
    before do
      sign_in user
      visit edit_user_path(user)
    end
    
    describe "page" do
      it {should have_content("Update your profile")}
      it {should have_title("Edit")}
      it {should have_link("change", href: 'http://gravatar.com/emails')}
    end
    
    describe "with valid information" do
      let(:new_user_name) {"New test User"}
      let(:new_email) {"newtestuser@test.com"}
      before do
        fill_in "Name", with: new_user_name
        fill_in "Email", with: new_email
        fill_in "Password", with: user.password
        fill_in "Confirmation", with: user.password
        click_button "Save changes"
      end
      
      it { should have_title(new_user_name)}
      it { should have_content(new_user_name)}
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out') }
      
      specify { expect(user.reload.name).to  eq new_user_name }
      specify { expect(user.reload.email).to eq new_email }
    end
    
    describe "with invalid information" do
      before {click_button "Save changes"}
      
      it {should have_content("error")}
    end
  end
  
  describe "index" do
    before do
      sign_in FactoryGirl.create(:user)
      FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
      FactoryGirl.create(:user, name: "Ben", email: "ben@example.com")
      visit users_path
    end

    it { should have_title('All users') }
    it { should have_content('All users') }

    it "should list each user" do
      User.all.each do |user|
        expect(page).to have_selector('li', text: user.name)
      end
    end
    
    describe "pagination" do

          before(:all) { 30.times { FactoryGirl.create(:user) } }
          after(:all)  { User.delete_all }

          it { should have_selector('div.pagination') }

          it "should list each user" do
            User.paginate(page: 1).each do |user|
              expect(page).to have_selector('li', text: user.name)
            end
          end
        end
  end
end
