#!/bin/bash
set -x

# Deshabilitamos la paginación de la salida de los comandos de AWS CLI
# Referencia: https://docs.aws.amazon.com/es_es/cli/latest/userguide/cliv2-migration.html#cliv2-migration-output-pager
export AWS_PAGER=""
# ---------------------------------------------
# Variable Conf
AMI_ID=ami-0472eef47f816e45d
COUNT=1
INTANCE_TYPE=t2.micro
KEY_NAME=IAW
SECURIRY_GROUP=frontend-sg
INSTANCE_NAME=frontend-01

AMI_ID_F2=ami-0472eef47f816e45d
COUNT_F2=1
INTANCE_TYPE_F2=t2.micro
KEY_NAME_F2=IAW
SECURIRY_GROUP_F2=frontend-sg
INSTANCE_NAME_F2=frontend-02


SECURIRY_GROUP_B=backup-sg
INSTANCE_NAME_B=backup

SECURIRY_GROUP_D=frontend-sg
INSTANCE_NAME_D=Balancer

INSTANCE_NAME_L=LEMP
# -----------------------------------





# Fronted-01
aws ec2 run-instances \
    --image-id $AMI_ID \
    --count $COUNT \
    --instance-type $INTANCE_TYPE \
    --key-name $KEY_NAME \
    --security-groups $SECURIRY_GROUP \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME}]"



# Fronted-02
aws ec2 run-instances \
    --image-id $AMI_ID_F2 \
    --count $COUNT_F2 \
    --instance-type $INTANCE_TYPE_F2 \
    --key-name $KEY_NAME_F2 \
    --security-groups $SECURIRY_GROUP_F2 \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME_F2}]"

# Backup
aws ec2 run-instances \
    --image-id $AMI_ID \
    --count $COUNT \
    --instance-type $INTANCE_TYPE \
    --key-name $KEY_NAME \
    --security-groups $SECURIRY_GROUP_B \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME_B}]"

# Balancer
aws ec2 run-instances \
    --image-id $AMI_ID \
    --count $COUNT \
    --instance-type $INTANCE_TYPE \
    --key-name $KEY_NAME \
    --security-groups $SECURIRY_GROUP_D \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME_D}]"

    # LEMP
aws ec2 run-instances \
    --image-id $AMI_ID \
    --count $COUNT \
    --instance-type $INTANCE_TYPE \
    --key-name $KEY_NAME \
    --security-groups $SECURIRY_GROUP \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME_L}]"