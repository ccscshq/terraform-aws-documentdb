resource "aws_security_group" "this" {
  name        = "${var.prefix}-docdb-cluster"
  description = "Document DB Cluster Security Group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.prefix}-docdb-cluster"
  }
}

resource "aws_security_group_rule" "ingress" {
  security_group_id = aws_security_group.this.id
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "egress" {
  security_group_id = aws_security_group.this.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}
