locals {
  moon_estate_subnets = {
    private_a = aws_subnet.moon_estate_private_a.id
    private_b = aws_subnet.moon_estate_private_b.id
    private_c = aws_subnet.moon_estate_private_c.id
    public_a = aws_subnet.moon_estate_public_a.id
    public_b = aws_subnet.moon_estate_public_b.id
    public_c = aws_subnet.moon_estate_public_c.id
  }
}
