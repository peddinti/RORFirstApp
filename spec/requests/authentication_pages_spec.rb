require 'spec_helper'

describe "AuthenticationPages" do
  subject {page}
  
  describe "signin page" do
    let(:signin){"Sign In"}
    before {visit signin_path}
       
    describe "with invalid information" do
      before {click_button signin}
      it {should have_selector('div.alert.alert-error')}
      it { should have_content('Sign in')}
      it { should have_title('Sign in')}
    end
    
    describe "with valid information" do
      let(:user) {FactoryGirl.create(:user)}
      before do
        sign_in user
      end
      it { should_not have_selector('div.alert.alert-error')}
      it { should have_link('Users',       href: users_path) }
      it { should have_link('Profile',     href: user_path(user)) }
      it { should have_link('Settings', href: edit_user_path(user))}
      it { should have_link('Sign out',    href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }
    end
    
    describe "after visiting another page" do
      before { click_link "Home" }
      it { should_not have_selector('div.alert.alert-error') }
    end
  end
  
  describe "authentication for not signed in user" do
    let(:user) {FactoryGirl.create(:user)}
    
    describe "when attempting to visit a protected page" do
      before do
        visit edit_user_path(user)
        fill_in "Email",    with: user.email
        fill_in "Password", with: user.password
        click_button "Sign In"
      end

      describe "after signing in" do

        it "should render the desired protected page" do
          expect(page).to have_title('Edit user')
        end
      end
    end
          
    describe "visiting edit page" do
      before {visit edit_user_path(user)}
      
      it {should have_title("Sign in")}
    end
    
    describe "submitting to the update action" do
      before { patch user_path(user) }
      specify { expect(response).to redirect_to(signin_path) }
    end
    
    describe "visiting the user index" do
      before { visit users_path }
      it { should have_title('Sign in') }
    end
  end
  
  describe "wrong user" do
    let(:user) {FactoryGirl.create(:user)}
    let(:wronguser) {FactoryGirl.create(:user, email: "wronguser@example.com")}
    before {sign_in user, no_capybara: true }
    
    describe "Making edit action" do
      before {get edit_user_path(wronguser)}
      
      it {should_not have_title(full_title("Edit user")) }
      specify { expect(response).to redirect_to(root_url)}
    end
    
    describe "Making update action" do
      before {patch user_path(wronguser)}
      
      specify { expect(response).to redirect_to(root_url)}
    end
  end
end
