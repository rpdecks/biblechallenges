require 'spec_helper'

describe CommentsController, 'Actions' do
  let!(:reading) { create(:reading, :with_challenge_membership) }

  describe 'POST #create' do
    describe 'when user is not logged in' do
      it 'should return http status UNAUTHORIZED' do
        post :create, comment: { content: 'Sample Comment', commentable_type: 'Reading', commentable_id: reading.id }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is logged in' do
      before(:each) do
        sign_in(reading.owner)
      end
      describe 'with invalid comment params' do
        it 'should return http status BAD REQUEST' do
          post :create, comment: { content: 'Sample Comment', commentable_id: reading.id }
          expect(response).to have_http_status(:bad_request)
        end
        it 'should return errors' do
          post :create, comment: { content: 'Sample Comment', commentable_id: reading.id }
          expect(response.body).to include('errors')
        end
      end

      describe 'with valid comment params' do
        it 'should increase comments count' do
          expect{
            post :create, comment: { content: 'Sample Comment', commentable_type: 'Reading', commentable_id: reading.id }
          }.to change{ Comment.count }.by(1)
        end

        it 'should return http status SUCCESS' do
          post :create, comment: { content: 'Sample Comment', commentable_type: 'Reading', commentable_id: reading.id }
          expect(response).to have_http_status(:success)
        end
      end
    end
  end
end
