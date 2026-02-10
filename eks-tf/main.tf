provider "aws" {
  region = var.region
  profile = var.aws_profile
}

resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.cluster_iam_role_arn

  version = var.k8s_version

  vpc_config {
    subnet_ids              = var.subnet_ids
    security_group_ids      = var.security_group_ids
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
  }

}

# Node groups with custom names and launch templates
resource "aws_eks_node_group" "this" {
  for_each        = { for ng in var.node_groups : ng.name => ng }

  cluster_name    = aws_eks_cluster.this.name
  node_group_name = each.value.name
  subnet_ids      = var.node-subnet_ids
  node_role_arn   = var.node_iam_role_arn

  launch_template {
    id      = each.value.launch_template_id
    version = each.value.launch_template_version
  }

  scaling_config {
    desired_size = each.value.desired_size
    min_size     = each.value.min_size
    max_size     = each.value.max_size
  }

  labels = each.value.labels

  dynamic "taint" {
    for_each = each.value.taints
    content {
      key    = taint.value.key
      value  = taint.value.value
      effect = taint.value.effect
    }
  }

  update_config {
    max_unavailable = 1
  }

}

# EKS Add-ons
resource "aws_eks_addon" "vpc_cni" {
  cluster_name       = aws_eks_cluster.this.name
  addon_name         = "vpc-cni"
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name       = aws_eks_cluster.this.name
  addon_name         = "kube-proxy"
}

data "template_file" "aws_auth" {
  template = file("${path.module}/aws-auth-configmap.yaml.tpl")

  vars = {
    node_role_arn = var.node_iam_role_arn
  }
}

resource "null_resource" "aws_auth_configmap" {
  depends_on = [aws_eks_cluster.this]

  provisioner "local-exec" {
    command = <<EOT
      aws eks update-kubeconfig --region ${var.region} --name ${aws_eks_cluster.this.name} --profile ${var.aws_profile}
      echo '${data.template_file.aws_auth.rendered}' | kubectl apply -f -
    EOT
  }
}
