# Create and configure Internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.main.id}"
  tags {
    Name = "natureofclouds-${var.env}-igw"
    Env = "${var.env}"
  }
}
resource "aws_route" "default_public" {
  route_table_id = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.igw.id}"
  depends_on = ["aws_internet_gateway.igw", "aws_route_table.public"]
}

# Create and configure NAT gateway
resource "aws_eip" "nat_eip" {
  vpc = true
  tags {
    Name = "natureofclouds-${var.env}-nat-eip"
    Env = "${var.env}"
  }
  depends_on = ["aws_internet_gateway.igw"]
}
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = "${aws_eip.nat_eip.id}"
  subnet_id = "${aws_subnet.public1.id}"
  tags {
    Name = "natureofclouds-${var.env}-nat-gw"
    Env = "${var.env}"
  }
  depends_on = ["aws_internet_gateway.igw", "aws_eip.nat_eip"]
}
resource "aws_route" "default_private" {
  route_table_id = "${aws_route_table.private.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.nat_gw.id}"
  depends_on = ["aws_nat_gateway.nat_gw", "aws_route_table.private"]
}
