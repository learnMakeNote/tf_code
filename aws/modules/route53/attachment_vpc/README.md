# route53 模块

1. get created vpc id
   - accross tags to get vpcid - tagname: 
     - `key: aws:cloudformation:stack-name  value: NetworkStack`
2. attachment host zone and vpc 
3. attachment route53 resolver rules and vpc 
4. attachment route53 resolver firewall rule group and vpc




## deployment

1. deploy content
```
../../terraform.exe init
../../terraform.exe plan -var-file="test.tfvars"
../../terraform.exe apply -var-file="test.tfvars"
```

2. delete content
../../terraform.exe destroy --var-file="test.tfvars"