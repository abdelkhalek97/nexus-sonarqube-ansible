variable "instType" {
  description = "this variable will tell instance type"
  type        = string
  default     = ""


}


variable "name" {
  type    = string
  default = ""
}


variable "subnet_ids" {
  # type = list(string)
  default = ""
}

variable "secg_id" {
  default = ""
}


variable "key_name" {
  default = ""
}