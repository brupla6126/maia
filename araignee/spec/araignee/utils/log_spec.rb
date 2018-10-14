require 'araignee/utils/log'

RSpec.describe Araignee::Utils::Log do
  context 'when Log is not configured' do
    it 'should set default logger' do
      expect(Araignee::Utils::Log[:default]).not_to eq(nil)
    end
  end

  describe '#[]=' do
    context 'when id is nil' do
      it 'raises ArgumentError id nil' do
        expect do
          described_class[nil] = nil
        end.to raise_error(ArgumentError, 'id nil')
      end
    end

    context 'when logger is nil' do
      it 'raises ArgumentError logger nil' do
        expect do
          described_class[:logger] = nil
        end.to raise_error(ArgumentError, 'logger nil')
      end
    end
  end

  describe '#[]' do
    after(:example) do
      described_class.close
    end

    context 'when id is nil' do
      it 'raises ArgumentError id nil' do
        expect do
          described_class[nil]
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
        described_class[:default] = Logger.new(STDOUT)
      end
      it 'returns :default logger' do
        logger = described_class[:abc]
        expect(logger).to eq(described_class[:default])
      end
    end

    context 'when id is found' do
      before(:example) do
        described_class[:abc] = Logger.new(STDOUT)
      end
      it 'returns id logger' do
        logger = described_class[:abc]
        expect(logger).to eq(described_class[:abc])
      end
    end
  end

  describe '#debug' do
    before(:example) do
      described_class.close
    end
    after(:example) do
      described_class.close
    end

    it 'logs at level debug' do
      logger = double('logger')

      described_class[:default] = logger

      expect(logger).to receive(:debug)
      described_class.debug { 'test debug' }
    end
  end

  describe '#info' do
    before(:example) do
      described_class.close
    end
    after(:example) do
      described_class.close
    end

    it 'logs at level info' do
      logger = double('info')

      described_class[:default] = logger

      expect(logger).to receive(:info)
      described_class.info { 'test' }
    end
  end

  describe '#warn' do
    before(:example) do
      described_class.close
    end
    after(:example) do
      described_class.close
    end

    it 'logs at level warn' do
      logger = double('warn')

      described_class[:default] = logger

      expect(logger).to receive(:warn)
      described_class.warn { 'test' }
    end
  end

  describe '#error' do
    before(:example) do
      described_class.close
    end
    after(:example) do
      described_class.close
    end

    it 'logs at level error' do
      logger = double('error')

      described_class[:default] = logger

      expect(logger).to receive(:error)
      described_class.error { 'test' }
    end
  end

  describe '#fatal' do
    before(:example) do
      described_class.close
    end
    after(:example) do
      described_class.close
    end

    it 'logs at level fatal' do
      logger = double('fatal')

      described_class[:default] = logger

      expect(logger).to receive(:fatal)
      described_class.fatal { 'test' }
    end
  end

  describe '#close' do
    before(:example) do
      described_class[:default] = Logger.new(STDOUT)
    end

    it 'loggers are closed' do
      described_class.close
      expect(described_class.loggers.empty?).to eq(true)
    end
  end
end
