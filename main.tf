
#######################################
# VPC PRINCIPAL - APLICACIONES
#######################################
resource "aws_vpc" "app" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name    = "vpc-${var.project}-${var.operation}-app-ca"
    Project = var.project
    Oper    = var.operation
  }
}

resource "aws_subnet" "app_public_a" {
  vpc_id                  = aws_vpc.app.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-${var.project}-${var.operation}-pub-a"
  }
}

resource "aws_subnet" "app_private_a" {
  vpc_id            = aws_vpc.app.id
  cidr_block        = "10.0.101.0/24"
  availability_zone = "${var.region}a"
  tags = {
    Name = "subnet-${var.project}-${var.operation}-priv-a"
  }
}

#######################################
# VPC SECUNDARIA - DATA WAREHOUSE
#######################################
resource "aws_vpc" "dw" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name    = "vpc-${var.project}-${var.operation}-dw-ca"
    Project = var.project
    Oper    = var.operation
  }
}

resource "aws_subnet" "dw_private_a" {
  vpc_id            = aws_vpc.dw.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = "${var.region}a"
  tags = {
    Name = "subnet-${var.project}-${var.operation}-dw-priv-a"
  }
}

#######################################
# DW - SUBNET PRIVADA AZ b
#######################################
resource "aws_subnet" "dw_private_b" {
  vpc_id            = aws_vpc.dw.id
  cidr_block        = "10.1.2.0/24"
  availability_zone = "${var.region}b"
  tags = {
    Name = "subnet-${var.project}-${var.operation}-dw-priv-b"
  }
}

#######################################
# PEERING ENTRE VPCs
#######################################
resource "aws_vpc_peering_connection" "app_dw" {
  vpc_id      = aws_vpc.app.id
  peer_vpc_id = aws_vpc.dw.id
  auto_accept = true
  tags = {
    Name = "peer-${var.project}-${var.operation}-app-dw"
  }
}
#######################################
# INTERNET GATEWAY (IGW) - VPC APP
#######################################
resource "aws_internet_gateway" "app_igw" {
  vpc_id = aws_vpc.app.id
  tags = {
    Name    = "igw-${var.project}-${var.operation}-001-ca"
    Project = var.project
    Oper    = var.operation
  }
}

#######################################
# ELASTIC IP para NAT
#######################################
resource "aws_eip" "app_nat_eip" {
  domain = "vpc"
  tags = {
    Name    = "eip-${var.project}-${var.operation}-nat-001-ca"
    Project = var.project
    Oper    = var.operation
  }
}

#######################################
# NAT GATEWAY en SUBNET PUBLICA
#######################################
resource "aws_nat_gateway" "app_nat" {
  allocation_id = aws_eip.app_nat_eip.id
  subnet_id     = aws_subnet.app_public_a.id
  tags = {
    Name    = "nat-${var.project}-${var.operation}-001-ca"
    Project = var.project
    Oper    = var.operation
  }
  depends_on = [aws_internet_gateway.app_igw]
}

#######################################
# ROUTE TABLE PUBLICA (0.0.0.0/0 -> IGW)
#######################################
resource "aws_route_table" "app_public_rt" {
  vpc_id = aws_vpc.app.id
  tags = {
    Name    = "rt-${var.project}-${var.operation}-public-a-001-ca"
    Project = var.project
    Oper    = var.operation
  }
}

resource "aws_route" "app_public_default" {
  route_table_id         = aws_route_table.app_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.app_igw.id
}

resource "aws_route_table_association" "app_public_assoc_a" {
  subnet_id      = aws_subnet.app_public_a.id
  route_table_id = aws_route_table.app_public_rt.id
}

#######################################
# ROUTE TABLE PRIVADA (0.0.0.0/0 -> NAT)
#######################################
resource "aws_route_table" "app_private_rt_a" {
  vpc_id = aws_vpc.app.id
  tags = {
    Name    = "rt-${var.project}-${var.operation}-private-a-001-ca"
    Project = var.project
    Oper    = var.operation
  }
}

resource "aws_route" "app_private_default_a" {
  route_table_id         = aws_route_table.app_private_rt_a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.app_nat.id
}

