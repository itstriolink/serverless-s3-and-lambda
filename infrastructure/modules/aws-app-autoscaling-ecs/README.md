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
1. `services` -> list of ECS services you want to enable autoscaling for:
    - this variable consist of a map in form
   ```
    <service_key>: {
      cluster: string - Name of the ECS cluster in which the service resides
      service: string - Name of the service to autoscale
      min_capacity: number - Minimum amount of desired service containers running
      max_capacity: number - Maximum amount of desired ervice containers
      up_cooldown: number - Amount of seconds that needs to pass before another scale up action can be preformed
      down_cooldown: number - Amount of seconds that needs to pass before another scale down action can be preformed
      metric_lower_bound: number - How big can difference between the alarm threshold and the CloudWatch metric be for scaling up
      metric_upper_bound: number - How big can difference between the alarm threshold and the CloudWatch metric be for scaling down
      scaling_up_adjustment: number - How much should desired_count change on scale up -- this number should be positive (ie. if scaling_up_adjustment=2 you have 2 running containers, scale up is fired after it desired_count will equal 4)
      scaling_down_adjustment: number - How much should desired_count change on scale up -- this number should be negative (ie. if scaling_up_adjustment=-2 you have 4 running containers, scale down is fired after it desired_count will equal 2)
   }
   ```
2. `scale_up_alarms` -> Alarms that will trigger scale up actions
   - this variable consist of a map in form
    ```
    <alarm_name>: {
      service_key: string - service_key set in services variable, so CloudWatch alarm knows which service to monitor
      operator: string - How should threshold compare to metric (Possible values: "GreaterThanOrEqualToThreshold", "GreaterThanThreshold", "LessThanThreshold", "LessThanOrEqualToThreshold")
      evaluation_periods: number - The number of periods over which data is compared to the specified threshold
      metric_name: string - Name of metric for alarm (Possible values: "CPUReservation", "CPUUtilization", "MemoryReservation", "MemoryUtilization", "GPUReservation")
      period: number - Amount of seconds before metric is applied
      threshold: number - Value against which statistic is compared
      datapoints: number - Amount of dataponts that must be breaching alarm
      statistic: string - The statistic to apply to alarms metric (Possible values: "SampleCount", "Average", "Sum", "Minimum", "Maximum")
    }
    ```
3. `scale_down_alarms` -> Alarms that will trigger scale down actions
    - this variable consist of a map in form
    ```
    <alarm_name>: {
      service_key: string - service_key set in services variable, so CloudWatch alarm knows which service to monitor
      operator: string - How should threshold compare to metric (Possible values: "GreaterThanOrEqualToThreshold", "GreaterThanThreshold", "LessThanThreshold", "LessThanOrEqualToThreshold")
      evaluation_periods: number - The number of periods over which data is compared to the specified threshold
      metric_name: string - name of metric for alarm (Possible values: "CPUReservation", "CPUUtilization", "MemoryReservation", "MemoryUtilization", "GPUReservation")
      period: number - Amount of seconds before metric is applied
      threshold: number - Value against which statistic is compared
      datapoints: number - Amount of dataponts that must be breaching alarm
      statistic: string - The statistic to apply to alarms metric (Possible values: "SampleCount", "Average", "Sum", "Minimum", "Maximum")
    }
    ```
