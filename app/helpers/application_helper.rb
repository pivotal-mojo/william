module ApplicationHelper
  def status_class(remaining, cap)
    percent_remaining = remaining.to_f / cap.to_f
    if percent_remaining >= 0.8
      'full'
    elsif percent_remaining >= 0.5
      'warning'
    elsif percent_remaining > 0
      'critical'
    else
      'empty'
    end
  end
end
