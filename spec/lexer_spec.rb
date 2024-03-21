require 'minitest/autorun'
require 'minitest/spec'
require_relative '../lib/monkey/lexer'

describe Lexer do
  describe '#next_token' do
    TOKEN_TYPES = Lexer::TOKEN_TYPES
    Token = Lexer::Token

    it 'splits the input into tokens' do
      input = <<~MONKEY
        let five = 5;
        let ten = 10;

        let add = fn(x, y) {
          x + y;
        };

        let result = add(five, ten);
        !-/*5;
        5 < 10 > 5;

        if (5 < 10) {
          return true;
        } else {
          return false;
        }

        10 == 10;
        10 != 9;
      MONKEY
      lexer = Lexer.new(input)

      tokens = []
      loop do
        token = lexer.next_token
        tokens << token
        break if token.type == TOKEN_TYPES[:EOF]
      end

      expect(tokens).must_equal([
        Token.new(type: TOKEN_TYPES[:LET], literal: 'let'),
        Token.new(type: TOKEN_TYPES[:IDENT], literal: 'five'),
        Token.new(type: TOKEN_TYPES[:ASSIGN], literal: '='),
        Token.new(type: TOKEN_TYPES[:INT], literal: '5'),
        Token.new(type: TOKEN_TYPES[:SEMICOLON], literal: ';'),

        Token.new(type: TOKEN_TYPES[:LET], literal: 'let'),
        Token.new(type: TOKEN_TYPES[:IDENT], literal: 'ten'),
        Token.new(type: TOKEN_TYPES[:ASSIGN], literal: '='),
        Token.new(type: TOKEN_TYPES[:INT], literal: '10'),
        Token.new(type: TOKEN_TYPES[:SEMICOLON], literal: ';'),

        Token.new(type: TOKEN_TYPES[:LET], literal: 'let'),
        Token.new(type: TOKEN_TYPES[:IDENT], literal: 'add'),
        Token.new(type: TOKEN_TYPES[:ASSIGN], literal: '='),
        Token.new(type: TOKEN_TYPES[:FUNCTION], literal: 'fn'),
        Token.new(type: TOKEN_TYPES[:LPAREN], literal: '('),
        Token.new(type: TOKEN_TYPES[:IDENT], literal: 'x'),
        Token.new(type: TOKEN_TYPES[:COMMA], literal: ','),
        Token.new(type: TOKEN_TYPES[:IDENT], literal: 'y'),
        Token.new(type: TOKEN_TYPES[:RPAREN], literal: ')'),
        Token.new(type: TOKEN_TYPES[:LBRACE], literal: '{'),
        Token.new(type: TOKEN_TYPES[:IDENT], literal: 'x'),
        Token.new(type: TOKEN_TYPES[:PLUS], literal: '+'),
        Token.new(type: TOKEN_TYPES[:IDENT], literal: 'y'),
        Token.new(type: TOKEN_TYPES[:SEMICOLON], literal: ';'),
        Token.new(type: TOKEN_TYPES[:RBRACE], literal: '}'),
        Token.new(type: TOKEN_TYPES[:SEMICOLON], literal: ';'),

        Token.new(type: TOKEN_TYPES[:LET], literal: 'let'),
        Token.new(type: TOKEN_TYPES[:IDENT], literal: 'result'),
        Token.new(type: TOKEN_TYPES[:ASSIGN], literal: '='),
        Token.new(type: TOKEN_TYPES[:IDENT], literal: 'add'),
        Token.new(type: TOKEN_TYPES[:LPAREN], literal: '('),
        Token.new(type: TOKEN_TYPES[:IDENT], literal: 'five'),
        Token.new(type: TOKEN_TYPES[:COMMA], literal: ','),
        Token.new(type: TOKEN_TYPES[:IDENT], literal: 'ten'),
        Token.new(type: TOKEN_TYPES[:RPAREN], literal: ')'),
        Token.new(type: TOKEN_TYPES[:SEMICOLON], literal: ';'),

        Token.new(type: TOKEN_TYPES[:BANG], literal: '!'),
        Token.new(type: TOKEN_TYPES[:MINUS], literal: '-'),
        Token.new(type: TOKEN_TYPES[:SLASH], literal: '/'),
        Token.new(type: TOKEN_TYPES[:ASTERISK], literal: '*'),
        Token.new(type: TOKEN_TYPES[:INT], literal: '5'),
        Token.new(type: TOKEN_TYPES[:SEMICOLON], literal: ';'),

        Token.new(type: TOKEN_TYPES[:INT], literal: '5'),
        Token.new(type: TOKEN_TYPES[:LT], literal: '<'),
        Token.new(type: TOKEN_TYPES[:INT], literal: '10'),
        Token.new(type: TOKEN_TYPES[:GT], literal: '>'),
        Token.new(type: TOKEN_TYPES[:INT], literal: '5'),
        Token.new(type: TOKEN_TYPES[:SEMICOLON], literal: ';'),

        Token.new(type: TOKEN_TYPES[:IF], literal: 'if'),
        Token.new(type: TOKEN_TYPES[:LPAREN], literal: '('),
        Token.new(type: TOKEN_TYPES[:INT], literal: '5'),
        Token.new(type: TOKEN_TYPES[:LT], literal: '<'),
        Token.new(type: TOKEN_TYPES[:INT], literal: '10'),
        Token.new(type: TOKEN_TYPES[:RPAREN], literal: ')'),
        Token.new(type: TOKEN_TYPES[:LBRACE], literal: '{'),
        Token.new(type: TOKEN_TYPES[:RETURN], literal: 'return'),
        Token.new(type: TOKEN_TYPES[:TRUE], literal: 'true'),
        Token.new(type: TOKEN_TYPES[:SEMICOLON], literal: ';'),
        Token.new(type: TOKEN_TYPES[:RBRACE], literal: '}'),
        Token.new(type: TOKEN_TYPES[:ELSE], literal: 'else'),
        Token.new(type: TOKEN_TYPES[:LBRACE], literal: '{'),
        Token.new(type: TOKEN_TYPES[:RETURN], literal: 'return'),
        Token.new(type: TOKEN_TYPES[:FALSE], literal: 'false'),
        Token.new(type: TOKEN_TYPES[:SEMICOLON], literal: ';'),
        Token.new(type: TOKEN_TYPES[:RBRACE], literal: '}'),

        Token.new(type: TOKEN_TYPES[:INT], literal: '10'),
        Token.new(type: TOKEN_TYPES[:EQ], literal: '=='),
        Token.new(type: TOKEN_TYPES[:INT], literal: '10'),
        Token.new(type: TOKEN_TYPES[:SEMICOLON], literal: ';'),
        Token.new(type: TOKEN_TYPES[:INT], literal: '10'),
        Token.new(type: TOKEN_TYPES[:NOT_EQ], literal: '!='),
        Token.new(type: TOKEN_TYPES[:INT], literal: '9'),
        Token.new(type: TOKEN_TYPES[:SEMICOLON], literal: ';'),

        Token.new(type: TOKEN_TYPES[:EOF], literal: nil),
      ])
    end
  end
end
