
// export the cloud sql instance connection name to a cloud storage bucket
resource "google_storage_bucket_object" "db_connection" {
  name   = "connection-name"
  content = "${google_sql_database_instance.primary.connection_name}"
  bucket = "sca-project"
}


// export the database user name to a cloud storage bucket
resource "google_storage_bucket_object" "db_user" {
  name   = "db_user"
  content = "${google_sql_user.admin_user.name}"
  bucket = "sca-project"
}


// export the database user password to a cloud storage bucket
resource "google_storage_bucket_object" "db_pass" {
  name   = "db_pass"
  content = "${google_sql_user.admin_user.password}"
  bucket = "sca-project"
}


// export the database name to a cloud storage bucket
resource "google_storage_bucket_object" "db" {
  name   = "db"
  content = "${google_sql_database.database.name}"
  bucket = "sca-project"
}