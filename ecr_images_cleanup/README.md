### NOTICE:
 * This script don't uses the best practicing(far from it), but i believe that can help someone out there. Read it with careful and before run this script for real you can comment line 46 and see what effectively it will delete.
 * AWS ECR api is REALLY slow, this script may take several minutes to hours to run. It depends by the amount of tags and images you have.


### ECR CLEANUP
Script to cleanup AWS ECR repository.

Nowadays the aws policy lifecycle is very limited to my use: 
* Can ONLY use tags prefixes
* Cannot use wildcard
* And so on
