# Autoscaling

terraform {
    source = "../../..//modules/aws-app-autoscaling-ecs"
}

include {
    path = find_in_parent_folders()
}

locals {
    stage_vars = yamldecode(file(find_in_parent_folders("stage_vars.yml")))
    project_vars = yamldecode(file(find_in_parent_folders("project_vars.yml")))
}

inputs = {
    stage_slug = local.stage_vars.stage_slug

    services = {
        backend: {
            cluster: dependency.loadbalancer.outputs.cluster_name # Name of the ECS cluster in which the service resides
            service: dependency.backend.outputs.ecs_service_name # Name of the service to autoscale
            min_capacity: dependency.backend.outputs.ecs_service_desired_count # Minimum amount of desired service containers running
            max_capacity: 5 # Maximum amount of desired service containers
            up_cooldown: 10 # Amount of seconds that needs to pass before another scale up action can be preformed
            down_cooldown: 60 # Amount of seconds that needs to pass before another scale down action can be preformed
            metric_lower_bound: 0 # How big can difference between the alarm threshold and the CloudWatch metric be for scaling up
            metric_upper_bound: 0 # How big can difference between the alarm threshold and the CloudWatch metric be for scaling down
            scaling_up_adjustment: 1 # How much should desired_count change on scale up -- this number should be positive (ie. if scaling_up_adjustment=2 you have 2 running containers, scale up is fired after it desired_count will equal 4)
            scaling_down_adjustment: -1 # How much should desired_count change on scale up -- this number should be negative (ie. if scaling_up_adjustment=-2 you have 4 running containers, scale down is fired after it desired_count will equal 2)
        }
    }

    scale_up_alarms = {
        myapp-dev-backend_cpu_above_40: {
            service_key: "backend" # service_key set in services variable, so CloudWatch alarm knows which service to monitor
            operator: "GreaterThanOrEqualToThreshold" # How should threshold compare to metric (Possible values: "GreaterThanOrEqualToThreshold", "GreaterThanThreshold", "LessThanThreshold", "LessThanOrEqualToThreshold")
            evaluation_periods: 1 # The number of periods over which data is compared to the specified threshold
            metric_name: "CPUUtilization" # Name of metric for alarm (Possible values: "CPUReservation", "CPUUtilization", "MemoryReservation", "MemoryUtilization", "GPUReservation")
            period: 60 # Amount of seconds before metric is applied
            threshold: 40 # Value against which statistic is compared
            datapoints: 1 # Amount of dataponts that must be breaching alarm
            statistic: "Maximum" # The statistic to apply to alarms metric (Possible values: "SampleCount", "Average", "Sum", "Minimum", "Maximum")
        }
    }

    scale_down_alarms = {
        myapp-dev-backend_cpu_below_40: {
            service_key: "backend" # service_key set in services variable, so CloudWatch alarm knows which service to monitor
            operator: "LessThanOrEqualToThreshold" # How should threshold compare to metric (Possible values: "GreaterThanOrEqualToThreshold", "GreaterThanThreshold", "LessThanThreshold", "LessThanOrEqualToThreshold")
            evaluation_periods: 1 # The number of periods over which data is compared to the specified threshold
            metric_name: "CPUUtilization" # Name of metric for alarm (Possible values: "CPUReservation", "CPUUtilization", "MemoryReservation", "MemoryUtilization", "GPUReservation")
            period: 300 # Amount of seconds before metric is applied
            threshold: 39 # Value against which statistic is compared
            datapoints: 1 # Amount of dataponts that must be breaching alarm
            statistic: "Maximum" # The statistic to apply to alarms metric (Possible values: "SampleCount", "Average", "Sum", "Minimum", "Maximum")
        }
    }
}

# backend
dependency "backend" {
    config_path = "../backend"
}

# load balancer
dependency "loadbalancer" {
    config_path = "../loadbalancer"
}
