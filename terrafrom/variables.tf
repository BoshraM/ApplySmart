variable "ingressrules" {
  type    = list(number)
  default = [80, 443, 22,5000]
}
variable "egressrules" {
  type    = list(number)
  default = [80, 443, 25, 3306, 53, 8080]
}
