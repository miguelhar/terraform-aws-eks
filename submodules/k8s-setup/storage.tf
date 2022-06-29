

# resource "helm_release" "ebs_csi_driver" {
#   name             = "calico-tigera-operator"
#   repository       = "https://docs.projectcalico.org/charts"
#   chart            = "tigera-operator"
#   version          = var.add_ons.calico.version
#   namespace        = "tigera-operator"
#   create_namespace = true
#   depends_on       = [docker_container.mallory]
# }

# resource "helm_release" "efs_csi_driver" {
#   repository          = "oci://gcr.io/domino-eng-service-artifacts"
#   chart               = "aws-efs-csi-driver"
#   name                = "aws-efs-csi-driver"
#   version             = "2.2.5-0.0.3"
#   repository_username = "_json_key"
#   repository_password = base64decode("ewogICJ0eXBlIjogInNlcnZpY2VfYWNjb3VudCIsCiAgInByb2plY3RfaWQiOiAiZG9taW5vLWVuZy1zZXJ2aWNlLWFydGlmYWN0cyIsCiAgInByaXZhdGVfa2V5X2lkIjogIjM3ZGFiOTA4ZGRmZjUzZDAwY2I3ZTIxZjc1ZDNhN2FlNGEzNjIxMWMiLAogICJwcml2YXRlX2tleSI6ICItLS0tLUJFR0lOIFBSSVZBVEUgS0VZLS0tLS1cbk1JSUV2UUlCQURBTkJna3Foa2lHOXcwQkFRRUZBQVNDQktjd2dnU2pBZ0VBQW9JQkFRQ293V0ZPV1hZd1hlU0lcbjd3ZkNUZk5RMktNTE92ZEJrNElscmNRVGpqZGx4Q1dFSTE2RWtkUksvZDE1bk4yOXR1QzAwQ2dLSnBrRHdXNGVcblY4VXFmMnJqcXdVaTBKdUlZWGlEb2pOMnE2eDlUNkFhcU5yNldWdVJBSFJBZmIrSmVoMHlUSmV3MHNGQ0F1Vk9cbks5Ni9GMWNEUHQ2QkNpckFaQjBVbE5jeTczeUE5d3VlT3FvK0xRQzVyc1YxZlNtdkM3bzQ2V20rWUtPZkxPS2JcbndLT2FOdXNKSHdKQUhCcCs5a2x4K3gzQ1VBZ0hUclN1bDJ0TG0zaTNEZVozbjdPcVE4dGRId2RGU1V0M0EzdTdcbk1LUDFsa1lqZFZRckdWQkgzWStxS0ZzU1pCYzd1ZTZEK2lzWmU3U0dMUnJiQnN2Mzlwa3I5bi94WEY2cktsd3VcbkNLVE9NZlM1QWdNQkFBRUNnZ0VBSnBvWHAxdTArcUxicmt3Wk53UHNPc3ZYWGZBRzA3QUpseE5jMVFsVTJEbEtcblNLUHJrTUVuOGVDSTJ6TDhFUlBHYW0zc0hzaE4rNnN4UkkwWXU1d3FaL284b2taY01aSDBSbzRobmcxdWx6cVJcbjJjOVN5ZTRMVVV1c2kvMEh4WXVTcHFrWkVOaGczemY0Mm8wVDlwdkE2bXZrNjFrWFJ1dVBzRi9NcXlqWGpzczBcbjk2M01aYmVObWYwSHBubmh6eWpWeDkxa0ZYR1Y4b3pFVi9SZGhLSGxrY2kvTTZOREpSSzdmdllDblRBa2RFZVhcbndNUEFEMjVwYUs4amF2V1hoTXh4U1k3NjhzaEtPR2V5eHVRYS9YWW1sd0hKdXdmOUZDUjdSMURiblpRc2hJRXpcbjgrZWdJMVlidEliZm4xM0tkYTVkbWVXcmdRNU9YL293eFkzcXZjamh4UUtCZ1FEVUluVkk0RjZUZXpmb3hMQUhcbjRuQ3FTcjhlemlwMHNKSk5aQ0ZmL0hXNjRibS9NRElJdUJPQ1cyejNZWWxuZC9HRUdJdy9UY2FpRXBDUnZsamlcbnhWNExNOGhDVlRXejlMMGhES1Jib0pPamc5SitKeEJueW5JWGNBUzQyd2ZZTVd3NU9JN2RLMWVGQkVZdzNkOWFcbnprVDZrdkFVTks0c0xFUWJLQ20xOFRBYURRS0JnUURMcHBwckkyV0hNZ3dmU3l4bi9OeWUxQkxPQVJmZzRZbGJcbjBJNk5CQkVDWk51RGVpZzltU3gvRGpyMXVCUjlhdXJjZUJVbjk0V2w5OTZpMStkRXMzN1ZKUFZmWkRPNjRUbjlcbjdiaUFEMzBxNzJDaVo1MElnYURQVVMxdzZzZU84NWl0K0o0VjFxUERyTHpGUjFDbzBnSWhpVzhLNFBuT0lhc2dcblRlQWZsWEQyWFFLQmdCZEE3N3BkWGdDc3NTUkM2MGp4K1lleFNlSUdsNERUR2phQmsyY0NOYVdXdU5YTVlxK3hcbi9mRjhOQ1dwKzNYc0gvMXE4M1M5QWRraVQ5YXFGdlJFemxwTUF0ZkNuM0JxazVEYjRlaHBZY1c2M1lnV29DWEFcbmUyRTJWazR0TkY3dWkvNTV4SzlaNE80ajJjM2hoR3BmMGcvbHE0dUxlc3c4emZwc0hLWmxHZkRCQW9HQWVKN2dcblBXOEV0cFBWREQvNU9FcFQzaHNjWERuWGk5SHFDcUMzbmh4M2VxU0VSQlo1ZVNxZGFVL2phaUN5dWlvMm00amdcbmR3Q3JmMGNWN2Z2Vk5pTGVqNTVKVzB1OVBBWWsxQnNXT1h0ekZwZ2I4M1ZOVkhsNjV2QmM2dEdVaXo0TEE1Z0xcbkFrSlVVeFNmNW5VNytCSVRRd3ZrNGx1b2VnZ0ZGS2dyaEdsK005MENnWUVBcjJtdTdia3E5RjNxL3pEek5CbEpcbkpuTHdRUmowdS9sVk1uRnZXSHF4MUJzdjBXTjdMSzZySy8ramwxNUZPR2lUeU5ONFkrVWVsdExpSnhMMDQyWVJcbmcyTk00aXF3dWtMTWF1NXg5akdiczFOTldtaWdDUjJocWpDdHY5bVRQWFpCVjNxZVBmbU4xcGo4K1FFeTdrTndcbngvOHZuZklwVFRWY1p4UEZLQVE2eVVvPVxuLS0tLS1FTkQgUFJJVkFURSBLRVktLS0tLVxuIiwKICAiY2xpZW50X2VtYWlsIjogImdlbmVyaWMtcHVsbC1mcm9tLWdjckBkb21pbm8tZW5nLXNlcnZpY2UtYXJ0aWZhY3RzLmlhbS5nc2VydmljZWFjY291bnQuY29tIiwKICAiY2xpZW50X2lkIjogIjExMjc0MDYxNDU3NTM5NzY0MzYwOSIsCiAgImF1dGhfdXJpIjogImh0dHBzOi8vYWNjb3VudHMuZ29vZ2xlLmNvbS9vL29hdXRoMi9hdXRoIiwKICAidG9rZW5fdXJpIjogImh0dHBzOi8vb2F1dGgyLmdvb2dsZWFwaXMuY29tL3Rva2VuIiwKICAiYXV0aF9wcm92aWRlcl94NTA5X2NlcnRfdXJsIjogImh0dHBzOi8vd3d3Lmdvb2dsZWFwaXMuY29tL29hdXRoMi92MS9jZXJ0cyIsCiAgImNsaWVudF94NTA5X2NlcnRfdXJsIjogImh0dHBzOi8vd3d3Lmdvb2dsZWFwaXMuY29tL3JvYm90L3YxL21ldGFkYXRhL3g1MDkvZ2VuZXJpYy1wdWxsLWZyb20tZ2NyJTQwZG9taW5vLWVuZy1zZXJ2aWNlLWFydGlmYWN0cy5pYW0uZ3NlcnZpY2VhY2NvdW50LmNvbSIKfQo=")
#   create_namespace    = true

