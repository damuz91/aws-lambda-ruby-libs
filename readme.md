# AWS Lambda Ruby Libs
This projects contains a set of commands that executes a docker container build based on AWS lambci ruby 2.7 image and then creates an AWS layer with mentioned dependencies.

For each type of dependency you got to test which are the libraries and where are them, usually running a ruby project on a AWS lambci image container tells which libraries are missing, so you can just copy them from `/usr/lib64` folder and paste in the folder that is going to be zipped and sent to be created as a layer.

# How to use
1. Install aws cli in your system and log in, make sure you have set your region, aws secret and key
2. Create a bucket (Use a unique name along all AWS 🤪) were we will store temporary our layer, we can delete or emtpy it after. (Alternatively you can upload directly the zip instead of using S3 but it has a limit of 50MB)
3. Modify Dockerfile to include your dependencies libraries, in my case i use postgres, so i include them.
4. Run `make bucket=temporal-layer-bucket all`. Replace `temporal-layer-bucket` with your unique bucket's name.
5. Check your new layer in AWS console and update your lambda function to use it