module Architecture
  # Module defining an activation behavior
  module Activation
    # Anything including this module must define the following attributes:
    #
    # activated_at, Time, default: nil
    # deactivated_at, Time, default: nil
    def activate(time)
      self.activated_at = time || Time.now
      self.deactivated_at = nil
    end

    def deactivate(time)
      return unless activated_at

      self.deactivated_at = time || Time.now
    end

    def activated?
      (activated_at && activated_at < Time.now) && (!deactivated_at || deactivated_at > Time.now)
    end
  end
end
