module ApplicationHelper

  def s3_url(f)
    "#{ENV['AMAZON_S3_URL']}#{f}"
  end

  def flash_class( name )
    case name
    when :notice
      'alert-success'
    when :alert
      'alert-warning'
    when :error
      'alert-danger'
    else
      'alert-info'
    end
  end

  def course_dates( course )
    dates = course.start_date.day
    unless course.end_date.nil? || course.end_date == course.start_date
      dates = "#{dates} - #{course.end_date.day}"
    end
    dates
  end

  def status_tag( msg, status )
    %Q(<span class="#{status}">#{msg}</span>).html_safe
  end
end
