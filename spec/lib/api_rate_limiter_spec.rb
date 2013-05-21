require'spec_helper'

describe ApiRateLimiter  do
  describe '#with_rate_limiting', :redis => true do
    let(:api) { stub(:mock_api_call => stub) }
    let(:api_name) { :test }
    let(:times) { 2 }

    subject {
      with_rate_limiting(api_name, times) do
        api.mock_api_call
      end
    }

    context 'throws ApiNotFoundError' do
      context 'when nil API name' do
        let(:api_name) { nil }
        it { expect { subject }.to raise_error(ApiRateLimiter::ApiNotFoundError) }
      end

      context 'when non existant API name' do
        let(:api_name) { :non_existant }
        it { expect { subject }.to raise_error(ApiRateLimiter::ApiNotFoundError) }
      end
    end

    context 'throws no errors' do
      # add a fake rate limiter to make specs shorter
      let(:test_constraints) { { :threshold => 4, :interval => 4 } }
      let(:test_rate_limiters) { { :test => RateLimitedScheduler.new("test_api_requests", test_constraints) } }
      before { $rate_limiters = test_rate_limiters }

      context 'with single thread' do
        before { api.should_receive(:mock_api_call).exactly(times).times }

        def calculate_time
          before_time = Time.now.to_f
          subject
          after_time = Time.now.to_f

          after_time - before_time
        end

        context 'when not exceeding threshold per interval period' do
          it 'takes less than interval seconds' do
            calculate_time.should < test_constraints[:interval]
          end
        end

        context 'when exceeding threshold per interval period' do
          let(:times) { 6 }

          it 'takes more than interval seconds' do
            calculate_time.should > test_constraints[:interval]
          end
        end
      end


      context 'with multiple threads' do
        before { api.should_receive(:mock_api_call).exactly(times*2).times }

        def calculate_threaded_time
          before_time = Time.now.to_f
          thread1 = Thread.new { subject }
          thread2 = Thread.new { subject }
          thread1.join
          thread2.join
          after_time = Time.now.to_f

          after_time - before_time
        end


        context 'when not exceeding threshold per interval period' do
          let(:times) { 1 }

          it 'takes less than interval seconds' do
            calculate_threaded_time.should < test_constraints[:interval]
          end
        end

        context 'when exceeding threshold per interval period' do
          let(:times) { 3 }

          it 'takes more than interval seconds' do
            calculate_threaded_time.should > test_constraints[:interval]
          end
        end
      end
    end
  end
end
