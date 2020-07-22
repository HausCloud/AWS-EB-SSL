# AWS-EB-SSL

Setup secure **single** instance AWS Elastic Beanstalk environments easily

## Prerequisites

- Sample application deployed on AWS Elastic Beanstalk
  - Only nginx is supported since AWS seems to be shifting towards that configuration (https://docs.aws.amazon.com/elasticbeanstalk/latest/platforms/platforms-supported.html)
- [EB CLI](https://github.com/aws/aws-elastic-beanstalk-cli-setup)
- Enviromental variables set using either the EBI CLI or AWS EB management board
  - CERTBOT_CERT_NAME (Name of your certificate)
  - CERTBOT_EMAIL (E-mail to attach to certificate)
  - CERTBOT_DOMAIN_LIST (Comma separated domain list)
- [OPTIONAL] If you have a domain name already, add to CERTBOT_DOMAIN_LIST and point a CNAME to your EB url.

## Usage

- Clone your environment using EB CLI
    - `eb init && eb labs download`
- Clone this repository
- Copy .ebextensions and .platform into your environment
- Deploy
    - `eb deploy`

## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Tested platforms

- Python 3.7 running on 64bit Amazon Linux 2/3.0.1
- Node.js 12 running 64bit Amazon Linux 2/5.0.1
- Ruby 2.7 running on 64bit Amazon Linux 2/3.0.3

## License

This project is licensed under the MIT License - see the [LICENSE.md](https://github.com/HausCloud/AWS-ElasticBeanstalk-SSL/blob/master/LICENSE) file for details

## Acknowledgments

- [russau](https://github.com/russau): platform hooks [documentation](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/platforms-linux-extend.html)
- [tony-gutierrez]: posted a yaml file that addressed the same issue [gist](https://gist.github.com/tony-gutierrez/198988c34e020af0192bab543d35a62a)
