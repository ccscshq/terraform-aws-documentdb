resource "random_password" "this" {
  length = 16
  # https://docs.aws.amazon.com/documentdb/latest/developerguide/db-cluster-parameters.html
  override_special = "!#$%&*()-_=+[]{}<>:?"
}
