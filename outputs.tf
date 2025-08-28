output "alb_dns_name" { value = aws_lb.app_alb.dns_name }
output "alb_arn" { value = aws_lb.app_alb.arn }

output "app_vpc_id" { value = aws_vpc.app.id }
output "dw_vpc_id" { value = aws_vpc.dw.id }

output "app_public_rt_id" { value = aws_route_table.app_public_rt.id }
output "app_public_rt_b_id" { value = aws_route_table.app_public_rt_b.id }
output "app_private_rt_a_id" { value = aws_route_table.app_private_rt_a.id }
output "app_private_rt_b_id" { value = aws_route_table.app_private_rt_b.id }

output "dw_rds_endpoint" { value = aws_db_instance.dw_mysql.address }
output "dw_rds_port" { value = aws_db_instance.dw_mysql.port }
output "dw_rds_sg_id" { value = aws_security_group.rds_sg.id }

output "redis_primary_endpoint" { value = aws_elasticache_replication_group.redis.primary_endpoint_address }
output "redis_reader_endpoint" { value = aws_elasticache_replication_group.redis.reader_endpoint_address }
output "redis_port" { value = aws_elasticache_replication_group.redis.port }

output "assets_bucket_name" { value = aws_s3_bucket.assets.bucket }
output "assets_cdn_domain" { value = aws_cloudfront_distribution.assets_cdn.domain_name }
output "assets_cdn_id" { value = aws_cloudfront_distribution.assets_cdn.id }

