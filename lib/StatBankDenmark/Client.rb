# lib/StatBankDenmark/Client.rb
# StatBankDenmark::Client

gem 'http.rb'; require 'http.rb'
require 'json'

require_relative './Error'
require_relative '../Object/inQ'

module StatBankDenmark
  class Client
    ALLOWABLE_VERBS = %w{GET POST}
    API_HOST = 'api.statbank.dk'

    class << self
      def path_prefix
        '/v1'
      end
    end # class << self

    def subjects(
      format: 'json',
      include_tables: nil,
      lang: 'en',
      omit_empty: nil,
      recursive: nil
    )
      response = get(
        path: '/subjects',
        args: {
          format: format,
          includeTables: include_tables,
          lang: lang,
          omitEmptySubjects: omit_empty,
          recursive: recursive,
        }
      )
      handle_response(response)
    end

    def tables(
      format: 'json',
      include_inactive: nil,
      lang: 'en',
      subject: nil
    )
      response = get(
        path: '/tables',
        args: {
          format: format,
          includeInactive: include_inactive,
          lang: lang,
          subjects: subject,
        }
      )
      handle_response(response)
    end

    def table_info(
      table_id,
      format: 'json',
      lang: 'en'
    )
      raise ArgumentError, "table_id is required" if table_id.nil? || table_id.empty?
      response = get(
        path: '/tableinfo',
        args: {
          format: format,
          lang: lang,
          id: table_id,
        }
      )
      handle_response(response)
    end

    def data(
      table_id,
      format: 'csv',
      lang: 'en',
      value_presentation: 'Default',
      variables: {}
    )
      raise ArgumentError, "table_id is required" if table_id.nil? || table_id.empty?
      body = {
        table: table_id,
        lang: lang,
        format: format,
        valuePresentation: value_presentation,
      }
      unless variables.empty?
        body[:variables] = variables.map do |var_name, values|
          {
            code: var_name.to_s,
            values: Array(values)
          }
        end
      end
      response = post(path: '/data', args: body)
      handle_response(response)
    end

    def search(query, lang: 'en')
      all_tables = tables(lang: lang)
      return [] unless all_tables.is_a?(Array)
      all_tables.select do |table|
        text = table['text'] || table[:text] || ''
        text.downcase.include?(query.downcase)
      end
    end

    private

    def initialize(timeout: 30)
      @timeout = timeout
    end

    def get(path:, args: {})
      do_request(verb: 'GET', path: path, args: args, options: {open_timeout: @timeout, read_timeout: @timeout})
    end

    def post(path:, args: {})
      do_request(verb: 'POST', path: path, args: args, options: {open_timeout: @timeout, read_timeout: @timeout})
    end

    def do_request(verb:, path:, args: {}, options: {})
      verb = verb.to_s.upcase
      raise ArgumentError, "Unsupported HTTP method: #{verb}" unless verb.in?(ALLOWABLE_VERBS)
      request_string = request_string(path: path)
      args = args.reject{|k,v| v.nil?}
      headers = {'Content-Type' => 'application/json'}
      HTTP.send(verb.downcase, request_string, args, headers, options)
    end

    def request_string(path:)
      "https://#{API_HOST}#{self.class.path_prefix}#{path}"
    end

    def handle_response(response)
      if response.success?
        body = response.body.to_s
        parsed_response(response)
      else
        case response.code.to_i
        when 400
          raise BadRequestError.new(
            code: response.code,
            message: response.message,
            body: response.body
          )
        when 404
          raise NotFoundError.new(
            code: response.code,
            message: response.message,
            body: response.body
          )
        when 429
          raise RateLimitError.new(
            code: response.code,
            message: response.message,
            body: response.body
          )
        when 500..599
          raise ServerError.new(
            code: response.code,
            message: response.message,
            body: response.body
          )
        else
          raise APIError.new(
            code: response.code,
            message: response.message,
            body: response.body
          )
        end
      end
    end

    def parsed_response(response)
      case response['content-type']
      when /application\/json/
        begin
          JSON.parse(response.body)
        rescue JSON::ParserError
          response.body
        end
      when /text\/csv/
        response.body
      when /application\/xml/, /text\/xml/
        response.body
      else
        begin
          JSON.parse(response.body)
        rescue JSON::ParserError
          response.body
        end
      end
    end
  end
end
