import boto3

# Initializing a session using the default region and AWS credentials
session = boto3.Session()

# Initialize the Boto3 clients for each service
ec2_client = boto3.client('ec2')
rds_client = boto3.client('rds')
s3_client = boto3.client('s3')

# Creating a list of regions
regions = session.get_available_regions('ec2')

# Geting a list of all the AWS regions
aws_regions = [region['RegionName'] for region in boto3.client('ec2').describe_regions()['Regions']]

# Iterating through each region and listing the resources being used
for region in regions:
    print(f"Resources in {region}:")
    ec2 = session.resource('ec2', region_name=region)
    instances = list(ec2.instances.all())
    volumes = list(ec2.volumes.all())
    snapshots = list(ec2.snapshots.all())
    rds = session.client('rds', region_name=region)
    db_instances = rds.describe_db_instances()['DBInstances']
    s3 = session.client('s3', region_name=region)
    buckets = s3.list_buckets()['Buckets']
    
    # Print EC2 instances
    print(f"\tEC2 instances:")
    for instance in instances:
        print(f"\t\tInstance ID: {instance.id}")
        print(f"\t\tInstance Type: {instance.instance_type}")
        print(f"\t\tInstance State: {instance.state['Name']}")
        print()
    
    # Print EBS volumes
    print(f"\tEBS volumes:")
    for volume in volumes:
        print(f"\t\tVolume ID: {volume.id}")
        print(f"\t\tVolume Type: {volume.volume_type}")
        print(f"\t\tVolume State: {volume.state}")
        print()
    
    # Print EBS snapshots
    print(f"\tEBS snapshots:")
    for snapshot in snapshots:
        print(f"\t\tSnapshot ID: {snapshot.id}")
        print(f"\t\tSnapshot Volume ID: {snapshot.volume_id}")
        print(f"\t\tSnapshot State: {snapshot.state}")
        print()

    # Print RDS DB instances
    print(f"\tRDS DB instances:")
    for db_instance in db_instances:
        print(f"\t\tDB Instance ID: {db_instance['DBInstanceIdentifier']}")
        print(f"\t\tDB Instance Engine: {db_instance['Engine']}")
        print(f"\t\tDB Instance Status: {db_instance['DBInstanceStatus']}")
        print()
    
    # Print S3 buckets
    print(f"\tS3 buckets:")
    for bucket in buckets:
        print(f"\t\tBucket Name: {bucket['Name']}")
        print(f"\t\tBucket Creation Date: {bucket['CreationDate']}")
       
