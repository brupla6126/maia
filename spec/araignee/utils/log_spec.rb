require 'araignee/utils/log'

include Araignee, Araignee::Utils

RSpec.describe Utils::Log do
  context 'when Log is not configured' do
    it 'should set default logger' do
      expect(Log[:default]).not_to eq(nil)
    end
  end

  describe '#[]=' do
    context 'when id is nil' do
      it 'raises ArgumentError id nil' do
        expect do
          Log[nil] = nil
        end.to raise_error(ArgumentError, 'id nil')
      end
    end

    context 'when logger is nil' do
      it 'raises ArgumentError logger nil' do
        expect do
          Log[:logger] = nil
        end.to raise_error(ArgumentError, 'logger nil')
      end
    end
  end

  describe '#[]' do
    after(:example) do
      Log.close
    end

    context 'when id is nil' do
      it 'raises ArgumentError id nil' do
        expect do
          Log[nil]
        end.to raise_error(ArgumentError, 'id nil')
      end
    end

    context 'when id is not found and default logger is not set' do
      it 'returns /dev/null logger' do
        # logger = Log[:abc]
        # TODO: how to verify that ???
        # puts "log: #{logger.inspect}"
        # expect(logger.logdev.filename).to eq('/dev/null')
      end
    end

    context 'when id is not found and default logger is set' do
      before(:example) do
        Log[:default] = Logger.new(STDOUT)
      end
      it 'returns :default logger' do
        logger = Log[:abc]
        expect(logger).to eq(Log[:default])
      end
    end

    context 'when id is found' do
      before(:example) do
        Log[:abc] = Logger.new(STDOUT)
      end
      it 'returns id logger' do
        logger = Log[:abc]
        expect(logger).to eq(Log[:abc])
      end
    end
  end

  describe '#debug' do
    before(:example) do
      Log.close
    end
    after(:example) do
      Log.close
    end

    it 'logs at level debug' do
      logger = double('logger')

      Log[:default] = logger

      expect(logger).to receive(:debug)
      Log.debug { 'test debug' }
    end
  end

  describe '#info' do
    before(:example) do
      Log.close
    end
    after(:example) do
      Log.close
    end

    it 'logs at level info' do
      logger = double('info')

      Log[:default] = logger

      expect(logger).to receive(:info)
      Log.info { 'test' }
    end
  end

  describe '#warn' do
    before(:example) do
      Log.close
    end
    after(:example) do
      Log.close
    end

    it 'logs at level warn' do
      logger = double('warn')

      Log[:default] = logger

      expect(logger).to receive(:warn)
      Log.warn { 'test' }
    end
  end

  describe '#error' do
    before(:example) do
      Log.close
    end
    after(:example) do
      Log.close
    end

    it 'logs at level error' do
      logger = double('error')

      Log[:default] = logger

      expect(logger).to receive(:error)
      Log.error { 'test' }
    end
  end

  describe '#fatal' do
    before(:example) do
      Log.close
    end
    after(:example) do
      Log.close
    end

    it 'logs at level fatal' do
      logger = double('fatal')

      Log[:default] = logger

      expect(logger).to receive(:fatal)
      Log.fatal { 'test' }
    end
  end

  describe '#close' do
    before(:example) do
      Log[:default] = Logger.new(STDOUT)
    end

    it 'loggers are closed' do
      Log.close
      expect(Log.loggers.empty?).to eq(true)
    end
  end
end
