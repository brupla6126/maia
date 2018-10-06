# defines methods to calculate time a process takes.
module Stats
  def start_stats
    @stats = { start: Time.now }
  end

  def finish_stats
    @stats[:finish] = Time.now
    @stats[:duration] = (@stats[:finish] - @stats[:start]).round(4)
  end
end
