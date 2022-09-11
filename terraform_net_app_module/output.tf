output "nettapp_sp_password" {
  value = azuread_service_principal_password.test.value
}

output "netapp_sp_object_id" {
  value = azuread_service_principal.test.object_id
}

output "netapp_sp_app_id" {
  value = azuread_application.test.application_id
}

output "netapp_settings" {
 value = data.template_file.netapp_backend_config.rendered
}