resource "aws_route_table_association" "app_private_assoc_a" {
  subnet_id      = aws_subnet.app_private_a.id
  route_table_id = aws_route_table.app_private_rt_a.id
}

#######################################
# SUBNETS AZ b (APP)
#######################################
resource "aws_subnet" "app_public_b" {
  vpc_id                  = aws_vpc.app.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = true
  tags                    = { Name = "subnet-${var.project}-${var.operation}-pub-b" }
}

resource "aws_subnet" "app_private_b" {
  vpc_id            = aws_vpc.app.id
  cidr_block        = "10.0.102.0/24"
  availability_zone = "${var.region}b"
  tags              = { Name = "subnet-${var.project}-${var.operation}-priv-b" }
}

#######################################
# ROUTE TABLE PUBLICA (AZ b) -> IGW
#######################################
resource "aws_route_table" "app_public_rt_b" {
  vpc_id = aws_vpc.app.id
  tags = {
    Name = "rt-${var.project}-${var.operation}-public-b-001-ca"
  }
}

resource "aws_route" "app_public_default_b" {
  route_table_id         = aws_route_table.app_public_rt_b.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.app_igw.id
}

resource "aws_route_table_association" "app_public_assoc_b" {
  subnet_id      = aws_subnet.app_public_b.id
  route_table_id = aws_route_table.app_public_rt_b.id
}

#######################################
# ROUTE TABLE PRIVADA (AZ b)
#######################################
resource "aws_route_table" "app_private_rt_b" {
  vpc_id = aws_vpc.app.id
  tags = {
    Name = "rt-${var.project}-${var.operation}-private-b-001-ca"
  }
}

resource "aws_route" "app_private_default_b" {
  route_table_id         = aws_route_table.app_private_rt_b.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.app_nat.id
}

resource "aws_route_table_association" "app_private_assoc_b" {
  subnet_id      = aws_subnet.app_private_b.id
  route_table_id = aws_route_table.app_private_rt_b.id
}

#######################################
# OUTPUTS
#######################################

# APP SG: permite 8080 solo desde el ALB
resource "aws_security_group" "app_sg" {
  name        = "app-${var.project}-${var.operation}-sg-001"
  description = "App ingress 8080 from ALB"
  vpc_id      = aws_vpc.app.id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
    description     = "ALB to App 8080"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "sg-${var.project}-${var.operation}-app-001-ca" }
}
#######################################
# TARGET GROUP para apps (puerto 8080)
#######################################
resource "aws_lb_target_group" "apps_tg" {
  name        = "tg-${var.project}-apps-001"
  port        = 8080
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.app.id

  health_check {
    path                = "/"
    port                = "8080"
    protocol            = "HTTP"
    matcher             = "200-399"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 15
    timeout             = 5
  }

  tags = { Name = "tg-${var.project}-apps-001" }
}

#######################################
# APPLICATION LOAD BALANCER (público)
#######################################

locals {
  proj8 = substr(var.project, 0, 8)
  op8   = substr(var.operation, 0, 8)
}


#######################################
# SG ALB (80/443 desde Internet)
#######################################
resource "aws_security_group" "alb_sg" {
  name        = "alb-${var.project}-${var.operation}-sg-001"
  description = "ALB ingress 80/443"
  vpc_id      = aws_vpc.app.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "sg-${var.project}-${var.operation}-alb-001-ca"
    Project = var.project
    Oper    = var.operation
  }
}


resource "aws_lb" "app_alb" {
  name               = "alb-${local.proj8}-${local.op8}-001"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.app_public_a.id, aws_subnet.app_public_b.id]

  tags = { Name = "alb-${var.project}-${var.operation}-001" }
  access_logs {
    bucket = aws_s3_bucket.alb_logs.bucket
    prefix = "alb"
    enabled = true
  }
}

# Listener 80: redirige a 443 si hay cert; si no hay cert, sirve 80 directo
resource "aws_lb_listener" "http_80" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  dynamic "default_action" {
    for_each = var.acm_cert_arn_regional != "" ? [1] : []
    content {
      type = "redirect"
      redirect {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  }

  # Fallback: solo si NO hay cert, envia tráfico directo al TG
  dynamic "default_action" {
    for_each = var.acm_cert_arn_regional == "" ? [1] : []
    content {
      type             = "forward"
      target_group_arn = aws_lb_target_group.apps_tg.arn
    }
  }
}

# Listener 443 (solo si hay cert)
resource "aws_lb_listener" "https_443" {
  count             = var.acm_cert_arn_regional != "" ? 1 : 0
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.acm_cert_arn_regional

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.apps_tg.arn
  }
}

