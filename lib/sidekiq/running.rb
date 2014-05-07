require "sidekiq/running/version"

module Sidekiq
  module Running
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def queue_name
        sidekiq_options_hash["queue"].to_s || "default"
      end

      def queued?(*args)
        queue = Sidekiq::Queue.new(queue_name)
        queue.any? do |job|
          job.klass == self.name && job.args == args
        end
      end

      def running?(*args)
        workers = Sidekiq::Workers.new
        workers.to_a.any? do |worker_name, tid, work|
          payload = work["payload"]
          next unless payload
          payload["queue"] == queue_name and payload["class"] == self.name && payload["args"] == args
        end
      end

      def queued_or_running?(*args)
        running?(*args) or queued?(*args)
      end

      def perform_async_unless_queued(*args)
        perform_async(*args) unless queued?(*args)
      end

      def perform_async_unless_running(*args)
        perform_async(*args) unless running?(*args)
      end

      def perform_async_unless_queued_or_running(*args)
        perform_async(*args) unless queued_or_running?(*args)
      end
    end
  end
end
