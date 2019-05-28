data "aws_availability_zones" "az" {}
data "aws_availability_zone" "az1" { name = "${data.aws_availability_zones.az.names[0]}" }
data "aws_availability_zone" "az2" { name = "${data.aws_availability_zones.az.names[1]}" }

resource "aws_vpc" "main" {
  cidr_block       = "${local.cidr_block}"
  enable_dns_hostnames = true

  tags {
    Name = "natureofclouds-${var.env}-vpc"
    Env = "${var.env}"
  }
}
resource "aws_subnet" "private1" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${cidrsubnet(local.cidr_block, 4, 12)}"
  availability_zone = "${data.aws_availability_zone.az1.name}"

  tags {
    Name = "natureofclouds-${var.env}-private-${data.aws_availability_zone.az1.name_suffix}"
    Env = "${var.env}"
  }
}
resource "aws_subnet" "private2" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${cidrsubnet(local.cidr_block, 4, 13)}"
  availability_zone = "${data.aws_availability_zone.az2.name}"

  tags {
    Name = "natureofclouds-${var.env}-private-${data.aws_availability_zone.az2.name_suffix}"
    Env = "${var.env}"
  }
}
resource "aws_subnet" "public1" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${cidrsubnet(local.cidr_block, 4, 14)}"
  availability_zone = "${data.aws_availability_zone.az1.name}"
  map_public_ip_on_launch = true

  tags {
    Name = "natureofclouds-${var.env}-public-${data.aws_availability_zone.az1.name_suffix}"
    Env = "${var.env}"
  }
}
resource "aws_subnet" "public2" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${cidrsubnet(local.cidr_block, 4, 15)}"
  availability_zone = "${data.aws_availability_zone.az2.name}"
  map_public_ip_on_launch = true

  tags {
    Name = "natureofclouds-${var.env}-public-${data.aws_availability_zone.az2.name_suffix}"
    Env = "${var.env}"
  }
}
