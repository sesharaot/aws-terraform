pipeline {

    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')

    }


     environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

   agent  any
    stages {
        stage('checkout') {
            steps {
                 script{
                        dir("terraform")
                        {
                            git "https://github.com/sesharaot/aws-terraform.git"
                        }
                    }
                }
            }

        stage('Plan') {
            steps {
                sh 'pwd;cd terraform ; terraform init -input=false'
                sh "pwd;cd terraform ; terraform plan -input=false -out tfplan "
                sh 'pwd;cd terraform ; terraform show -no-color tfplan > tfplan.txt'
            }
        }
        stage('Approval') {
           when {
               not {
                   equals expected: true, actual: params.autoApprove
               }
           }

           steps {
               script {
                    def plan = readFile 'terraform/tfplan.txt'
                    input message: "Do you want to apply the plan?",
                    parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
               }
           }
       }

        stage('Apply') {
            steps {
              script {
                sh "pwd;cd terraform ; terraform apply -input=false tfplan"
                sh "pwd;cd terraform ; `terraform output | sed 's/ //g' > info.txt`"

                def props = readProperties file: "${WORKSPACE}/terraform/info.txt"
                public_ip = props['public_ip']
                name = props['name']
                echo "public_ip = ${public_ip}"
                echo "name = ${name}"
                
                sh "cd /var/lib/jenkins/chef-repo; knife bootstrap ${public_ip} -p 22 -x centos -i master.pem --sudo -N ${name} --policy-name policyfile-lamp --policy-group test --no-host-key-verify"
            }
        }
    }
}
  }
