require 'socket'

module Araignee
  module Architecture
    # Network
    module Network
      class << self
        def local_ip
          Socket.ip_address_list.detect(&:ipv4_private?).ip_address
        end
      end
    end
  end
end