#   set {
#     name  = "controller.k8sTagClusterId"
#     value = var.deploy_id
#   }
#   # depends_on = [docker_container.mallory]
# }


# resource "helm_release" "ebs_csi_driver" {
#   repository          = "oci://gcr.io/domino-eng-service-artifacts"
#   chart               = "aws-ebs-csi-driver"
#   name                = "aws-ebs-csi-driver"
#   version             = "2.6.5-0.0.4"
#   repository_username = "_json_key"
#   repository_password = base64decode("ewogICJ0eXBlIjogInNlcnZpY2VfYWNjb3VudCIsCiAgInByb2plY3RfaWQiOiAiZG9taW5vLWVuZy1zZXJ2aWNlLWFydGlmYWN0cyIsCiAgInByaXZhdGVfa2V5X2lkIjogIjM3ZGFiOTA4ZGRmZjUzZDAwY2I3ZTIxZjc1ZDNhN2FlNGEzNjIxMWMiLAogICJwcml2YXRlX2tleSI6ICItLS0tLUJFR0lOIFBSSVZBVEUgS0VZLS0tLS1cbk1JSUV2UUlCQURBTkJna3Foa2lHOXcwQkFRRUZBQVNDQktjd2dnU2pBZ0VBQW9JQkFRQ293V0ZPV1hZd1hlU0lcbjd3ZkNUZk5RMktNTE92ZEJrNElscmNRVGpqZGx4Q1dFSTE2RWtkUksvZDE1bk4yOXR1QzAwQ2dLSnBrRHdXNGVcblY4VXFmMnJqcXdVaTBKdUlZWGlEb2pOMnE2eDlUNkFhcU5yNldWdVJBSFJBZmIrSmVoMHlUSmV3MHNGQ0F1Vk9cbks5Ni9GMWNEUHQ2QkNpckFaQjBVbE5jeTczeUE5d3VlT3FvK0xRQzVyc1YxZlNtdkM3bzQ2V20rWUtPZkxPS2JcbndLT2FOdXNKSHdKQUhCcCs5a2x4K3gzQ1VBZ0hUclN1bDJ0TG0zaTNEZVozbjdPcVE4dGRId2RGU1V0M0EzdTdcbk1LUDFsa1lqZFZRckdWQkgzWStxS0ZzU1pCYzd1ZTZEK2lzWmU3U0dMUnJiQnN2Mzlwa3I5bi94WEY2cktsd3VcbkNLVE9NZlM1QWdNQkFBRUNnZ0VBSnBvWHAxdTArcUxicmt3Wk53UHNPc3ZYWGZBRzA3QUpseE5jMVFsVTJEbEtcblNLUHJrTUVuOGVDSTJ6TDhFUlBHYW0zc0hzaE4rNnN4UkkwWXU1d3FaL284b2taY01aSDBSbzRobmcxdWx6cVJcbjJjOVN5ZTRMVVV1c2kvMEh4WXVTcHFrWkVOaGczemY0Mm8wVDlwdkE2bXZrNjFrWFJ1dVBzRi9NcXlqWGpzczBcbjk2M01aYmVObWYwSHBubmh6eWpWeDkxa0ZYR1Y4b3pFVi9SZGhLSGxrY2kvTTZOREpSSzdmdllDblRBa2RFZVhcbndNUEFEMjVwYUs4amF2V1hoTXh4U1k3NjhzaEtPR2V5eHVRYS9YWW1sd0hKdXdmOUZDUjdSMURiblpRc2hJRXpcbjgrZWdJMVlidEliZm4xM0tkYTVkbWVXcmdRNU9YL293eFkzcXZjamh4UUtCZ1FEVUluVkk0RjZUZXpmb3hMQUhcbjRuQ3FTcjhlemlwMHNKSk5aQ0ZmL0hXNjRibS9NRElJdUJPQ1cyejNZWWxuZC9HRUdJdy9UY2FpRXBDUnZsamlcbnhWNExNOGhDVlRXejlMMGhES1Jib0pPamc5SitKeEJueW5JWGNBUzQyd2ZZTVd3NU9JN2RLMWVGQkVZdzNkOWFcbnprVDZrdkFVTks0c0xFUWJLQ20xOFRBYURRS0JnUURMcHBwckkyV0hNZ3dmU3l4bi9OeWUxQkxPQVJmZzRZbGJcbjBJNk5CQkVDWk51RGVpZzltU3gvRGpyMXVCUjlhdXJjZUJVbjk0V2w5OTZpMStkRXMzN1ZKUFZmWkRPNjRUbjlcbjdiaUFEMzBxNzJDaVo1MElnYURQVVMxdzZzZU84NWl0K0o0VjFxUERyTHpGUjFDbzBnSWhpVzhLNFBuT0lhc2dcblRlQWZsWEQyWFFLQmdCZEE3N3BkWGdDc3NTUkM2MGp4K1lleFNlSUdsNERUR2phQmsyY0NOYVdXdU5YTVlxK3hcbi9mRjhOQ1dwKzNYc0gvMXE4M1M5QWRraVQ5YXFGdlJFemxwTUF0ZkNuM0JxazVEYjRlaHBZY1c2M1lnV29DWEFcbmUyRTJWazR0TkY3dWkvNTV4SzlaNE80ajJjM2hoR3BmMGcvbHE0dUxlc3c4emZwc0hLWmxHZkRCQW9HQWVKN2dcblBXOEV0cFBWREQvNU9FcFQzaHNjWERuWGk5SHFDcUMzbmh4M2VxU0VSQlo1ZVNxZGFVL2phaUN5dWlvMm00amdcbmR3Q3JmMGNWN2Z2Vk5pTGVqNTVKVzB1OVBBWWsxQnNXT1h0ekZwZ2I4M1ZOVkhsNjV2QmM2dEdVaXo0TEE1Z0xcbkFrSlVVeFNmNW5VNytCSVRRd3ZrNGx1b2VnZ0ZGS2dyaEdsK005MENnWUVBcjJtdTdia3E5RjNxL3pEek5CbEpcbkpuTHdRUmowdS9sVk1uRnZXSHF4MUJzdjBXTjdMSzZySy8ramwxNUZPR2lUeU5ONFkrVWVsdExpSnhMMDQyWVJcbmcyTk00aXF3dWtMTWF1NXg5akdiczFOTldtaWdDUjJocWpDdHY5bVRQWFpCVjNxZVBmbU4xcGo4K1FFeTdrTndcbngvOHZuZklwVFRWY1p4UEZLQVE2eVVvPVxuLS0tLS1FTkQgUFJJVkFURSBLRVktLS0tLVxuIiwKICAiY2xpZW50X2VtYWlsIjogImdlbmVyaWMtcHVsbC1mcm9tLWdjckBkb21pbm8tZW5nLXNlcnZpY2UtYXJ0aWZhY3RzLmlhbS5nc2VydmljZWFjY291bnQuY29tIiwKICAiY2xpZW50X2lkIjogIjExMjc0MDYxNDU3NTM5NzY0MzYwOSIsCiAgImF1dGhfdXJpIjogImh0dHBzOi8vYWNjb3VudHMuZ29vZ2xlLmNvbS9vL29hdXRoMi9hdXRoIiwKICAidG9rZW5fdXJpIjogImh0dHBzOi8vb2F1dGgyLmdvb2dsZWFwaXMuY29tL3Rva2VuIiwKICAiYXV0aF9wcm92aWRlcl94NTA5X2NlcnRfdXJsIjogImh0dHBzOi8vd3d3Lmdvb2dsZWFwaXMuY29tL29hdXRoMi92MS9jZXJ0cyIsCiAgImNsaWVudF94NTA5X2NlcnRfdXJsIjogImh0dHBzOi8vd3d3Lmdvb2dsZWFwaXMuY29tL3JvYm90L3YxL21ldGFkYXRhL3g1MDkvZ2VuZXJpYy1wdWxsLWZyb20tZ2NyJTQwZG9taW5vLWVuZy1zZXJ2aWNlLWFydGlmYWN0cy5pYW0uZ3NlcnZpY2VhY2NvdW50LmNvbSIKfQo=")
#   create_namespace    = true

