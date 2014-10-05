require 'rails_helper'

RSpec.describe ScoresController, type: :controller do
  describe 'GET index' do
    let!(:score1) { create(:score, value: 9000, created_at: 8.days.ago) }
    let!(:score2) { create(:score, value: 7000, initials: 'CAT') }
    let!(:score3) { create(:score, value: score2.value) }
    let!(:score4) { create(:score, value: 3000, created_at: 2.months.ago) }

    context 'with no parameters' do
      before { get :index, format: :json }

      it 'assigns all scores to @scores, ordered by value' do
        expect(assigns(:scores)).to eq([score1, score3, score2, score4])
      end

      it 'includes rank for each score' do
        expect(assigns(:scores)[0]['rank']).to eq(1)
        expect(assigns(:scores)[1]['rank']).to eq(2)
        expect(assigns(:scores)[2]['rank']).to eq(2)
        expect(assigns(:scores)[3]['rank']).to eq(3)
      end
    end

    context 'with order=newest' do
      it 'assigns all scores to @scores, ordered by created_at DESC' do
        get :index, order: 'newest', format: :json
        expect(assigns(:scores)).to eq([score3, score2, score1, score4])
      end

      context 'with initials' do
        it 'includes only scores that match the given initials' do
          get :index, initials: 'abC', order: 'newest', format: :json
          expect(assigns(:scores)).to eq([score3, score1, score4])
        end
      end
    end

    context 'with order=oldest' do
      it 'assigns all scores to @scores, ordered by created_at ASC' do
        get :index, order: 'oldest', format: :json
        expect(assigns(:scores)).to eq([score4, score1, score2, score3])
      end

      context 'with initials' do
        it 'includes only scores that match the given initials' do
          get :index, initials: 'Abc', order: 'oldest', format: :json
          expect(assigns(:scores)).to eq([score4, score1, score3])
        end
      end
    end

    context 'with time=week' do
      it 'includes only scores from the last seven days' do
        get :index, time: 'week', format: :json
        expect(assigns(:scores)).to eq([score3, score2])
      end

      context 'with initials' do
        it 'includes only scores that match the given initials' do
          get :index, initials: 'Abc', time: 'week', format: :json
          expect(assigns(:scores)).to eq([score3])
        end
      end

      context 'with order=newest' do
        it 'orders by newest first' do
          get :index, time: 'week', order: 'newest', format: :json
          expect(assigns(:scores)).to eq([score3, score2])
        end
      end

      context 'with order=oldest' do
        it 'orders by oldest first' do
          get :index, time: 'week', order: 'oldest', format: :json
          expect(assigns(:scores)).to eq([score2, score3])
        end
      end
    end

    context 'with time=month' do
      it 'includes only scores from the last thirty days' do
        get :index, time: 'month', format: :json
        expect(assigns(:scores)).to eq([score1, score3, score2])
      end

      context 'with initials' do
        it 'includes only scores that match the given initials' do
          get :index, initials: 'abc', time: 'month', format: :json
          expect(assigns(:scores)).to eq([score1, score3])
        end
      end

      context 'with order=newest' do
        it 'orders by newest first' do
          get :index, time: 'month', order: 'newest', format: :json
          expect(assigns(:scores)).to eq([score3, score2, score1])
        end
      end

      context 'with order=oldest' do
        it 'orders by oldest first' do
          get :index, time: 'month', order: 'oldest', format: :json
          expect(assigns(:scores)).to eq([score1, score2, score3])
        end
      end
    end

    context 'with initials' do
      it 'includes only scores that match the given initials' do
        get :index, initials: 'cAt', format: :json
        expect(assigns(:scores)).to eq([score2])
      end
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
