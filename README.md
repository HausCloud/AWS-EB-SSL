# AWS-EB-SSL
#### Easy secure **single** instance AWS Elastic Beanstalk environments .. for nginx (say that 3 times fast)

## Prerequisites

- Deployed sample application
  - Only platforms configured with **nginx** is supported
    - Why? EB favors nginx ([docs](https://docs.aws.amazon.com/elasticbeanstalk/latest/platforms/platforms-supported.html)) and super opinionated nginx > apache
- [**Elastic Beanstalk Command Line Interface**](https://github.com/aws/aws-elastic-beanstalk-cli-setup)
- [OPTIONAL] Point CNAME at your EB URL (i.e <span>bort-env.eba-2kg3gsq2.us-east-2.elasticbeanstalk.com</span>)

## Usage

1. Pull down your enviroment
```shell
# Connect
eb init
# Pull down source
eb labs download
```
2. Clone this repo

3. Modify CERTBOT_NAME, CERTBOT_EMAIL, and CERTBOT_DOMAINS in the bash script

4. Copy both **ebextensions** and **platform** folders into your environment

5. Deploy your app
```
# Packages into zip and uploads
eb deploy
```

## Screenshots
![Variables](https://github.com/HausCloud/AWS-ElasticBeanstalk-SSL/blob/master/screenshots/certbot.png)
![Instructions](https://github.com/HausCloud/AWS-ElasticBeanstalk-SSL/blob/master/screenshots/instructions.png)
![Result](https://github.com/HausCloud/AWS-ElasticBeanstalk-SSL/blob/master/screenshots/secure.png)

## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Tested platforms

- Python 3.7 running on 64bit Amazon Linux 2/3.1.3
- Node.js 12 running on 64bit Amazon Linux 2/5.2.3
- Ruby 2.7 running on 64bit Amazon Linux 2/3.2.0
- Docker running on 64bit Amazon Linux 2/3.2.2
- Corretto 11 running on 64bit Amazon Linux 2/3.1.4

## License

This project is licensed under the MIT License - see the [LICENSE.md](https://github.com/HausCloud/AWS-ElasticBeanstalk-SSL/blob/master/LICENSE) file for details

## Acknowledgments

- [russau](https://github.com/russau) suggesting [platform hooks](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/platforms-linux-extend.html)
- [tony-gutierrez](https://github.com/tony-gutierrez) starting this [gist](https://gist.github.com/tony-gutierrez/198988c34e020af0192bab543d35a62a)
