# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

###Deploy your project using Elastic Beanstalk

####SSH To EC2 And Clone Repository

1. ssh into our EC2 instance with the provided secret key SupremePotato.pem
```sh
ssh -i ~/Downloads/SupremePotato.pem.txt SupremePotato@ec2.cs291.com
```

2. clone SupremePotato repository using HTTPS
```sh
git clone https://github.com/scalableinternetservices/SupremePotato.git
```

3. configure Elastic Beanstalk
```sh
cd SupremePotato
eb init --keyname $(whoami) \
  --platform "64bit Amazon Linux 2018.03 v2.11.0 running Ruby 2.6 (Puma)" \
  --region us-west-2 SupremePotato
```

4. perform delpoyment on Elastic Beanstalk (replace [YOURNAME] with your name)
```sh
eb create --envvars SECRET_KEY_BASE=BADSECRET \
  -db.engine postgres -db.i db.t3.micro -db.user u \
  -i t3.micro --single [YOURNAME]
```

5. verify the deployment (replace [YOURNAME] with your name)
```sh
eb status [YOURNAME]
```
If the deployment is successful, the `Status` field should be `Ready`, and the `Health` should be `Green`.

####Seed the Dababase

1. ssh into your application server (replace [YOURNAME] with your name)
```sh
eb ssh -e "ssh -i ~/$(whoami).pem" [YOURNAME]
cd /var/app/current
```

2. to seed the database
```sh
rails db:seed
```
If you encounter permission issue, please make sure to configure the permission for the /var/app/current/tmp directory.


* ...











