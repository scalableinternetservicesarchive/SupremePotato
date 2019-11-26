# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

### Deploy your project using Elastic Beanstalk

#### SSH To EC2 And Clone Repository

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

4. perform delpoyment on Elastic Beanstalk (replace [YOURNAME] with your instance name)
```sh
eb create --envvars SECRET_KEY_BASE=BADSECRET \
  -db.engine postgres -db.i db.t3.micro -db.user u \
  -i t3.micro --single [YOURNAME]
```
* `-i` (the app server) can be one of
	* t3.nano
	* t3.micro
	* t3.small
	* t3.medium
	* t3.large
	* t3.xlarge
	* t3.2xlarge
* `-db.i` (the database server) can be one of
	* db.t3.nano
	* db.t3.micro
	* db.t3.small
	* db.t3.medium
	* db.t3.large
	* db.t3.xlarge
	* db.t3.2xlarge
* More info regarding [AWS EC2 Instance Type](https://aws.amazon.com/ec2/instance-types/) 

5. verify the deployment (replace [YOURNAME] with your instance name)
```sh
eb status [YOURNAME]
```
If the deployment is successful, the `Status` field should be `Ready`, and the `Health` should be `Green`.

#### Add App Instances & Load Balancer in Web Browser
1. log in [AWS Console](https://aws.amazon.com)
2. go to `Elastic Beanstalk` -> `Click on your EB Deployment` -> `Configuration` -> `Modify Capacity`
3. set **Environment Type** to `Load Balanced`
4. make sure that **Instances Min** and **Instances Max** are the same 
5. click on **Apply** to complete

#### Seed the Database

1. ssh into your application server (replace [YOURNAME] with your instance name)
```sh
eb ssh -e "ssh -i ~/$(whoami).pem" [YOURNAME]

//go to your deployed app folder
cd /var/app/current
```
2. to seed the database (the seed file will wipe all existing database entries)
```sh
rails db:seed
```
3. if you encounter permission issue, please make sure to correct the permission (run `sudo chmod`) of the following directories
`/var/app/current/tmp`  & `/var/app/current/log` 

#### Update The Application
1. pull the latest change from repository
```sh
git pull origin master
```
2. update the application (replace [YOURNAME] with your instance name)
```sh
eb deploy [YOURNAME]
``` 

#### Some Useful Elastic Beanstalk Commands
1. to view the list of existing instances
```sh
eb list
```
2. set default eb instance
```sh
eb use [NameOfInstance]
```
3. view eb Environment Variable
```sh
eb printenv [NameOfInstance]
```






