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

      def scheduled?(*args)
        scheduled = Sidekiq::ScheduledSet.new
        scheduled_job = scheduled.find do |job|
          job.klass == self.name && job.args == args
        end
        scheduled_job && scheduled_job.enqueued_at or false
      end

      def programmed?(*args)
        queued?(*args) or scheduled?(*args)
      end

      def running_or_queued?(*args)
        running?(*args) or queued?(*args)
      end
      alias_method :queued_or_running?, :running_or_queued?

      def running_or_programmed?(*args)
        queued?(*args) or programmed?(*args)
      end
      alias_method :programmed_or_running?, :running_or_programmed?

      def perform_async_unless_queued(*args)
        perform_async(*args) unless queued?(*args)
      end

      def perform_async_unless_running(*args)
        perform_async(*args) unless running?(*args)
      end

      def perform_async_unless_scheduled(*args)
        perform_async(*args) unless scheduled?(*args)
      end

      def perform_async_unless_programmed(*args)
        perform_async(*args) unless programmed?(*args)
      end

      def perform_async_unelss_running_or_queued(*args)
        perform_async(*args) unless running_or_queued?(*args)
      end
      alias_method :perform_async_unless_queued_or_running, :perform_async_unelss_running_or_queued

      def perform_async_unless_running_or_programmed(*args)
        perform_async(*args) unless running_or_programmed?(*args)
      end
      alias_method :perform_async_unless_programmed_or_running, :perform_async_unless_running_or_programmed
    end
  end
end
