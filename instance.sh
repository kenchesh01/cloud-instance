aws ec2 run-instances \
	--image-id ami-0bbe28eb2173f6167 \
	--instance-type t2.micro \
	--subnet-id subnet-6fad9515 \
	--security-group-ids sg-0c1c2639e1545ee38 \
	--associate-public-ip-address \
	--key-name jenkins \
	--region us-east-2
