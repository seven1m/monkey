class Lexer
  TOKEN_TYPES = {
    ILLEGAL: 'ILLEGAL',
    EOF: 'EOF',

    # Identifiers + literals
    IDENT: 'IDENT',
    INT: 'INT',

    # Operators
    ASSIGN: '=',
    PLUS: '+',
    MINUS: '-',
    BANG: '!',
    ASTERISK: '*',
    SLASH: '/',
    LT: '<',
    GT: '>',
    EQ: '==',
    NOT_EQ: '!=',

    # Delimiters
    COMMA: ',',
    SEMICOLON: ';',

    # Braces
    LPAREN: '(',
    RPAREN: ')',
    LBRACE: '{',
    RBRACE: '}',

    # Keywords
    FUNCTION: 'FUNCTION',
    LET: 'LET',
    TRUE: 'TRUE',
    FALSE: 'FALSE',
    IF: 'IF',
    ELSE: 'ELSE',
    RETURN: 'RETURN',
  }

  KEYWORDS = {
    'fn' => TOKEN_TYPES[:FUNCTION],
    'let' => TOKEN_TYPES[:LET],
    'true' => TOKEN_TYPES[:TRUE],
    'false' => TOKEN_TYPES[:FALSE],
    'if' => TOKEN_TYPES[:IF],
    'else' => TOKEN_TYPES[:ELSE],
    'return' => TOKEN_TYPES[:RETURN],
  }

  class Token
    def initialize(type:, literal: nil)
      @type = type
      @literal = literal
    end

    def inspect
      "#<Token type=#{@type} literal=#{@literal.inspect}>"
    end

    def ==(other)
      @type == other.type && @literal == other.literal
    end

    attr_reader :type, :literal

    def self.lookup_ident(ident)
      if KEYWORDS[ident]
        KEYWORDS[ident]
      else
        TOKEN_TYPES[:IDENT]
      end
    end
  end

  def initialize(input)
    @input = input
    @position = 0
    @read_position = 0
    read_char
  end

  def next_token
    skip_whitespace

    case @ch
    when '='
      if peek_char == '='
        ch = @ch
        read_char
        literal = ch + @ch
        tok = Token.new(type: TOKEN_TYPES[:EQ], literal:)
      else
        tok = Token.new(type: TOKEN_TYPES[:ASSIGN], literal: @ch)
      end
    when '+' then tok = Token.new(type: TOKEN_TYPES[:PLUS], literal: @ch)
    when '-' then tok = Token.new(type: TOKEN_TYPES[:MINUS], literal: @ch)
    when '!'
      if peek_char == '='
        ch = @ch
        read_char
        literal = ch + @ch
        tok = Token.new(type: TOKEN_TYPES[:NOT_EQ], literal:)
      else
        tok = Token.new(type: TOKEN_TYPES[:BANG], literal: @ch)
      end
    when '/' then tok = Token.new(type: TOKEN_TYPES[:SLASH], literal: @ch)
    when '*' then tok = Token.new(type: TOKEN_TYPES[:ASTERISK], literal: @ch)
    when '<' then tok = Token.new(type: TOKEN_TYPES[:LT], literal: @ch)
    when '>' then tok = Token.new(type: TOKEN_TYPES[:GT], literal: @ch)
    when ';' then tok = Token.new(type: TOKEN_TYPES[:SEMICOLON], literal: @ch)
    when ',' then tok = Token.new(type: TOKEN_TYPES[:COMMA], literal: @ch)
    when '(' then tok = Token.new(type: TOKEN_TYPES[:LPAREN], literal: @ch)
    when ')' then tok = Token.new(type: TOKEN_TYPES[:RPAREN], literal: @ch)
    when '{' then tok = Token.new(type: TOKEN_TYPES[:LBRACE], literal: @ch)
    when '}' then tok = Token.new(type: TOKEN_TYPES[:RBRACE], literal: @ch)
    when nil then tok = Token.new(type: TOKEN_TYPES[:EOF])
    else
      if @ch.match?(/[a-zA-Z_]/)
        literal = read_identifier
        return Token.new(type: Token.lookup_ident(literal), literal:)
      elsif @ch.match?(/[0-9]/)
        return Token.new(type: TOKEN_TYPES[:INT], literal: read_number)
      else
        tok = Token.new(type: TOKEN_TYPES[:ILLEGAL], literal: @ch)
      end
    end

    read_char
    tok
  end

  private

  def skip_whitespace
    while @ch&.match?(/\s/)
      read_char
    end
  end

  def read_identifier
    position = @position
    while @ch&.match?(/[a-zA-Z_]/)
      read_char
    end
    @input[position...@position]
  end

  def read_number
    position = @position
    while @ch&.match?(/[0-9]/)
      read_char
    end
    @input[position...@position]
  end

  def peek_char
    if @read_position >= @input.length
      nil
    else
      @input[@read_position]
    end
  end

  def read_char
    if @read_position >= @input.length
      @ch = nil
    else
      @ch = @input[@read_position]
    end
    @position = @read_position
    @read_position += 1
  end
end
