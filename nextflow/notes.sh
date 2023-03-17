# account-id
****804

# coyote PW
## not **

# key - pair
#for coyote.pem
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDNhqRGuqtayAVEKOh7QtQW8gyIFtXUv8itwjJkIrCWUmRD4Thzug+YyLv888mF2rctVI1oSXzFE2j++lQnAAT9GpuwDKBc9jnszA/bD8WS+IZBAFFBbArgAr7+gLcmBXoGhC6hZyjC7pa9aXTBoGvohk7wJhqGD+ao16/uIZU6NgJBhgkFicPuVJnSEVmrsBOpcRIqbFHPoCGlZ7AAYy97QjRfO96JLjV6+vdrs9hdHelBFeOQCSl7px7wNhld5Pc7iRrGVfnnxbL8Tm8cY6vEFyK9z++anVoxtAc0oPWrGXmkN3AS3aw6vhT5s0M7fK4NxWrfgsCsMs//jTdG+Hrt



sudo usermod -aG docker ${USER}

-rwx --x --x 1 root root  14721 Mar  8 20:31 /usr/bin/nextflow
-rwx r-x r-x 1 root root  35328 Feb  7  2022 /usr/bin/nice

scp -i "~/AWS/coyote.pem" /home/coyote/Downloads/1026189_23153_0_0.normalized.mutect.filtered.vcf.gz ubuntu@ec2-3-141-199-24.us-east-2.compute.amazonaws.com:/home/ubuntu/nf_tutorials/
1026189_23153_0_0.normalized.mutect.filtered.vcf.gz

useradd coyote
passwd coyote
sudo usermod -aG ubuntu coyote

#IAM inline policy 
https://us-east-1.console.aws.amazon.com/iam/home#/users/coyote$policyEditor?policyName=read_write&step=edit
https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ExamplePolicies_EC2.html#iam-example-runinstances
https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_variables.html

#s3 policy roles
https://docs.aws.amazon.com/service-authorization/latest/reference/list_amazons3.html
{
    "Effect": "Allow",
    "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:ListBucketMultipartUploads",
        "s3:AbortMultipartUpload",
        "s3:PutObjectVersionAcl",
        "s3:DeleteObject",
        "s3:PutObjectAcl",
        "s3:ListMultipartUploadParts",
        "s3:ListBucket",
        "s3:PutBucketMultipartUpload"
    ],
    "Resource": [
        "arn:aws:s3:::wiley-data",
        "arn:aws:s3:::wiley-data/*"
    ]
}
# actions resources conditions head
https://docs.aws.amazon.com/service-authorization/latest/reference/reference_policies_actions-resources-contextkeys.html
# actions resources conditions ec2
https://docs.aws.amazon.com/service-authorization/latest/reference/list_amazonec2.html
# actions resources conditions batch
https://docs.aws.amazon.com/service-authorization/latest/reference/list_awsbatch.html


aws ec2 describe-instances --instance-ids i-012f77ff146b8fb07 --region "us-east-2" --query 'Reservations[].Instances[].PublicDnsName' | jq
aws ec2 describe-instances --profile coyote --region "us-east-2"

# Admin stuff
To use this profile, specify the profile name using --profile, as shown:
aws s3 ls --profile AdministratorAccess-068851915804

The ARN for the BatchServiceRolePolicy policy is in the following format:
arn:aws:iam::aws:policy/aws-service-role/BatchServiceRolePolicy

# Batch
# Service-linked role permissions for AWS Batch
https://docs.aws.amazon.com/batch/latest/userguide/using-service-linked-roles.html


# attach gateway to vpc
aws ec2 attach-internet-gateway --vpc-id "vpc-0c0d9efa4b500d463" --internet-gateway-id "igw-0952e14e2666bc6ec" --region us-east-2


aws iam create-policy --policy-name ec2-instance-connect --policy-document file://ec2_conn.json
aws iam attach-user-policy --policy-arn arn:aws:iam::068851915804:policy/ec2-instance-connect --user-name coyote



# nextflow
https://www.nextflow.io/docs/latest/awscloud.html#aws-security-credentials

export JAVA_HOME=/usr
nextflow run bcftools.nf \
    -bucket-dir s3://wiley-data/data/ \
    -work-dir s3://wiley-data/data/ \
    -with-trace -with-timeline -with-dag -with-report -latest -resume

nextflow run bcftools.nf \
    -profile batch -bucket-dir s3://${BUCKET_NAME_TEMP} --outdir=s3://${BUCKET_NAME_RESULTS}/batch \
    -with-trace -with-timeline -with-dag -with-report -latest

nextflow run bcftools.nf -profile awsbatch -bucket-dir s3://wiley-data/data/ -work-dir s3://wiley-data/data/brian_is_great/ -resume
nextflow -log bcftools.log run bcftools.nf -profile awsbatch -work-dir s3://wiley-data/data/vcfs/outputs -resume --input_csv input.csv --ref s3://wiley-data/data/single_cell/transcriptome/fasta/genome.fa --sample s3://wiley-data/data/vcfs/publish/1026189/
nextflow run bcftools.nf -profile awsbatch -bucket-dir s3://wiley-data/data/sample1 -work-dir s3://wiley-data/data/sample1 -resume -with-weblog 'http://localhost:4567' -with-report


