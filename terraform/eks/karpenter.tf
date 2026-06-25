# ============================================================
# terraform/eks/karpenter.tf
# PURPOSE: Karpenter node autoscaler
# ============================================================

resource "helm_release" "karpenter" {
  name             = "karpenter"
  repository       = "oci://public.ecr.aws/karpenter"
  chart            = "karpenter"
  namespace        = "karpenter"
  version          = "1.0.8"
  create_namespace = true
  wait             = true
  timeout          = 300
  atomic           = true

  set {
    name  = "settings.aws.clusterName"
    value = aws_eks_cluster.main.name
  }

  set {
    name  = "settings.aws.clusterEndpoint"
    value = aws_eks_cluster.main.endpoint
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.karpenter.arn
  }

  set {
    name  = "settings.aws.defaultInstanceProfile"
    value = aws_iam_instance_profile.karpenter.name
  }

  depends_on = [
    aws_eks_node_group.main,
    aws_iam_role_policy_attachment.karpenter,
    helm_release.aws_load_balancer_controller,
  ]
}
