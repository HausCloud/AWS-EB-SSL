# AWS-EB-SSL
#### Easy secure (single instance) Elastic Beanstalk apps

## Prerequisites

- Deployed sample application
- [**Elastic Beanstalk Command Line Interface**](https://github.com/aws/aws-elastic-beanstalk-cli-setup)

## Usage

1. Connect and pull down your application
```shell
eb init
eb labs download
```
2. Clone this repository
3. Modify CERTBOT_NAME, CERTBOT_EMAIL, and CERTBOT_DOMAINS in the bash script
4. Copy both **ebextensions** and **platform** folders into your environment
5. Deploy your app
```
# Packages into zip and uploads
eb deploy
```

## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Tested platforms

- Python 3.8 running on 64bit Amazon Linux 2/3.2.1
- Node.js 14 running on 64bit Amazon Linux 2/5.3.1

## License

This project is licensed under the MIT License - see the [LICENSE.md](https://github.com/HausCloud/AWS-ElasticBeanstalk-SSL/blob/master/LICENSE) file for details

## Acknowledgments

- [russau](https://github.com/russau) for suggesting [platform hooks](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/platforms-linux-extend.html)
- [tony-gutierrez](https://github.com/tony-gutierrez) for starting this [gist](https://gist.github.com/tony-gutierrez/198988c34e020af0192bab543d35a62a)