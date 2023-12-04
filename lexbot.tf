resource "aws_lex_bot" "shoey" {
  abort_statement {
    message {
      content      = "Sorry, your babe can't have shoes now"
      content_type = "PlainText"
    }
  }

  child_directed = false

  clarification_prompt {
    max_attempts = 3

    message {
      content      = "I didn't understand you, what would you like to do?"
      content_type = "PlainText"
    }
  }

  create_version              = false
  description                 = "Bot to talk about shoes"
  idle_session_ttl_in_seconds = 600

  intent {
    intent_name    = "OrderShoes"
    intent_version = "1"
  }

  locale           = "en-US"
  name             = "OrderShoes"
  process_behavior = "BUILD"
  voice_id         = "Salli"
}