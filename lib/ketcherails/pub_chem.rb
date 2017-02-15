require 'net/http'

module Ketcherails::PubChem
  include HTTParty


  debug_output $stderr

  def self.http_s
    Rails.env.test? && "http://" || "https://"
  end

  def self.get_record_from_molfile(molfile)
    @auth = {:username => '', :password => ''}
    options = { :timeout => 10,  :headers => {'Content-Type' => 'application/x-www-form-urlencoded'}, :body => { 'sdf' => molfile } }

    HTTParty.post(http_s+'pubchem.ncbi.nlm.nih.gov/rest/pug/compound/sdf/record/JSON', options)
  end
end
