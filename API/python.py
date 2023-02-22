import boto3

# Initialize the Boto3 clients for each service
ec2_client = boto3.client('ec2')
rds_client = boto3.client('rds')
s3_client = boto3.client('s3')
# Add more clients for other services as needed

# Get a list of all the AWS regions
aws_regions = [region['RegionName'] for region in boto3.client('ec2').describe_regions()['Regions']]

# Loop through each region
for region in aws_regions:
    print(f'Region: {region}')

    # List all EC2 instances in the region
    instances = ec2_client.describe_instances()
    for reservation in instances['Reservations']:
        for instance in reservation['Instances']:
            print(f'EC2 Instance ID: {instance["InstanceId"]}')

    # List all RDS instances in the region
    db_instances = rds_client.describe_db_instances()
    for db_instance in db_instances['DBInstances']:
        print(f'RDS Instance ID: {db_instance["DBInstanceIdentifier"]}')

    # List all S3 buckets in the region
    s3_buckets = s3_client.list_buckets()
    for bucket in s3_buckets['Buckets']:
        print(f'S3 Bucket Name: {bucket["Name"]}')

    # Add more resource types for other services as needed
