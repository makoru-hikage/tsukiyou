resource "aws_budgets_budget" "moon_estate_budget" {
  name              = "moon-estate-budget"
  budget_type       = "COST"
  limit_amount      = "50"
  limit_unit        = "USD"
  time_period_start = "2026-03-01_00:00"
  time_unit         = "MONTHLY"

  cost_types {
    include_tax          = true
    include_subscription = true
    include_refund       = false
    include_credit       = false # IMPORTANT: Set to false to see "Real" cost vs your Free credits
    use_blended          = false
  }

  # Notification 1: The 'Caution' at 50%
  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 50
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.the_developer_email]
  }

  # Notification 2: The 'Alarm' at 85%
  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 85
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.the_developer_email]
  }
}
