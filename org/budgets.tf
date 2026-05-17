resource "aws_budgets_budget" "monthly_limit" {
  name              = "monthly-cost-budget"
  budget_type       = "COST"
  limit_amount      = "5.0"
  limit_unit        = "USD"
  time_unit         = "MONTHLY"
  time_period_start = formatdate("YYYY-MM-DD_00:00", "${plantimestamp()}")
}
