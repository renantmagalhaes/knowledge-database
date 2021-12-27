# AWS pipeline

- Fully Managed
- Built for Scale
- Integrate with AWS services
- Secure

# AWS CodeCommit

AWS CodeCommit is a secure, highly scalable, managed source control service that hosts private Git repositories. It makes it easy for teams to securely collaborate on code with contributions encrypted in transit and at rest. CodeCommit eliminates the need for you to manage your own source control system or worry about scaling its infrastructure. You can use CodeCommit to store anything from code to binaries. It supports the standard functionality of Git, so it works seamlessly with your existing Git-based tools.

- AWS Git Service

Developer -> **AWS CodeCommit** -> Build Image -> Testing -> Deploy

# AWS CodeBuild

AWS CodeBuild is a fully managed continuous integration service that compiles source code, runs tests, and produces software packages that are ready to deploy. With CodeBuild, you don’t need to provision, manage, and scale your own build servers. CodeBuild scales continuously and processes multiple builds concurrently, so your builds are not left waiting in a queue. You can get started quickly by using prepackaged build environments, or you can create custom build environments that use your own build tools. With CodeBuild, you are charged by the minute for the compute resources you use.

- AWS CI service
- Similar to jenkins
- Scales automatically
  
Developer -> Code Repo -> **AWS CodeBuild** -> Testing -> Deploy


# AWS CodePipeline

AWS CodePipeline is a fully managed continuous delivery service that helps you automate your release pipelines for fast and reliable application and infrastructure updates. CodePipeline automates the build, test, and deploy phases of your release process every time there is a code change, based on the release model you define. This enables you to rapidly and reliably deliver features and updates. You can easily integrate AWS CodePipeline with third-party services such as GitHub or with your own custom plugin.

- Build, test and deploy phase
- Orchestrate all the components of CodeCommit and CodeBuild
- Rapid Delivery
- Fully Managed
- Easy integration with AWS and Third Party Tools


# Demo 1 - CodeCommit + CodeBuild

```Developer -> CodeCommit -> AWS CodeCommit -> AWS ECR -> AWS EKS```

## IAM and Setup

1. Create kubectl role
    1. Go to IAM
    2. Roles
    3. Create Role
    4. Another AWS account
    5. Put your account ID (aws sts get-caller-identity)
    6. Create Policy
    7. Select Json
    8. Copy content from kubectl_role_policy.json
    9. set a name for the policy (kubectlrolepolicy)
    10. Create Policy
    11. Select the policy you just created
    12. Give the Role Name: EKSKubectl 
    13. Create Role
    14. Copy Role ARN (arn:aws:iam::111111111111:role/EKSKubectl)

2. Create IAM roles via cloudformation
   1. Go to Cloudformation
   2. Create Stack (With New resources)
   3. Create template in Designer
   4. Click Template (bottom of the screen)
   5. Paste content from IAM-roles-cloudformation.yaml into new.template
   6. Click the Cloud with a arrow up in the top left corner to save the stack
   7. Next
   8. Add Stack Name (ekscicdiamstack)
   9. Edit KubectlRoleName with the RoleName in Step1 (EKSKubectl)
   10. Create Stack (next / next / I acknowledge that AWS CloudFormation might create IAM resources.)
   11. Go to Resources
   12. Copy CodeBuildServiceRole and CodePipelineServiceRole
       1.  ekscicdiamstack-CodeBuildServiceRole-YUCQXI16WBXO
       2.  ekscicdiamstack-CodePipelineServiceRole-V9KJVHS5HEYT

3. Edit configmap
   1. kubectl edit -n kube-system configmap/aws-auth

```
      - groups:
        - system:masters
        rolearn: arn:aws:iam::111111111111:role/EKSKubectl
        username: build
```

# Set pipeline


# CodeCommit

1. Create Repo
2. Upload files

# ECR

1. Create ECR Repo
   1. 111111111111.dkr.ecr.eu-central-1.amazonaws.com/aws-pipeline
# CodePipeline

1. Create pipeline
2. Name: eks-workshop-pipeline
3. Existing service role
   1. seclect role created in step 12.2 (ekscicdiamstack-CodePipelineServiceRole-V9KJVHS5HEYT)
4. Source
   1. AWS CodeCommit
   2. Fill the information with the aws-pipeline repo
5. Build Provider -> AWS CodeBuild
   1. Create Project
      1. Set Name
      2. Select Operating System (ubuntu)
      3. Runtime -> Standard
      4. Image -> Latest available
      5. Enable Privileged
      6. Service role   
         1. Existing service role step 12.1 (ekscicdiamstack-CodeBuildServiceRole-YUCQXI16WBXO)
      7. Environment variables
   
```
REPOSITORY_URI=111111111111.dkr.ecr.eu-west-1.amazonaws.com/aws-pipeline-repo
REPOSITORY_NAME=aws-pipeline
REPOSITORY_BRANCH=main
EKS_CLUSTER_NAME=EKS-Workshop
EKS_KUBECTL_ROLE_ARN=arn:aws:iam::111111111111:role/EKSKubectl
```

6. Single build
7. Skip deploy stage
8. Create pipeline

# Demo 2 - CodeCommit + CodeBuild + Lambda

https://github.com/aws-samples/aws-kube-codesuite