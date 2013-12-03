require 'spec_helper'

describe HighVoltage::PagesController, "#show" do
  %w(home).each do |page|
    context "on get to /pages/#{page}" do
      before do
        get :show, id: page
      end

      it {should respond_with(:success)}
      it {should render_template(page)}
    end
  end
end
