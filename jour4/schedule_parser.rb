class ScheduleParser
  attr_accessor :current_guard, :current_sleep, :schedule

  SHIFT_PATTERN       = /Guard #(?<id>\d+) begins shift/
  FALL_ASLEEP_PATTERN = /\[.+:(?<minute>\d+)\] falls asleep/
  WAKES_PATTERN       = /\[.+:(?<minute>\d+)\] wakes up/

  def initialize(file_name)
    @lines = File.open(file_name, 'r').map(&:to_s)
  end

  def parse
    @schedule = {}

    @lines.sort.each do |line|
      check_shift(line)
      check_falls(line)
      check_wake(line)
    end

    @schedule
  end

  private

  def check_shift(line)
    if shift = line.match(SHIFT_PATTERN)
      @current_guard = shift[:id].to_i
      @current_sleep = nil
    end
  end

  def check_falls(line)
    if fall_asleep = line.match(FALL_ASLEEP_PATTERN)
      @current_sleep = fall_asleep[:minute].to_i
    end
  end

  def check_wake(line)
    if wakes_up = line.match(WAKES_PATTERN)
      @current_wake = wakes_up[:minute].to_i
      @schedule[@current_guard] ||= []
      @schedule[@current_guard] << (0...59).map {|i| (@current_sleep...@current_wake).include?(i)}
    end
  end
end
