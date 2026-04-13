resource "aws_sns_topic" "lambda_alerts" {
  name = "${var.project_name}-lambda-alerts"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.lambda_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

resource "aws_cloudwatch_metric_alarm" "lambda_error_rate" {
  alarm_name          = "${var.project_name}-lambda-error"
  alarm_description   = "Alerts when the visitor counter Lambda has any errors in a 5-minute window."
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  threshold           = 0
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.lambda_alerts.arn]

  metric_query {
    id = "errors"

    metric {
      metric_name = "Errors"
      namespace   = "AWS/Lambda"
      period      = 300
      stat        = "Sum"
      dimensions = {
        FunctionName = aws_lambda_function.visitor_counter.function_name
      }
    }
  }

  metric_query {
    id = "invocations"

    metric {
      metric_name = "Invocations"
      namespace   = "AWS/Lambda"
      period      = 300
      stat        = "Sum"
      dimensions = {
        FunctionName = aws_lambda_function.visitor_counter.function_name
      }
    }
  }

  metric_query {
    id          = "error_rate"
    expression  = "IF(invocations > 0, errors / invocations * 100, 0)"
    label       = "Lambda Error Rate"
    return_data = true
  }
}

resource "aws_cloudwatch_metric_alarm" "lambda_duration_p95" {
  alarm_name          = "${var.project_name}-lambda-duration"
  alarm_description   = "Alerts when the visitor counter Lambda p95 duration exceeds 3000ms."
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  threshold           = 3000
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.lambda_alerts.arn]
  namespace           = "AWS/Lambda"
  metric_name         = "Duration"
  period              = 300
  extended_statistic  = "p95"

  dimensions = {
    FunctionName = aws_lambda_function.visitor_counter.function_name
  }
}

resource "aws_cloudwatch_metric_alarm" "lambda_throttles" {
  alarm_name          = "${var.project_name}-lambda-throttle"
  alarm_description   = "Alerts when the visitor counter Lambda is throttled in a 5-minute window."
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  threshold           = 0
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.lambda_alerts.arn]
  namespace           = "AWS/Lambda"
  metric_name         = "Throttles"
  period              = 300
  statistic           = "Sum"

  dimensions = {
    FunctionName = aws_lambda_function.visitor_counter.function_name
  }
}
