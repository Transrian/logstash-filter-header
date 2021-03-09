# encoding: utf-8
require "logstash/filters/base"
require "lru_redux"

class LogStash::Filters::Header < LogStash::Filters::Base

  config_name "header"

  config :header_lines, :validate => :number, :default => 0
  config :header_delimiter, :validate => :string, :default => "\n"
  config :header_global_delimiter, :validate => :string, :default => nil

  config :stream_identity , :validate => :string, :default => "%{host}.%{path}.%{type}"
  config :message_field , :validate => :string, :default => "message"

  public
  def initialize(config = {})
    super

    @threadsafe = false

    @cache = LruRedux::TTL::ThreadSafeCache.new(10000, 3600)
  end

  public
  def register
  end

  public
  def filter(event)
    key = event.sprintf(@stream_identity)

    if @cache.key?(key)
      header_config = @cache[key]
    else
      header_config = {
        "lines" => [], 
        "current_lines" => 0, 
        "full_header" => ""
      }
    end

    if header_config["current_lines"] < @header_lines
      header_config["lines"].append(event.get(@message_field))
      header_config["current_lines"] += 1
      if header_config["current_lines"] >= @header_lines
        global_delimiter = !header_global_delimiter.nil? ? header_global_delimiter : @header_delimiter
        header_config["full_header"] = header_config["lines"].join(@header_delimiter) + global_delimiter
      end
      @cache[key] = header_config
      event.cancel
    else
      event.set(@message_field, header_config["full_header"] + event.get(@message_field))
    end

    filter_matched(event) unless event.cancelled?
  end
end