#   set {
#     name  = "controller.k8sTagClusterId"
#     value = var.deploy_id
#   }
#   # depends_on = [docker_container.mallory]
# }


# resource "helm_release" "docker_registry" {
#   repository          = "oci://gcr.io/domino-eng-service-artifacts"
#   chart               = "docker-registry"
#   name                = "docker-registry"
#   version             = "1.6.1-0.19.2"
#   repository_username = "_json_key"
#   repository_password = base64decode("ewogICJ0eXBlIjogInNlcnZpY2VfYWNjb3VudCIsCiAgInByb2plY3RfaWQiOiAiZG9taW5vLWVuZy1zZXJ2aWNlLWFydGlmYWN0cyIsCiAgInByaXZhdGVfa2V5X2lkIjogIjM3ZGFiOTA4ZGRmZjUzZDAwY2I3ZTIxZjc1ZDNhN2FlNGEzNjIxMWMiLAogICJwcml2YXRlX2tleSI6ICItLS0tLUJFR0lOIFBSSVZBVEUgS0VZLS0tLS1cbk1JSUV2UUlCQURBTkJna3Foa2lHOXcwQkFRRUZBQVNDQktjd2dnU2pBZ0VBQW9JQkFRQ293V0ZPV1hZd1hlU0lcbjd3ZkNUZk5RMktNTE92ZEJrNElscmNRVGpqZGx4Q1dFSTE2RWtkUksvZDE1bk4yOXR1QzAwQ2dLSnBrRHdXNGVcblY4VXFmMnJqcXdVaTBKdUlZWGlEb2pOMnE2eDlUNkFhcU5yNldWdVJBSFJBZmIrSmVoMHlUSmV3MHNGQ0F1Vk9cbks5Ni9GMWNEUHQ2QkNpckFaQjBVbE5jeTczeUE5d3VlT3FvK0xRQzVyc1YxZlNtdkM3bzQ2V20rWUtPZkxPS2JcbndLT2FOdXNKSHdKQUhCcCs5a2x4K3gzQ1VBZ0hUclN1bDJ0TG0zaTNEZVozbjdPcVE4dGRId2RGU1V0M0EzdTdcbk1LUDFsa1lqZFZRckdWQkgzWStxS0ZzU1pCYzd1ZTZEK2lzWmU3U0dMUnJiQnN2Mzlwa3I5bi94WEY2cktsd3VcbkNLVE9NZlM1QWdNQkFBRUNnZ0VBSnBvWHAxdTArcUxicmt3Wk53UHNPc3ZYWGZBRzA3QUpseE5jMVFsVTJEbEtcblNLUHJrTUVuOGVDSTJ6TDhFUlBHYW0zc0hzaE4rNnN4UkkwWXU1d3FaL284b2taY01aSDBSbzRobmcxdWx6cVJcbjJjOVN5ZTRMVVV1c2kvMEh4WXVTcHFrWkVOaGczemY0Mm8wVDlwdkE2bXZrNjFrWFJ1dVBzRi9NcXlqWGpzczBcbjk2M01aYmVObWYwSHBubmh6eWpWeDkxa0ZYR1Y4b3pFVi9SZGhLSGxrY2kvTTZOREpSSzdmdllDblRBa2RFZVhcbndNUEFEMjVwYUs4amF2V1hoTXh4U1k3NjhzaEtPR2V5eHVRYS9YWW1sd0hKdXdmOUZDUjdSMURiblpRc2hJRXpcbjgrZWdJMVlidEliZm4xM0tkYTVkbWVXcmdRNU9YL293eFkzcXZjamh4UUtCZ1FEVUluVkk0RjZUZXpmb3hMQUhcbjRuQ3FTcjhlemlwMHNKSk5aQ0ZmL0hXNjRibS9NRElJdUJPQ1cyejNZWWxuZC9HRUdJdy9UY2FpRXBDUnZsamlcbnhWNExNOGhDVlRXejlMMGhES1Jib0pPamc5SitKeEJueW5JWGNBUzQyd2ZZTVd3NU9JN2RLMWVGQkVZdzNkOWFcbnprVDZrdkFVTks0c0xFUWJLQ20xOFRBYURRS0JnUURMcHBwckkyV0hNZ3dmU3l4bi9OeWUxQkxPQVJmZzRZbGJcbjBJNk5CQkVDWk51RGVpZzltU3gvRGpyMXVCUjlhdXJjZUJVbjk0V2w5OTZpMStkRXMzN1ZKUFZmWkRPNjRUbjlcbjdiaUFEMzBxNzJDaVo1MElnYURQVVMxdzZzZU84NWl0K0o0VjFxUERyTHpGUjFDbzBnSWhpVzhLNFBuT0lhc2dcblRlQWZsWEQyWFFLQmdCZEE3N3BkWGdDc3NTUkM2MGp4K1lleFNlSUdsNERUR2phQmsyY0NOYVdXdU5YTVlxK3hcbi9mRjhOQ1dwKzNYc0gvMXE4M1M5QWRraVQ5YXFGdlJFemxwTUF0ZkNuM0JxazVEYjRlaHBZY1c2M1lnV29DWEFcbmUyRTJWazR0TkY3dWkvNTV4SzlaNE80ajJjM2hoR3BmMGcvbHE0dUxlc3c4emZwc0hLWmxHZkRCQW9HQWVKN2dcblBXOEV0cFBWREQvNU9FcFQzaHNjWERuWGk5SHFDcUMzbmh4M2VxU0VSQlo1ZVNxZGFVL2phaUN5dWlvMm00amdcbmR3Q3JmMGNWN2Z2Vk5pTGVqNTVKVzB1OVBBWWsxQnNXT1h0ekZwZ2I4M1ZOVkhsNjV2QmM2dEdVaXo0TEE1Z0xcbkFrSlVVeFNmNW5VNytCSVRRd3ZrNGx1b2VnZ0ZGS2dyaEdsK005MENnWUVBcjJtdTdia3E5RjNxL3pEek5CbEpcbkpuTHdRUmowdS9sVk1uRnZXSHF4MUJzdjBXTjdMSzZySy8ramwxNUZPR2lUeU5ONFkrVWVsdExpSnhMMDQyWVJcbmcyTk00aXF3dWtMTWF1NXg5akdiczFOTldtaWdDUjJocWpDdHY5bVRQWFpCVjNxZVBmbU4xcGo4K1FFeTdrTndcbngvOHZuZklwVFRWY1p4UEZLQVE2eVVvPVxuLS0tLS1FTkQgUFJJVkFURSBLRVktLS0tLVxuIiwKICAiY2xpZW50X2VtYWlsIjogImdlbmVyaWMtcHVsbC1mcm9tLWdjckBkb21pbm8tZW5nLXNlcnZpY2UtYXJ0aWZhY3RzLmlhbS5nc2VydmljZWFjY291bnQuY29tIiwKICAiY2xpZW50X2lkIjogIjExMjc0MDYxNDU3NTM5NzY0MzYwOSIsCiAgImF1dGhfdXJpIjogImh0dHBzOi8vYWNjb3VudHMuZ29vZ2xlLmNvbS9vL29hdXRoMi9hdXRoIiwKICAidG9rZW5fdXJpIjogImh0dHBzOi8vb2F1dGgyLmdvb2dsZWFwaXMuY29tL3Rva2VuIiwKICAiYXV0aF9wcm92aWRlcl94NTA5X2NlcnRfdXJsIjogImh0dHBzOi8vd3d3Lmdvb2dsZWFwaXMuY29tL29hdXRoMi92MS9jZXJ0cyIsCiAgImNsaWVudF94NTA5X2NlcnRfdXJsIjogImh0dHBzOi8vd3d3Lmdvb2dsZWFwaXMuY29tL3JvYm90L3YxL21ldGFkYXRhL3g1MDkvZ2VuZXJpYy1wdWxsLWZyb20tZ2NyJTQwZG9taW5vLWVuZy1zZXJ2aWNlLWFydGlmYWN0cy5pYW0uZ3NlcnZpY2VhY2NvdW50LmNvbSIKfQo=")
#   create_namespace    = true

