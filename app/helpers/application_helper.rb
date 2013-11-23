module ApplicationHelper

  def bootstrap_class_for flash_type
    case flash_type
      when :success
        "alert-success"
      when :error
        "alert-danger"
      when :alert
        "alert-warning"
      when :notice
        "alert-info"
      else
        flash_type.to_s
    end
  end

  def subdomain_url subdomain
    subdomain = (subdomain || "")
    subdomain += "." unless subdomain.empty?
    current_domain = request.domain
    current_domain.slice!("www.")  #this is so ugly and I am ashamed.  remove www if it is in the request
    [subdomain, current_domain, request.port_string].join
  end
end