#######################################
# EC2 DUMMY (webapi / gameapi)
#######################################
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-*-kernel-*-x86_64"]
  }
}

locals {
  user_data = <<-EOT
  #!/bin/bash
  set -xe
  dnf update -y
  dnf install -y nginx
  cat >/usr/share/nginx/html/index.html <<'HTML'
  <html><body style="font-family:Arial">
  <h1>${var.project} - ${var.operation} - $(hostname)</h1>
  <p>OK desde EC2 en puerto 8080</p>
  </body></html>
  HTML
  # Cambiar nginx a 8080
  sed -i 's/listen       80;/listen       8080;/' /etc/nginx/nginx.conf
  systemctl enable nginx
  systemctl restart nginx
  EOT
}

resource "aws_instance" "webapi_a" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.app_private_a.id
  vpc_security_group_ids      = [aws_security_group.app_sg.id]
  associate_public_ip_address = false
  user_data                   = local.user_data

  tags = {
    Name = "ec2-${var.project}-${var.operation}-webapi-a-001-ca"
    Role = "webapi"
  }
}

resource "aws_instance" "gameapi_b" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.app_private_b.id
  vpc_security_group_ids      = [aws_security_group.app_sg.id]
  associate_public_ip_address = false
  user_data                   = local.user_data

  tags = {
    Name = "ec2-${var.project}-${var.operation}-gameapi-b-001-ca"
    Role = "gameapi"
  }
}

# Registrar instancias en el Target Group
resource "aws_lb_target_group_attachment" "webapi_a_att" {
  target_group_arn = aws_lb_target_group.apps_tg.arn
  target_id        = aws_instance.webapi_a.id
  port             = 8080
}

resource "aws_lb_target_group_attachment" "gameapi_b_att" {
  target_group_arn = aws_lb_target_group.apps_tg.arn
  target_id        = aws_instance.gameapi_b.id
  port             = 8080
}

#######################################
# DW - ROUTE TABLE PRIVADA y ASOCIACIONES
#######################################
resource "aws_route_table" "dw_private_rt" {
  vpc_id = aws_vpc.dw.id
  tags = {
    Name = "rt-${var.project}-${var.operation}-dw-private-001-ca"
  }
}

resource "aws_route" "dw_to_app" {
  route_table_id            = aws_route_table.dw_private_rt.id
  destination_cidr_block    = "10.0.0.0/16" # VPC APP
  vpc_peering_connection_id = aws_vpc_peering_connection.app_dw.id
}

resource "aws_route_table_association" "dw_priv_assoc_a" {
  subnet_id      = aws_subnet.dw_private_a.id
  route_table_id = aws_route_table.dw_private_rt.id
}

resource "aws_route_table_association" "dw_priv_assoc_b" {
  subnet_id      = aws_subnet.dw_private_b.id
  route_table_id = aws_route_table.dw_private_rt.id
}

#######################################
# APP - RUTAS PRIVADAS hacia DW por peering
# (en tus RT privadas existentes de APP: a y b)
#######################################
resource "aws_route" "app_priv_a_to_dw" {
  route_table_id            = aws_route_table.app_private_rt_a.id
  destination_cidr_block    = "10.1.0.0/16" # VPC DW
  vpc_peering_connection_id = aws_vpc_peering_connection.app_dw.id
}

resource "aws_route" "app_priv_b_to_dw" {
  route_table_id            = aws_route_table.app_private_rt_b.id
  destination_cidr_block    = "10.1.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.app_dw.id
}

#######################################
# SG RDS (DW)
#######################################
resource "aws_security_group" "rds_sg" {
  name   = "rds-${var.project}-${var.operation}-dw-sg-001"
  vpc_id = aws_vpc.dw.id

  # Permitir MySQL solo desde las instancias con app_sg (privadas en APP)
  ingress {
    description     = "MySQL 3306 from app_sg"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "sg-${var.project}-${var.operation}-rds-dw-001-ca" }
}