#   set {
#     name  = "controller.k8sTagClusterId"
#     value = var.deploy_id
#   }
#   # depends_on = [docker_container.mallory]
# }


# resource "kubernetes_storage_class" "dominoshared" {
#   metadata {
#     name = "dominoshared"
#   }
#   storage_provisioner    = "efs.csi.aws.com"
#   reclaim_policy         = "Delete"
#   allow_volume_expansion = true
#   volume_binding_mode    = "Immediate"
#   depends_on             = [helm_release.efs_csi_driver]
# }

# resource "kubernetes_storage_class" "dominodisk" {
#   metadata {
#     name = "dominodisk"
#   }
#   storage_provisioner    = "ebs.csi.aws.com"
#   reclaim_policy         = "Delete"
#   allow_volume_expansion = true
#   volume_binding_mode    = "WaitForFirstConsumer"
#   parameters = {
#     encrypted = "true",
#     type      = "gp3"
#   }
#   depends_on = [helm_release.ebs_csi_driver]
# }

# resource "helm_release" "docker_registry" {
#   name             = "calico-tigera-operator"
#   repository       = "https://docs.projectcalico.org/charts"
#   chart            = "tigera-operator"
#   version          = var.add_ons.calico.version
#   namespace        = "tigera-operator"
#   create_namespace = true
#   depends_on       = [docker_container.mallory]
# }


