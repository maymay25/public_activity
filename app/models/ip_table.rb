# encoding: utf-8
class IpTable < ActiveRecord::Base

  def self.get_location(ip)
      return {} if ip.nil?
      ip_score = 0
      ip.split(".").each_with_index { |ip,index| ip_score +=(ip.to_i)*(256**(3-index)) }
      record = IpTable.select('province_name,city_name').first(:conditions=>["start_at<=? and end_at >= ?",ip_score,ip_score])
      return {} if record.nil?
      {province:record.province_name,city:record.city_name}
  rescue
  		return {}
  end


end