#######################################
# DB SUBNET GROUP (DW)
#######################################
resource "aws_db_subnet_group" "dw_db_subnets" {
  name       = "dbsubnet-${var.project}-${var.operation}-dw-001"
  subnet_ids = [aws_subnet.dw_private_a.id, aws_subnet.dw_private_b.id]

  tags = {
    Name = "dbsubnet-${var.project}-${var.operation}-dw-001"
  }
}

#######################################
# PASSWORD aleatorio
#######################################
resource "random_password" "db_master" {
  length      = 20
  special     = false
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1




}

#######################################
# RDS MySQL en DW (Multi-AZ)
#######################################
resource "aws_db_instance" "dw_mysql" {
  identifier            = "rds-${var.project}-${var.operation}-dw-001"
  engine                = "mysql"
  engine_version        = "8.0"           # deja que AWS resuelva el minor
  instance_class        = var.db_instance # "db.t3.micro"
  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp3"

  db_name  = "promarketing"
  username = "promk_admin"
  password = random_password.db_master.result

  multi_az               = true
  db_subnet_group_name   = aws_db_subnet_group.dw_db_subnets.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  publicly_accessible    = false
  deletion_protection    = false # demo
  skip_final_snapshot    = true  # demo (en prod: false + snapshot_identifier)
  apply_immediately      = true

  backup_retention_period = 1 # demo (en prod >=7)
  maintenance_window      = "Sun:03:00-Sun:04:00"
  backup_window           = "01:30-02:30"

  tags = {
    Name    = "rds-${var.project}-${var.operation}-dw-001"
    Project = var.project
    Oper    = var.operation
    Role    = "dw"
  }

  depends_on = [
    aws_route.app_priv_a_to_dw,
    aws_route.app_priv_b_to_dw,
    aws_route.dw_to_app
  ]
  storage_encrypted = true
}





#######################################
# ASSETS - S3 PRIVADO + CLOUDFRONT (OAC)
#######################################

# Nombre único (S3 es global)
locals {
  assets_bucket_name = "s3-${var.project}-${var.operation}-assets-${var.account_id}-ca"
}

resource "aws_s3_bucket" "assets" {
  bucket = local.assets_bucket_name
  tags = {
    Name    = local.assets_bucket_name
    Project = var.project
    Oper    = var.operation
    Env     = "demo"
  }
}

