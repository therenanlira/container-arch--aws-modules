# Route 53 Zone

resource "aws_route53_zone" "private" {
  name = "${var.project_name}.internal.com"

  vpc {
    vpc_id = aws_vpc.main.id
  }
}
