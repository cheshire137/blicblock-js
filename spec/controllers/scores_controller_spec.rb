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

      describe 'JSON response' do
        subject { JSON.parse(response.body) }

        it 'includes list of scores' do
          expect(subject['scores']).to_not be_empty
        end

        it 'includes current page' do
          expect(subject['page']).to eq(1)
        end

        it 'includes total number of page' do
          expect(subject['total_pages']).to eq(1)
        end

        it 'includes total number of scores' do
          expect(subject['total_records']).to eq(4)
        end
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
    let!(:score) { create(:score) }
    before { get :show, id: score, format: :json }

    it 'assigns the requested score as @score' do
      expect(assigns(:score)).to eq(score)
    end

    it 'loads successfully' do
      expect(response).to be_success
    end

    it 'assigns total score count to @total_scores' do
      expect(assigns(:total_scores)).to eq(1)
    end

    describe 'JSON response' do
      subject { JSON.parse(response.body) }

      it 'includes value' do
        expect(subject['value']).to eq(score.value)
      end

      it 'includes initials' do
        expect(subject['initials']).to eq(score.initials)
      end

      it 'includes rank' do
        expect(subject['rank']).to eq(1)
      end

      it 'includes total score count' do
        expect(subject['total_scores']).to eq(1)
      end
    end
  end

  describe 'POST create' do
    let!(:other_score) { create(:score, value: 5000) }
    let(:initials) { 'BIG' }
    let(:value) { 2000 }
    let(:make_request) {
      ->{ post :create, score: {initials: initials, value: value},
                        format: :json }
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

      it 'assigns total score count to @total_scores' do
        make_request.call
        expect(assigns(:total_scores)).to eq(2)
      end

      describe 'JSON response' do
        before { make_request.call }
        subject { JSON.parse(response.body) }

        it 'includes value' do
          expect(subject['value']).to eq(value)
        end

        it 'includes initials' do
          expect(subject['initials']).to eq(initials)
        end

        it 'includes rank' do
          expect(subject['rank']).to eq(2)
        end

        it 'includes total score count' do
          expect(subject['total_scores']).to eq(2)
        end
      end
    end

    describe 'when score does not save' do
      before do
        allow_any_instance_of(Score).to receive(:save).and_return(false)
      end

      it 'assigns a new, unsaved score as @score' do
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