resource "aws_s3_bucket_public_access_block" "assets" {
  bucket                  = aws_s3_bucket.assets.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "assets" {
  bucket = aws_s3_bucket.assets.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Un index.html mínimo (visual) para probar el CDN
resource "aws_s3_object" "assets_index" {
  bucket       = aws_s3_bucket.assets.id
  key          = "index.html"
  content_type = "text/html"
  content      = <<-HTML
  <!doctype html>
  <html lang="es"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Assets CDN</title>
  <style>body{font-family:Inter,system-ui,-apple-system,Segoe UI,Roboto,Ubuntu,sans-serif;background:#f6f7f9;margin:0;padding:40px;color:#111}
  .card{max-width:720px;margin:0 auto;background:#fff;border-radius:16px;box-shadow:0 6px 30px rgba(0,0,0,.08);padding:28px}
  .btn{display:inline-block;padding:10px 16px;border-radius:10px;background:#2563eb;color:#fff;text-decoration:none}
  pre{background:#0f172a;color:#e2e8f0;padding:12px;border-radius:10px;overflow:auto}</style></head>
  <body><div class="card">
  <h1>CDN de estáticos (S3 + CloudFront)</h1>
  <p>Este HTML viene del bucket privado a través de CloudFront con OAC.</p>
  <p><a class="btn" href="http://${aws_lb.app_alb.dns_name}">Ir al ALB (HTTP)</a></p>
  <pre>ALB DNS: ${aws_lb.app_alb.dns_name}</pre>
  </div></body></html>
  HTML

  depends_on = [
    aws_s3_bucket_public_access_block.assets,
    aws_s3_bucket_ownership_controls.assets
  ]
}

# OAC (firma SigV4) para el origen S3
resource "aws_cloudfront_origin_access_control" "assets_oac" {
  name                              = "oac-${var.project}-${var.operation}-assets"
  description                       = "OAC for ${aws_s3_bucket.assets.bucket}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# Distribución CloudFront
resource "aws_cloudfront_distribution" "assets_cdn" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "cdn-${var.project}-${var.operation}-assets"
  default_root_object = "index.html"
  #==========ORIGEN s3 con OAC ======================#
  origin {
    origin_id                = "s3-assets-origin"
    domain_name              = aws_s3_bucket.assets.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.assets_oac.id

    s3_origin_config {
      origin_access_identity = ""
    }

    #=========== Comportamiento por defecto ===========#

  }

  default_cache_behavior {
    target_origin_id       = "s3-assets-origin"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6" # Managed-CachingOptimized
  }

  # Aliases y certificado (solo ACM de us-east-1 compatible con Cloudfront)

  aliases = var.acm_cert_arn_cf != "" ? [var.assets_domain] : null

  #====== Certificado ======= #

  viewer_certificate {
    acm_certificate_arn            = var.acm_cert_arn_cf != "" ? var.acm_cert_arn_cf : null
    cloudfront_default_certificate = var.acm_cert_arn_cf == "" ? true : null
    ssl_support_method             = var.acm_cert_arn_cf != "" ? "sni-only" : null
    minimum_protocol_version       = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name    = "cdn-${var.project}-${var.operation}-assets"
    Project = var.project
    Oper    = var.operation
  }

  depends_on = [aws_s3_object.assets_index]
}

# Política del bucket para permitir SOLO a esta distribución (OAC)
data "aws_iam_policy_document" "assets_policy" {
  statement {
    sid       = "AllowCloudFrontOACRead"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.assets.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.assets_cdn.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "assets" {
  bucket     = aws_s3_bucket.assets.id
  policy     = data.aws_iam_policy_document.assets_policy.json
  depends_on = [aws_cloudfront_distribution.assets_cdn]
}




#######################################
# REDIS (ELASTICACHE) - VPC APP
#######################################

# Subnet group en privadas a/b
resource "aws_elasticache_subnet_group" "app_redis" {
  name       = "ec-subnet-${var.project}-${var.operation}-app-001"
  subnet_ids = [aws_subnet.app_private_a.id, aws_subnet.app_private_b.id]
  tags = {
    Name    = "ec-subnet-${var.project}-${var.operation}-app-001"
    Project = var.project
    Oper    = var.operation
  }
}

# SG para Redis: permite 6379 solo desde el SG de las apps (app_sg)
resource "aws_security_group" "redis_sg" {
  name   = "redis-${var.project}-${var.operation}-sg-001"
  vpc_id = aws_vpc.app.id

  ingress {
    description     = "Redis 6379 from app_sg"
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "sg-${var.project}-${var.operation}-redis-001-ca" }
}

# Parameter group (opcional) para Redis 7
resource "aws_elasticache_parameter_group" "redis7" {
  name   = "pg-${var.project}-${var.operation}-redis7-001"
  family = "redis7"
  # Ejemplo: habilitar notificaciones de eventos de clave (opcional)
  # parameter {
  #   name  = "notify-keyspace-events"
  #   value = "Ex"
  # }
  tags = { Name = "pg-${var.project}-${var.operation}-redis7-001" }
}

# Replication Group (modo simple: 1 nodo, sin TLS/auth)
resource "aws_elasticache_replication_group" "redis" {
  replication_group_id = "rg-${local.proj8}-${local.op8}-001"
  description          = "Redis for ${var.project}/${var.operation}"
  engine               = "redis"
  engine_version       = "7.0"
  node_type            = var.redis_node_type
  port                 = 6379

  num_cache_clusters         = 1     # 1 nodo (demo)
  automatic_failover_enabled = false # debe ser false con 1 nodo
  multi_az_enabled           = false

  subnet_group_name    = aws_elasticache_subnet_group.app_redis.name
  security_group_ids   = [aws_security_group.redis_sg.id]
  parameter_group_name = aws_elasticache_parameter_group.redis7.name

  at_rest_encryption_enabled = false # demo: simple
  transit_encryption_enabled = false # demo: simple (si pones true, necesitas auth_token)

  tags = {
    Name    = "redis-${var.project}-${var.operation}-001"
    Project = var.project
    Oper    = var.operation
  }
}

