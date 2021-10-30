variable "database_version" {
    type = string
    default = "POSTGRES_13"
    description  = "type of database and version"
  
}

variable "region" {
    type = string
    description  = "the database region"    
}
variable "availability" {
    type = string
    default = "ZONAL"
}

variable "tier" {
    type = string
    default = "db-f1-micro"
    description  = "machine type for the instance"
}

variable "database_name" {
    type = string
    description  = "name of the database to create in the instance"
}

variable "db_user" {
    type = string
    description  = "user for the instance"
}

variable "db_pass" {
    type = string
    description  = "database user's password"
}

variable "project_id" {
  type = string
}

variable "prefix_length" {
    type = number
    default = 16
    description = "netmask for the vpc peering ip range"
}