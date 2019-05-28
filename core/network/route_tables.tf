# Create and configure public subnet route table
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"
  tags {
      Name = "natureofclouds-${var.env}-public-rtb"
      Env = "${var.env}"
  }
}
resource "aws_route_table_association" "public1_rtb_assoc" {
  subnet_id      = "${aws_subnet.public1.id}"
  route_table_id = "${aws_route_table.public.id}"
}
resource "aws_route_table_association" "public2_rtb_assoc" {
  subnet_id      = "${aws_subnet.public2.id}"
  route_table_id = "${aws_route_table.public.id}"
}

# Create and configure private subnet route table
resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.main.id}"
  tags {
    Name = "natureofclouds-${var.env}-private-rtb"
    Env = "${var.env}"
  }
}
resource "aws_route_table_association" "private1_rtb_assoc" {
  subnet_id      = "${aws_subnet.private1.id}"
  route_table_id = "${aws_route_table.private.id}"
}
resource "aws_route_table_association" "private2_rtb_assoc" {
  subnet_id      = "${aws_subnet.private2.id}"
  route_table_id = "${aws_route_table.private.id}"
}
