### Installing and Configuring Terraform v1.5.2 with tfenv

```bash
# Clone tfenv
git clone https://github.com/tfutils/tfenv.git ~/.tfenv

# Add tfenv to your PATH
echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Verify tfenv is available
which tfenv
# Should return: /home/your-user/.tfenv/bin/tfenv

# Install Terraform v1.5.2
tfenv install 1.5.2
# Output should confirm successful installation

# Set Terraform 1.5.2 as the default version
tfenv use 1.5.2


# (Optional) Pin version to this project
echo "1.5.2" > ~/projects/quality-group-case/.terraform-version
```

export AWS_PROFILE=qg_case_user

vpc_id = vpc-0e8471e886fad17c5
cidr = 172.31.0.0/16
subnet :
subnet-032f05d2bf79cae47
172.31.32.0/20
rtb-0b0b7372d5cbd6f63
acl-074bf0b5e782d629b

subnet-04580d1a8986b23d4
172.31.16.0/20
rtb-0b0b7372d5cbd6f63
acl-074bf0b5e782d629b

subnet-02bfc67ae6cbaf5c2
172.31.0.0/20
rtb-0b0b7372d5cbd6f63
acl-074bf0b5e782d629b


public ip : 3.122.180.46


subnet-04580d1a8986b23d4 1a
subnet-032f05d2bf79cae47 1b
subnet-02bfc67ae6cbaf5c2 1c

terraform apply | tee apply.log

(esn) mdogui@DE-CND22146LC:~/projects/quality-group-case/lambdas/my_lambda/src$ python -m uvicorn main:app --reload

