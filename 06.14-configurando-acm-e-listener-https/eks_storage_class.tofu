resource "kubernetes_storage_class_v1" "gp3" {

  metadata {
    name = "gp3"

    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }

  storage_provisioner = "ebs.csi.aws.com"

  # WaitForFirstConsumer: o volume so e criado quando o Pod e agendado, porque
  # um volume EBS vive dentro de uma unica AZ. E o mesmo comportamento da
  # StorageClass standard do Kind, agora com consequencia real.
  volume_binding_mode    = "WaitForFirstConsumer"
  reclaim_policy         = "Delete"
  allow_volume_expansion = true

  parameters = {
    type      = "gp3"
    encrypted = "true"
    fsType    = "ext4"
  }

  depends_on = [aws_eks_addon.csi_driver]
}

resource "kubernetes_annotations" "gp2_not_default" {

  api_version = "storage.k8s.io/v1"
  kind        = "StorageClass"
  force       = true

  metadata {
    name = "gp2"
  }

  annotations = {
    "storageclass.kubernetes.io/is-default-class" = "false"
  }
}