variable "notification_email" {
  type        = string
  description = "The email address to receive AWS Budget alerts."
  sensitive   = true
}

locals {
  budget_limit = "5.0"
}

resource "aws_sns_topic" "cost_alerts" {
  name = "aws-cost-alerts-topic"
}

resource "aws_sns_topic_subscription" "email_sub" {
  topic_arn = aws_sns_topic.cost_alerts.arn
  protocol  = "email"
  endpoint  = var.notification_email
}

resource "aws_budgets_budget" "monthly_limit" {
  name              = "monthly-cost-budget"
  budget_type       = "COST"
  limit_amount      = local.budget_limit
  limit_unit        = "USD"
  time_unit         = "MONTHLY"
  time_period_start = formatdate("YYYY-MM-DD_00:00", "${plantimestamp()}")

  notification {
    comparison_operator       = "GREATER_THAN"
    threshold                 = 80.0
    threshold_type            = "PERCENTAGE"
    notification_type         = "FORECASTED"
    subscriber_sns_topic_arns = [aws_sns_topic.cost_alerts.arn]
  }

  notification {
    comparison_operator       = "GREATER_THAN"
    threshold                 = 100.0
    threshold_type            = "PERCENTAGE"
    notification_type         = "ACTUAL"
    subscriber_sns_topic_arns = [aws_sns_topic.cost_alerts.arn]
  }
}

resource "aws_ce_anomaly_monitor" "account_monitor" {
  name              = "AWS Services"
  monitor_type      = "DIMENSIONAL"
  monitor_dimension = "SERVICE"
}

resource "aws_ce_anomaly_subscription" "anomaly_alerts" {
  name             = "anomaly-cost-alerts-subscription"
  frequency        = "DAILY"
  monitor_arn_list = [aws_ce_anomaly_monitor.account_monitor.arn]

  threshold_expression {
    dimension {
      key           = "ANOMALY_TOTAL_IMPACT_ABSOLUTE"
      match_options = ["GREATER_THAN_OR_EQUAL"]
      values        = [local.budget_limit]
    }
  }

  subscriber {
    type    = "EMAIL"
    address = var.notification_email
  }
}
