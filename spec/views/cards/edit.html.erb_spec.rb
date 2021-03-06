require 'rails_helper'

RSpec.describe "cards/edit", type: :view do
  before(:each) do
    @card = assign(:card, Card.create!(
      :name => "MyString",
      :position => 1,
      :list => nil
    ))
  end

  it "renders the edit card form" do
    render

    assert_select "form[action=?][method=?]", card_path(@card), "post" do

      assert_select "input[name=?]", "card[name]"

      assert_select "input[name=?]", "card[position]"

      assert_select "input[name=?]", "card[list_id]"
    end
  end
end
