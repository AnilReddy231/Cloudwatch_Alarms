output "rdsUserPassword"{
    value = "${random_string.rdsPassword.result}"
}