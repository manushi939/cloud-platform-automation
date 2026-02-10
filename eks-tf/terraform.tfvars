cluster_name           = "ixfi-stage-new"
aws_profile            = "ixfi-stage"
cluster_iam_role_arn   = "arn:aws:iam::678897693357:role/eksrole01"
node_iam_role_arn      = "arn:aws:iam::678897693357:role/eksnoderole_update"
subnet_ids             = ["subnet-e04d9fac" , "subnet-c94c83b5" , "subnet-018dcb05f01dd1be4" , "subnet-5b7ded31" , "subnet-0e1b65109fcdad9ec" , "subnet-028d93cc46ceb5b82"]
security_group_ids     = ["sg-0135cc53d92977aa6"]
node-subnet_ids        = ["subnet-018dcb05f01dd1be4" , "subnet-0e1b65109fcdad9ec" , "subnet-028d93cc46ceb5b82"]


node_groups = [
  {
    name                   = "angular-frontend-stage"
    launch_template_id     = "lt-00bb6143361d936bd"
    launch_template_version = "3"
    desired_size           = 0
    min_size               = 0
    max_size               = 6
    labels = {
      "name"      = "angular-ssr"
    }
    taints = [
      {
        key    = "name"
        value  = "angular-ssr"
        effect = "NO_SCHEDULE"
      }
    ]
  },
  {
    name                   = "backend-core-stage"
    launch_template_id     = "lt-00bb6143361d936bd"
    launch_template_version = "3"
    desired_size           = 0
    min_size               = 0
    max_size               = 3
    labels = {
      "name"      = "backend-core"
    }
    taints = [
      {
        key    = "name"
        value  = "backend-core"
        effect = "NO_SCHEDULE"
      }
    ]
  },
  {
    name                   = "backend-cron-stage"
    launch_template_id     = "lt-00bb6143361d936bd"
    launch_template_version = "3"
    desired_size           = 0
    min_size               = 0
    max_size               = 3
    labels = {
      "name"      = "backend-cron"
    }
    taints = [
      {
        key    = "name"
        value  = "backend-cron"
        effect = "NO_SCHEDULE"
      }
    ]
  },
  {
    name                   = "backend-module-stage"
    launch_template_id     = "lt-00bb6143361d936bd"
    launch_template_version = "3"
    desired_size           = 0
    min_size               = 0
    max_size               = 15
    labels = {
      "name"      = "backend-module"
    }
    taints = [
      {
        key    = "name"
        value  = "backend-module"
        effect = "NO_SCHEDULE"
      }
    ]
  },
  {
    name                   = "backend-websocket-stage"
    launch_template_id     = "lt-00bb6143361d936bd"
    launch_template_version = "3"
    desired_size           = 0
    min_size               = 0
    max_size               = 3
    labels = {
      "name"      = "backend-socket"
    }
    taints = [
      {
        key    = "name"
        value  = "backend-socket"
        effect = "NO_SCHEDULE"
      }
    ]
  },
  {
    name                   = "Binance-websocket-stage"
    launch_template_id     = "lt-00bb6143361d936bd"
    launch_template_version = "3"
    desired_size           = 0
    min_size               = 0
    max_size               = 3
    labels = {
      "name"      = "binance-route"
    }
    taints = [
      {
        key    = "name"
        value  = "binance-route"
        effect = "NO_SCHEDULE"
      }
    ]
  },
  {
    name                   = "default-nodes"
    launch_template_id     = "lt-00bb6143361d936bd"
    launch_template_version = "3"
    desired_size           = 2
    min_size               = 2
    max_size               = 5
    labels = {}
    taints = []
  },
  {
    name                   = "ixfi-user-event-websocket"
    launch_template_id     = "lt-00bb6143361d936bd"
    launch_template_version = "3"
    desired_size           = 0
    min_size               = 0
    max_size               = 5
    labels = {
      "name"      = "ixfi-user-event-websocket"
    }
    taints = [
      {
        key    = "name"
        value  = "ixfi-user-event-websocket"
        effect = "NO_SCHEDULE"
      }
    ]
  },
  {
    name                   = "ixfi-userwebsocket-stage"
    launch_template_id     = "lt-00bb6143361d936bd"
    launch_template_version = "3"
    desired_size           = 0
    min_size               = 0
    max_size               = 3
    labels = {
      "name"      = "userevent-websocket"
    }
    taints = [
      {
        key    = "name"
        value  = "userevent-websocket"
        effect = "NO_SCHEDULE"
      }
    ]
  },
  {
    name                   = "kafka"
    launch_template_id     = "lt-00bb6143361d936bd"
    launch_template_version = "3"
    desired_size           = 0
    min_size               = 0
    max_size               = 3
    labels = {
      "app"      = "kafka"
    }
    taints = [
      {
        key    = "app"
        value  = "kafka"
        effect = "NO_SCHEDULE"
      }
    ]
  },
  {
    name                   = "market-data-consumer-publisher"
    launch_template_id     = "lt-00bb6143361d936bd"
    launch_template_version = "3"
    desired_size           = 0
    min_size               = 0
    max_size               = 5
    labels = {
      "name"      = "market-data-consumer-publisher"
    }
    taints = [
      {
        key    = "name"
        value  = "market-data-consumer-publisher"
        effect = "NO_SCHEDULE"
      }
    ]
  },
  {
    name                   = "vpa-multi-service-stage"
    launch_template_id     = "lt-00bb6143361d936bd"
    launch_template_version = "6"
    desired_size           = 0
    min_size               = 0
    max_size               = 3
    labels = {
      "name"      = "vpa-multi-service"
    }
    taints = [
      {
        key    = "name"
        value  = "vpa-multi-service"
        effect = "NO_SCHEDULE"
      }
    ]
  }
]
