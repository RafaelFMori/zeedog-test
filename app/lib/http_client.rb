class HttpClient
  def initialize()
    @hydra = Typhoeus::Hydra.hydra
  end

  def get(base_url:, params:)
    request_url = build_get_url(base_url, params)
    request = Typhoeus::Request.new(request_url)
    @hydra.queue(request)
    @hydra.run
    request
  end

  private

  # Typhoeus encodes all reserved characters in the query string
  # making it impossible to pass symbols such as (+ and :)
  # https://github.com/typhoeus/typhoeus/issues/400
  def build_get_url(base_url, params)
    request_url = base_url
    params.each do |key,value|
      request_url += "#{key}=#{value}&"
    end
    request_url
  end
end
