module CalendarHelper
  def show_direct_option?
    current_user.subordinates.count > 0
  end
end
