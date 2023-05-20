resource "aws_ssm_parameter" "this" {
  name  = "/${var.prefix}/docdb/master_password"
  type  = "SecureString"
  value = random_password.this.result
}
