# Create and configure VPC peering
data "aws_vpc" "vpc_peer" { tags { Name = "natureofclouds-core-vpc" }}
data "aws_route_table" "vpc_peer_public" { tags { Name = "natureofclouds-core-public-rtb" }}
data "aws_route_table" "vpc_peer_private" { tags { Name = "natureofclouds-core-private-rtb" }}

resource "aws_vpc_peering_connection" "peer" {
  peer_vpc_id   = "${data.aws_vpc.vpc_peer.id}"
  vpc_id     = "${aws_vpc.main.id}"
  auto_accept   = true
  accepter {
    allow_remote_vpc_dns_resolution = true
  }
  requester {
    allow_remote_vpc_dns_resolution = true
  }
  tags {
    Name = "natureofclouds-${var.env}-peering"
  }
}
resource "aws_route" "to_vpc_peer_public" {
  route_table_id = "${aws_route_table.public.id}"
  destination_cidr_block = "${data.aws_vpc.vpc_peer.cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peer.id}"
  depends_on = ["aws_vpc_peering_connection.peer", "aws_route_table.public"]
}
resource "aws_route" "to_vpc_peer_private" {
  route_table_id = "${aws_route_table.private.id}"
  destination_cidr_block = "${data.aws_vpc.vpc_peer.cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peer.id}"
  depends_on = ["aws_vpc_peering_connection.peer", "aws_route_table.private"]
}
resource "aws_route" "from_vpc_peer_public" {
  route_table_id = "${data.aws_route_table.vpc_peer_public.id}"
  destination_cidr_block = "${local.cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peer.id}"
  depends_on = ["aws_vpc_peering_connection.peer"]
}
resource "aws_route" "from_vpc_peer_private" {
  route_table_id = "${data.aws_route_table.vpc_peer_private.id}"
  destination_cidr_block = "${local.cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peer.id}"
  depends_on = ["aws_vpc_peering_connection.peer"]
}
