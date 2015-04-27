module Rack
  class MiniProfiler
    class SplunkStore < AbstractStore

      EXPIRES_IN_SECONDS = 60 * 60 * 24

      def initialize(args = nil)
        @args               = args || {}
        @prefix             = @args.delete(:prefix)     || 'MPRedisStore'
      end

      def save(page_struct)
        $stderr.puts("hithere")
        $stderr.puts(page_struct)
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

    end
  end
end
