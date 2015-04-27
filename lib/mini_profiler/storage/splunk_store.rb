module Rack
  class MiniProfiler
    class SplunkStore < AbstractStore

      EXPIRES_IN_SECONDS = 60 * 60 * 24

      def initialize(args = nil)
        @args               = args || {}
        @prefix             = @args.delete(:prefix)     || 'MPRedisStore'
      end

      def save(page_struct)
        forward_to_splunk(JSON.parse(page_struct.to_json), @args)
      end

      def load(id)
      end

      def set_unviewed(user, id)
      end

      def set_viewed(user, id)
      end

      def get_unviewed_ids(user)
      end

      def diagnostics(user)
      end

      private
      def forward_to_splunk(payload, params={})
        default_host = `hostname` rescue nil
        defaults = {
          :splunk_base_url => "https://localhost:8088",
          :splunk_endpoint => "/services/receivers/token/event",
          :splunk_auth => "Splunk DEADBEEF-CAFEBABE-CAFED00D",
          :host => default_host,
          :source => $0,
          :sourcetype => "apm_ruby"
        }
        options = defaults.merge params

        uri = URI.parse(options[:splunk_base_url] + options[:splunk_endpoint])
        Net::HTTP.start(uri.host, uri.port) do |http|
          http.use_ssl = false
          request = Net::HTTP::Post.new uri
          request.initialize_http_header({
                                           'Authorization' => options[:splunk_auth]
                                         })
          [payload].each do |j|
            data = {
              "event" => j,
              "host" => options[:host],
              "source" => options[:source],
              "sourcetype" => options[:sourcetype]
            }.to_json

            request.body = data
            resp = http.request request
            if resp.code != "200"
              $stderr.puts("Failure when forwarding data to splunk.\
Status = #{resp.code}. Response = #{resp.body}. Options used = #{options.to_s}.")
              return false # from forward_to_splunk
            end
          end # payload.each
        end # http
        return true
      end # forward_to_splunk


    end
  end
end
