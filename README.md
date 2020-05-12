# AWS-ElasticBeanstalk-SSL

Add SSL for **single** instance AWS Elastic Beanstalk Services.

### Prerequisites

- Sample application deployed on AWS Elastic Beanstalk
- [EB CLI](https://github.com/aws/aws-elastic-beanstalk-cli-setup)
- Enviromental variables set using either the EBI CLI or AWS EB management board
  - CERTBOT_CERT_NAME (Name of your certificate)
  - CERTBOT_EMAIL (E-mail to attach to certificate)
  - CERTBOT_DOMAIN_LIST (Comma separated domain list)
- [Optional] CNAME to your EB environment URL

## Usage

- Clone your environment using eb init and eb labs download
- Clone this repo
- Choose a script in ./platform/hooks/postdeploy and delete the other
- Copy both .ebextensions and .platform into your environment
- Run eb deploy

## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Tested platforms

- Python 3.7 running on 64bit Amazon Linux 2/3.0.1

## License

This project is licensed under the MIT License - see the [LICENSE.md](https://github.com/HausCloud/AWS-ElasticBeanstalk-SSL/blob/master/LICENSE) file for details

## Acknowledgments

- [russau](https://github.com/russau): platform hooks [documentation](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/platforms-linux-extend.html)
- Inspiration: Lack of documentation or solutions regarding easy SSL setup for EB environments
- Note: In load balanced enviroments, please use eb labs 