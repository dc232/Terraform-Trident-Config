resource "kubernetes_storage_class_v1" "example" {
    depends_on = [
      helm_release.netapphelm,
      kubernetes_secret_v1.netapp,
    ]

  metadata {
    name = var.storageclass
  }
  storage_provisioner = "csi.trident.netapp.io"
  reclaim_policy      = "Delete"
  volume_binding_mode = "WaitForFirstConsumer"
  allow_volume_expansion = var.allow_volume_exspansion
  parameters = {
    backendType = "azure-netapp-files"
    csi.storage.k8s.io/fstype = "nfs"
  }
}