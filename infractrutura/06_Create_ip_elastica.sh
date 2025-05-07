#!/bin/bash
set -x

# Deshabilitamos la paginación de la salida de los comandos de AWS CLI
# Referencia: https://docs.aws.amazon.com/es_es/cli/latest/userguide/cliv2-migration.html#cliv2-migration-output-pager
export AWS_PAGER=""

# Configuramos el nombre de la instancia a la que le vamos a asignar la IP elástica
INSTANCE_NAME=frontend-01
INSTANCE_NAME_F2=frontend-02
INSTANCE_NAME_B=backup
INSTANCE_NAME_D=Balancer
INSTANCE_NAME_L=LEMP



# Obtenemos el Id de la instancia a partir de su nombre
INSTANCE_ID=$(aws ec2 describe-instances \
            --filters "Name=tag:Name,Values=$INSTANCE_NAME" \
                      "Name=instance-state-name,Values=running" \
            --query "Reservations[*].Instances[*].InstanceId" \
            --output text)


INSTANCE_ID2=$(aws ec2 describe-instances \
            --filters "Name=tag:Name,Values=$INSTANCE_NAME_F2" \
                      "Name=instance-state-name,Values=running" \
            --query "Reservations[*].Instances[*].InstanceId" \
            --output text)


INSTANCE_ID3=$(aws ec2 describe-instances \
            --filters "Name=tag:Name,Values=$INSTANCE_NAME_B" \
                      "Name=instance-state-name,Values=running" \
            --query "Reservations[*].Instances[*].InstanceId" \
            --output text)

INSTANCE_ID4=$(aws ec2 describe-instances \
            --filters "Name=tag:Name,Values=$INSTANCE_NAME_D" \
                      "Name=instance-state-name,Values=running" \
            --query "Reservations[*].Instances[*].InstanceId" \
            --output text)


INSTANCE_ID5=$(aws ec2 describe-instances \
            --filters "Name=tag:Name,Values=$INSTANCE_NAME_L" \
                      "Name=instance-state-name,Values=running" \
            --query "Reservations[*].Instances[*].InstanceId" \
            --output text)

# Creamos una IP elástica
ELASTIC_IP=$(aws ec2 allocate-address --query PublicIp --output text)
ELASTIC_IP2=$(aws ec2 allocate-address --query PublicIp --output text)
ELASTIC_IP3=$(aws ec2 allocate-address --query PublicIp --output text)
ELASTIC_IP4=$(aws ec2 allocate-address --query PublicIp --output text)
ELASTIC_IP5=$(aws ec2 allocate-address --query PublicIp --output text)
# Asociamos la IP elástica a la instancia del balanceador
aws ec2 associate-address --instance-id $INSTANCE_ID --public-ip $ELASTIC_IP
aws ec2 associate-address --instance-id $INSTANCE_ID2 --public-ip $ELASTIC_IP2
aws ec2 associate-address --instance-id $INSTANCE_ID3 --public-ip $ELASTIC_IP3
aws ec2 associate-address --instance-id $INSTANCE_ID4 --public-ip $ELASTIC_IP4
aws ec2 associate-address --instance-id $INSTANCE_ID5 --public-ip $ELASTIC_IP5