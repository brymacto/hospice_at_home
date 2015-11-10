feature "the homepage" do
  scenario "says hello world" do
    visit '/'
    expect(page).to have_content 'hello world'
  end
end 