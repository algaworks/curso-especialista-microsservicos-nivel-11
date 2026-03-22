# AlgaDelivery VPC Architecture:
#
# Region: us-east-1
# VPC: 172.31.0.0/16
#
# Public Subnets (subnet-pub-a/b/c):
#   172.31.1.0/24, 172.31.2.0/24, 172.31.3.0/24
#   → Internet Gateway → Internet
#
# Management Subnets (subnet-management-a/b/c):
#   172.31.4.0/24, 172.31.5.0/24, 172.31.6.0/24
#   → NAT Gateway (via público) → Internet
#
# Cluster Subnets (subnet-cluster-a/b/c):
#   172.31.7.0/24, 172.31.8.0/24, 172.31.9.0/24
#   → NAT Gateway (via público) → Internet
