import boto3
import os

region = os.environ['region']
instances = [os.environ['instance_id']]
ec2 = boto3.client('ec2', region_name=region)

def lambda_handler(event, context):
    ec2.reboot_instances(InstanceIds=instances)
    print('rebooted instances: ' + str(instances))