require 'rails_helper'

RSpec.describe "cards/new", type: :view do
  before(:each) do
    assign(:card, Card.new(
      :name => "MyString",
      :position => 1,
      :list => nil
    ))
  end

  it "renders new card form" do
    render

    assert_select "form[action=?][method=?]", cards_path, "post" do

      assert_select "input[name=?]", "card[name]"

      assert_select "input[name=?]", "card[position]"

      assert_select "input[name=?]", "card[list_id]"
    end
  end
end
