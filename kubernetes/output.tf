output "db_ip" {
    value = data.google_sql_database_instance.app_db.private_ip_address
}