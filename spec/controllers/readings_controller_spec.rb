require 'spec_helper'

describe ReadingsController do

  describe "GET #show" do
    it "assigns the requested reading to @reading" do
      reading = create(:reading)
      get :show, id: reading
      expect(assigns(:reading)).to eq reading
    end

    it "renders the show template" do
      reading = create(:reading)
      get :show, id: reading
      expect(response).to render_template :show
    end
  end
end
