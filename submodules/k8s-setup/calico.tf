
resource "helm_release" "calico" {
  name             = "calico-tigera-operator"
  repository       = "https://docs.projectcalico.org/charts"
  chart            = "tigera-operator"
  version          = var.add_ons.calico.version
  namespace        = "tigera-operator"
  create_namespace = true
  # depends_on       = [docker_container.mallory]
}



## Using the manifest also forces for a multistage aply, to create the manifests from data then to read the manifests, data->data-> fails the foe each or count
# https://medium.com/@danieljimgarcia/dont-use-the-terraform-kubernetes-manifest-resource-6c7ff4fe629a

# kubectl_provider does not have the https_proxy yet https://github.com/gavinbunney/terraform-provider-kubectl/issues/178

# │ Error: Failed to determine GroupVersionResource for manifest
# │
# │   with module.k8s_setup[0].kubernetes_manifest.calico_operator[25],
# │   on submodules/k8s-setup/calico.tf line 36, in resource "kubernetes_manifest" "calico_operator":
# │   36: resource "kubernetes_manifest" "calico_operator" {
# │
# │ no matches for kind "Installation" in group "operator.tigera.io"

# locals {
#   calico = {
#     operator_filename    = "${path.module}/calico/calico-operator.yaml"
#     operator_url         = "https://raw.githubusercontent.com/aws/amazon-vpc-cni-k8s/v1.11.0/config/master/calico-operator.yaml"
#     custom_resources_url = "https://raw.githubusercontent.com/aws/amazon-vpc-cni-k8s/v1.11.0/config/master/calico-crs.yaml"


#   }
# }

# data "http" "calico_operator" {
#   url = local.calico["operator_url"]
# }

# data "http" "calico_crs" {
#   url = local.calico["custom_resources_url"]
# }


# resource "local_file" "calico_operator" {
#   content  = data.http.calico_operator.response_body
#   filename = local.calico["operator_filename"]
# }


# data "kubectl_file_documents" "calico_operator" {
#   content = data.http.calico_operator.response_body
# }

# locals {
#   calico_manifests = concat([for m in data.kubectl_file_documents.calico_operator.documents : yamldecode(m)], [yamldecode(data.http.calico_crs.response_body)])
# }

# resource "kubernetes_manifest" "calico_operator" {
#   count      = var.k8s_pre_setup ? 0 : length(local.calico_manifests)
#   manifest   = { for k, v in local.calico_manifests[count.index] : k => v if k != "status" }
#   depends_on = [docker_container.mallory]
# }


# # resource "kubernetes_manifest" "calico_crs" {
# #   count      = var.k8s_pre_setup ? 0 : 1
# #   manifest   = yamldecode(data.http.calico_crs.response_body)
# #   depends_on = [docker_container.mallory, kubernetes_manifest.calico_operator]
# # }


# data "kubectl_file_documents" "calico_crs" {
#   content = data.http.calico_operator.response_body
# }

# resource "kubernetes_manifest" "calico_operator" {
#   count = length(data.kubectl_file_documents.calico_operator.documents)
#   # count      = length(local.calico_operator_manifests)
#   # manifest   = local.calico_operator_manifests[count.index]
#   manifest   = yamldecode(element(data.kubectl_file_documents.calico_operator.documents, count.index))
#   depends_on = [data.kubectl_file_documents.calico_operator]
# }



# resource "kubectl_manifest" "calico_crs" {
#   for_each   = lookup(local.calico_manifests, "crs", false) == false ? {} : { "" = "" }
#   yaml_body  = each.value
#   depends_on = [kubectl_manifest.calico_operator]
# }





# resource "local_file" "calico_manifests" {
#   count    = length(local.calico_operator_manifests)
#   content  = local.calico_operator_manifests[count.index]
#   filename = "./calico/calico-${count.index}.yaml"
# }

# resource "kubernetes_manifest" "calico_operator" {
#   for_each = fileset("${path.module}/../calico", "*")
#   # count      = length(local.calico_operator_manifests)
#   # manifest   = local.calico_operator_manifests[count.index]
#   manifest   = yamldecode(file(each.key))
#   depends_on = [docker_container.mallory, local_file.calico_manifests]
# }


# resource "kubernetes_manifest" "calico_crs" {
#   manifest   = yamldecode(data.http.calico_crs.response_body)
#   depends_on = [docker_container.mallory, kubernetes_manifest.calico_operator]
# }

# resource "kubectl_manifest" "calico_operator" {
#   # count      = length(local.calico_operator_manifests)
#   for_each = fileset("${path.module}/../calico", "*")
#   # yaml_body  = local.calico_operator_manifests[count.index]
#   yaml_body  = file(each.key)
#   depends_on = [local_file.calico_manifests, docker_container.mallory]
# }


# resource "kubectl_manifest" "calico_crs" {
#   yaml_body  = data.http.calico_crs.response_body
#   depends_on = [docker_container.mallory, kubectl_manifest.calico_operator]
# }