# resource "helm_release" "storage_clases" {
#   name       = "storage-clases"
#   repository = "https://charts.itscontained.io"
#   chart      = "raw"
#   version    = "0.2.5"
# values = [
#     # <<-EOF
#     # resources:
#     #   - apiVersion: external-secrets.io/v1alpha1
#     #     kind: ClusterSecretStore
#     #     metadata:
#     #       name: cluster-store
#     #     spec:
#     #       provider:
#     #         azurekv:
#     #           tenantId: "${from some tf output}"
#     #           vaultUrl: "${from some tf output}"
#     #           authSecretRef:
#     #             clientId:
#     #               name: external-secrets-vault-credentials
#     #               namespace: external-secrets
#     #               key: ClientID
#     #             clientSecret:
#     #               name: external-secrets-vault-credentials
#     #               namespace: external-secrets
#     #               key: ClientSecret
#     # EOF
#   ]
# }

# resource "kubernetes_storage_class" "dominoshared" {
#   metadata {
#     name = "dominoshared"
#   }
#   storage_provisioner    = "efs.csi.aws.com"
#   reclaim_policy         = "Delete"
#   allow_volume_expansion = true
#   volume_binding_mode    = "Immediate"
# }

# resource "kubernetes_storage_class" "dominodisk" {
#   metadata {
#     name = "dominodisk"
#   }
#   storage_provisioner    = "ebs.csi.aws.com"
#   reclaim_policy         = "Delete"
#   allow_volume_expansion = true
#   volume_binding_mode    = "WaitForFirstConsumer"
#   parameters = {
#     encrypted = "true",
#     type      = "gp3"
#   }
# }
