RSpec.describe SlippyMethodHooks do
  include TestHelpers

  it 'has a version number' do
    expect(SlippyMethodHooks::VERSION).not_to be nil
  end

  context 'method hooks' do

    context 'when .time_box_method is called' do

      context 'without a block and the method call expires' do

        before(:each) do
          test_class = Class.new do
            include SlippyMethodHooks
            def meth
              sleep 0.2
            end
            time_box_method(0.1, :meth)
          end

          @result =
            begin
              test_class.new.meth
            rescue StandardError => e
              e
            end
        end

        it "throws #{SlippyMethodHooks::TimeoutError} error" do
          expect(@result).to(be_a(SlippyMethodHooks::TimeoutError))
        end
      end

      context 'is called with a block and the method call expires' do

        before(:each) do
          expected_result = 'expected-result'
          @expected_result = expected_result

          test_class = Class.new do
            include SlippyMethodHooks

            attr_reader :args

            def meth
              sleep 0.2
            end

            time_box_method(0.1, :meth) do |*args|
              @args = args
              expected_result
            end
          end

          @test_obj = test_class.new
          @result =
            begin
              @test_obj.meth
            rescue StandardError => e
              e
            end
        end

        it 'returns the result of the given block' do
          expect(@expected_result).to eq(@result)
        end

        it 'yields an array of argument errors' do
          args = @test_obj.args
          expect(args).to be_a(Array)
          expect(args[0]).to eq(SlippyMethodHooks::TimeoutError)
          expect(args[1]).to be_a(String)
          expect(args[2]).to be_a(Array)
        end
      end
    end
  end
end
