# lib/StatBankDenmark/Error.rb
# StatBankDenmark::Error

module StatBankDenmark
  class Error < RuntimeError
    attr_reader\
      :code,
      :message,
      :body

    def to_s
      "#{self.class} (#{@code}): #{@message}"
    end

    private

    def initialize(code:, message:, body:)
      @code = code
      @message = message
      @body = body
      super(message)
    end
  end

  # 400
  class BadRequestError < Error; end
  # 404
  class NotFoundError < Error; end
  # 429
  class RateLimitError < Error; end
  # 500..599
  class ServerError < Error; end
  # Everything else.
  class APIError < Error; end
end
