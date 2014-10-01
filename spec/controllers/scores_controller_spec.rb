require 'rails_helper'

RSpec.describe ScoresController, type: :controller do
  describe 'GET index' do
    let!(:score) { create(:score) }

    it 'assigns all scores as @scores' do
      get :index, format: :json
      expect(assigns(:scores)).to eq([score])
    end
  end

  describe 'GET show' do
    let(:score) { create(:score) }

    it 'assigns the requested score as @score' do
      get :show, id: score, format: :json
      expect(assigns(:score)).to eq(score)
    end
  end

  describe 'POST create' do
    let(:make_request) {
      ->{ post :create, score: attributes_for(:score), format: :json }
    }

    describe 'with valid params' do
      it 'creates a new Score' do
        expect(make_request).to change(Score, :count).by(1)
      end

      it 'assigns a newly created score as @score' do
        make_request.call
        expect(assigns(:score)).to be_a(Score)
        expect(assigns(:score)).to be_persisted
      end

      it 'responds with score details' do
        make_request.call
        expect(response.body).to include('"id"')
        expect(response.body).to include('"value"')
        expect(response.body).to include('"initials"')
        expect(response.body).to include('"created_at"')
      end
    end

    describe 'when score does not save' do
      before do
        allow_any_instance_of(Score).to receive(:save).and_return(false)
      end

      it 'assigns a newly created but unsaved score as @score' do
        make_request.call
        expect(assigns(:score)).to be_a_new(Score)
      end

      it 'does not load successfully' do
        make_request.call
        expect(response.status).to eq(422)
      end

      it 'responds with error messages' do
        make_request.call
        expect(response.body).to include('"error":')
      end
    end
  end
end
