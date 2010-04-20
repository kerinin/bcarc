# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def lang sym
    case sym
    when :en
      'English'
    when :fr
      'Français'
    when :es
      'Español'
    when :de
      'Deutsch'
    when :zh, :zh_TW, :zh_CN
      "'中文"
    end
  end
end
