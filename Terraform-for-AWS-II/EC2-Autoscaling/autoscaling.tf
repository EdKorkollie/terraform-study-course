#AutoScaling Launch configuration
resource "aws_launch_configuration" "levelup-launchConfig" {
  name_prefix      = "levelup-launchConfig"
  image_id         =  lookup(var.AMIS, var.AWS_REGION)
  instance_type    = "t2.micro"
  key_name         = aws_key_pair.levelup_key.key_name 
}

#Generate key
resource "aws_key_pair" "levelup_key" {
  key_name = "levelup_key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

#Autoscaling group
resource "aws_autoscaling_group" "levelup-autoscaling" {
  name                           = "levelup-autoscalin"                                       # name of the autoscaling 
  vpc_zone_identifier            = ["us-east-1b", "us-east-1a"]                               # in which zone the instance can be launch or created
  launch_configuration           = aws_launch_configuration.levelup-launchConfig.name
  min_size                       = 1
  max_size                       = 2
  health_check_grace_period      = 200                                                        #means after 200 seconds of health check failure a new instance will be created
  health_check_type              = "EC2" 
  force_delete                   = true

  tag {
    key                          = "Name"
    value                        = "Levleup Custom EC2 instance"
    propagate_at_launch          = true  
  }  
}

#Autoscaling configuration policy - scaling alarm
resource "aws_autoscaling_policy" "levelup-cpu-policy" {
    name                         = "levelup-cpu-policy" 
    autoscaling_group_name       = aws_autoscaling_group.levelup-autoscaling.name
    adjustment_type              = "changeInCapacity"
    scaling_adjustment           = "1"                                             # it means it scale the node one by one
    cooldown                     = "200"
    policy_type                  = "SimpleScaling" 
}

# we need cloud watch to monitor the ec2 instances for autoscaling to happen
resource "aws_cloudwatch_metric_alarm" "levelup-cpu-alarm" {
  alarm_name                     = "levelup-cpu-alarm"
  alarm_description              = "Alarm once cpu uses increase"
  comparison_operator            = "GreaterThanOrEqualToThreshold"               #alarm will be trigger whenever the alarm value is greater than or equal to the threshold
  evaluation_periods             = "2"                                           # evaluation will be done two times within the selected period
  metric_name                    = "CPUUtilization"
  namespace                      = "AWS/EC2"
  period                         = "120"                                          # evaluation period is 120 seconds
  statistic                      = "Average"                                      # means in 120 seconds it will monitor two evaluation
  threshold                      = "30"                  # means in the period of 120 seconds if there are two evaluations where the average cpu usage is above 30%,then the alarm will be triggered

  dimensions = {
    "AutoScalingGroupName"       = aws_autoscaling_group.levelup-autoscaling.name
  }

  actions_enabled                = true
  alarm_actions                  = [aws_autoscaling_policy.levelup-cpu-policy.arn]     # once the alarm is triggered, what is the action that will be perform. it will apply the policy we have created above
}

#Auto descaling poliicy is required to maintain cost
resource "aws_autoscaling_policy" "levelup-cpu-policy-scaledown" {
    name                         = "levelup-cpu-policy-scaledown" 
    autoscaling_group_name       = aws_autoscaling_group.levelup-autoscaling.name
    adjustment_type              = "changeInCapacity"
    scaling_adjustment           = "-1"                                             # it means decrease the node one by one
    cooldown                     = "200"
    policy_type                  = "SimpleScaling" 
}

#Auto descaling cloud watch
resource "aws_cloudwatch_metric_alarm" "levelup-cpu-alarm-scaledown" {
  alarm_name                     = "levelup-cpu-alarm-scaledown"
  alarm_description              = "Alarm once cpu uses Decrease"
  comparison_operator            = "LessThanOrEqualToThreshold"               #alarm will be trigger whenever the alarm value is less than or equal to the threshold
  evaluation_periods             = "2"                                           # evaluation will be done two times within the selected period
  metric_name                    = "CPUUtilization"
  namespace                      = "AWS/EC2"
  period                         = "120"                                          # evaluation period is 120 seconds
  statistic                      = "Average"                                      # means in 120 seconds it will monitor two evaluation
  threshold                      = "10"                  # means in the period of 120 seconds if there are two evaluations where the average cpu usage is less than %10,then the alarm will be triggered

  dimensions = {
    "AutoScalingGroupName"       = aws_autoscaling_group.levelup-autoscaling.name
  }

  actions_enabled                = true
  alarm_actions                  = [aws_autoscaling_policy.levelup-cpu-policy-scaledown.arn]     # once the alarm is triggered, what is the action that will be perform. it will apply the policy we have created above
}


/*

to trigger the cpu usage alarm
ssh to your machine
ssh publicIp -l ubuntu -i keypairName
sudo -i
apt-get update
put some load on the machine so that the alarm will get triggered
apt-get install stress
stress --cpu 2 --timeout 300                300 = how much time we want to put stress on the machine

*/