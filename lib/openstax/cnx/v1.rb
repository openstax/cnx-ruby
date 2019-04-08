require 'addressable/uri'
require 'open-uri'
require 'logger'
require 'nokogiri'
require 'json'

require_relative './v1/http_error'

require_relative './v1/book'
require_relative './v1/book_part'
require_relative './v1/element'
require_relative './v1/figure'
require_relative './v1/paragraph'
require_relative './v1/page'
require_relative './v1/baked'

module OpenStax::Cnx::V1

  def self.configure
    yield configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  class NullLogger < Logger
    def initialize(*args); end
    def add(*args, &block); end
  end

  class Configuration
    attr_reader :archive_url_base
    attr_reader :webview_url_base
    attr_accessor :ignore_history
    attr_accessor :logger

    def initialize
      @logger = OpenStax::Cnx::V1::NullLogger.new
      @ignore_history = true
      self.archive_url_base = "https://archive.cnx.org"
    end

    def archive_url_base=(url)
      uri = Addressable::URI.parse(url)
      raise "Invalid CNX archive URL: #{url}" if uri.nil? || uri.host.nil?

      uri.scheme = 'https'
      @archive_url_base = uri.to_s

      uri.host = uri.host.sub(/archive[\.-]?/, '')
      @webview_url_base = uri.to_s
    end

    def webview_url_base=(url)
      uri = Addressable::URI.parse(url)
      raise "Invalid CNX webview URL: #{url}" if uri.nil? || uri.host.nil?

      uri.scheme = 'https'
      @webview_url_base = uri.to_s

      uri.host = "archive-#{uri.host}".sub('archive-cnx', 'archive.cnx')
      @archive_url_base = uri.to_s
    end

  end

  class << self

    def new_configuration
      OpenStax::Cnx::V1::Configuration.new
    end

    def archive_url_base
      configuration.archive_url_base
    end

    def webview_url_base
      configuration.webview_url_base
    end

    def logger
      configuration.logger
    end

    def with_archive_url(url)
      begin
        old_url = archive_url_base
        self.configuration.archive_url_base = url

        yield
      ensure
        self.configuration.archive_url_base = old_url
      end
    end

    def with_webview_url(url)
      begin
        old_url = webview_url_base
        self.configuration.webview_url_base = url

        yield
      ensure
        self.configuration.webview_url_base = old_url
      end
    end

    # Archive url for the given path
    # Forces /contents/ to be prepended to the path, unless the path begins with /
    def archive_url_for(path)
      Addressable::URI.join(configuration.archive_url_base, '/contents/', path).to_s
    end

    # Webview url for the given path
    # Forces /contents/ to be prepended to the path, unless the path begins with /
    def webview_url_for(path)
      Addressable::URI.join(configuration.webview_url_base, '/contents/', path).to_s
    end

    def fetch(url)
      begin
        OpenStax::Cnx::V1.logger.debug { "Fetching #{url}" }
        data = JSON.parse open(url, 'ACCEPT' => 'text/json').read
        data.delete("history") if configuration.ignore_history
        data
      rescue OpenURI::HTTPError => exception
        raise OpenStax::HTTPError, "#{exception.message} for URL #{url}"
      end
    end

    def book(options = {})
      OpenStax::Cnx::V1::Book.new(options)
    end

  end

end
