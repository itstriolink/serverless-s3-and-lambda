# ECS autoscaling

## Usage
Copy this folder to your infrastructure modules, then in your stages where you want scaling open new folder (lets call it `autoscaling`).
In `autoscaling` folder create new file `terragrunt.hcl` Example content can be found in examples.

To the ECS service you want to auto-scale `override.tf` file with following content:
```terraform
/**
* Povio Terraform PS1
* Version 2.0
*
* This file needs to be copied to folder containing terragrunt.hcl file for ECS setup
* where you want to enable autoscaling
*/

resource "aws_ecs_service" "this" {
  lifecycle {
    ignore_changes = [
      task_definition,
      desired_count
    ]
  }
}
```
This file is needed because we need to disable terraform from detecting changes to ECS service desired_count variable.
If we do not disable that, terraform will constantly try to change to a value set in original configuration.

## Variables
1. `cluster` -> Name of cluster in which service is located
2. `service` -> Name of service to scale
3. `queues` -> Names of queues by which to scale
4. `min_capacity` -> Min capacity of service (must be >= 0)
5. `max_capacity` -> Max capacity of service (must be greater than `min_capacity`)
6. `up_cooldown` -> Cooldown between scaling up in seconds
7. `down_cooldown` -> Cooldown between scaling down in seconds
8. `scaling_up_adjustment` -> How many services should be added on scale up
9. `scaling_down_adjustment` -> How many services should be removed on scale down (should be negative number)
10. `metric_lower_bound` -> Lower bound for the difference between the alarm threshold and the CloudWatch metric
11. `metric_upper_bound` -> Upper bound for the difference between the alarm threshold and the CloudWatch metric