nextflow run scrna.nf -work-dir /media/coyote/USB31FD/nextflow -resume 
# default nextflow2.config with process.queue = 'cellranger'
nextflow -log cellranger_queue.log run scrna.nf -profile awsbatch -bucket-dir s3://wiley-data/data/single_cell/ -work-dir s3://wiley-data/data/single_cell/ -resume 
nextflow -log cellranger_queue2.log -c nextflow3.config run scrna.nf -profile awsbatch -bucket-dir s3://wiley-data/test/ -work-dir s3://wiley-data/data/single_cell/ -resume 

# process.queue = 'test_queue_ec2'
nextflow -log test_queue_ec2.log -c nextflow2.config run scrna.nf -profile awsbatch -bucket-dir s3://wiley-data/data/single_cell/ -work-dir s3://wiley-data/data/single_cell/
nextflow -log test_queue_ec2.log -c nextflow2.config run scrna.nf -profile awsbatch -work-dir s3://wiley-data/scratch
nextflow -log test_queue_ec2.2.log -c nextflow2.config run scrna.nf -profile awsbatch -work-dir s3://wiley-data/scratch2

s3cmd sync /data/refdata-gex-GRCh38-2020-A/ s3://wiley-data/data/single_cell/transcriptome/ --delete-removed --exclude="some_file" --exclude="*directory*"  --progress --no-preserve



echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/add-instance-store-volumes.html#adding-instance-storage-instance
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-using-volumes.html
$ lsblk
NAME          MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
nvme1n1       259:0    0  128G  0 disk /data
nvme0n1       259:1    0    8G  0 disk 
├─nvme0n1p1   259:2    0    8G  0 part /
└─nvme0n1p128 259:3    0    1M  0 part 

$ sudo blkid
/dev/nvme1n1: UUID="c2993297-b482-45a3-9195-6bb3ec63f1d0" TYPE="xfs"
/dev/nvme2n1: UUID="eb8c1eb1-ab78-444a-a3f9-0cb4a4597e29" BLOCK_SIZE="512" TYPE="xfs"

# /data
/dev/nvme2n1: UUID="a8b9de1b-0512-4945-b89e-e30a0b2fccdb" BLOCK_SIZE="512" TYPE="xfs"
# /var/lib/docker/overlay2
/dev/nvme1n1: UUID="5ddb31ed-4b5f-4720-94b9-57ebd2f9248e" BLOCK_SIZE="512" TYPE="xfs"


DATE=$(date +%Y-%m-%d)
bucket='wiley-data'
aws s3api list-objects-v2 --bucket "$bucket" \
    --query 'Contents[?contains(LastModified, `'"$DATE"'`)].Key'


[default]
aws_access_key_id = ***YNP
aws_secret_access_key = ***bNrANBsWuxSynCdLuGk1H2KdhCDQ+7jOZg+c5wkF

aws_session_token=IQoJb3JpZ2luX2VjEL///////////wEaCXVzLWVhc3QtMiJIMEYCIQC97u9/gWgpJeqYYyHR4LBvLZM78Enw1uS9+7fg2ncmUAIhAIvSkUqe0+U+DaITMFGO4/k7vy78wx2iHc9UfSvX45YzKu8CCHgQABoMMDY4ODUxOTE1ODA0Igz2fR+vr7+TFtHrknkqzAKHi3wIv+4XU1UcSOpnZxKIqH3agpBYp7iIhap7x/w6qjS5wrESGT+gLBkWzfWXxyKrYaXRknEHvYuj76ga7+ZqgmpEf0o4vmHV8HV0LKR1u1/DBxuNng40JEFWJnTjSUT01Lc3M7HFSGAkmOwjKhBvQlQSlzvf6yUVhRzkMDSYAldYpyMIZBEMMmAHDzqZbGqtbY9znBsteqil1xTMR7NKfZCQCPL1Rz00vIjh+Ni/AconqxlMGEt8yq+CKy1E4+pSPfQA5xpDqE6vyy3co0e4pePwd9B/vyjT5XwyOkdSMPZGasRfzVHNI2jPM9Hw0t1YChShMEPL579q6rfwcxrJoIqXtwBK9bY0pE3EoS5cCh/b2wsBrqT5M4hjJgACh2S2IuKaH9YlEbd7AWRwrWWe/EGLCEf/CoaGDAt0crQKc3WUC+/3oaT70oo1WjCdk62gBjqmAa23saGqLPj6GfOhTW8/La39GfzVhM8r4idmt72isyF+1thHKlSQiNdDSd7D1mPzRVwH2euwIGZcaHfvsY78Jgx/okZGNkT+i7CVNZ79qx7SZFN8rT47iWIjqgLct5ZQU1qRB+3VAFVtm+aWq8rRNpGuXCneqHQ8Z8hPUsYY0XCXBErPsAgx4EBj02fDcqniUZWQ5bNDY5chW2fY9IcHPSgO1yQyXV8=




GCP - https://groups.google.com/g/gce-discussion/c/O-c10TM4ZLM
gcloud compute scp --ssh-key-file=/home/coyote/.ssh/google_compute_engine /media/coyote/USB31FD/MD/GROMACS/I_D_Bind2/gen1/CompE0_V0.{xtc,tpr,gro}  instance-gpu:/home/coyote/MD/Gromacs_mdps/I_D_Bind2/gen1

gcloud compute scp --ssh-key-file=/home/coyote/.ssh/google_compute_engine /media/coyote/USB31FD/MD/GROMACS/I_D_Bind2/gen1/piGhcbO.out  instance-gpu:/home/coyote/MD/Gromacs_mdps/I_D_Bind2/gen1
