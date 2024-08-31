resource "aws_lb" "my_lb" {
  name               = "devops-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.my_sg.id]
  subnets = [aws_subnet.public_sub1.id]
  enable_deletion_protection = true

#  access_logs {
#    bucket  = aws_s3_bucket.lb_logs.id
#    prefix  = "test-lb"
#    enabled = true
#  }

  tags = {
    Environment = "production"
  }
}



resource "aws_lb_target_group" "my_tg" {
  name     = "tf-my-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_VPC.id

  target_group_health {
    dns_failover {
      minimum_healthy_targets_count      = "1"
      minimum_healthy_targets_percentage = "off"
    }

    unhealthy_state_routing {
      minimum_healthy_targets_count      = "1"
      minimum_healthy_targets_percentage = "off"
    }
  }
}


resource "aws_lb_target_group_attachment" "attach-tg" {
  target_group_arn = aws_lb_target_group.my_tg.arn
  target_id        = aws_instance.private1_instance.id
#  target_id        = aws_instance.private2_instance.id
  port             = 80
}


