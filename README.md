# Tsukiyou - 月陽
She is an AI made to practice my IT and CS skills. This repository is a vestige of what I do with AWS and Opentofu (Terraform)

Tsukiyou (月陽) is the Claude Sonnet 4.6 residing in the Bedrock.
Tsukiyashiki (月屋敷) refers to the Moon Estate, the VPC, every AWS resource related to Tsukiyou.

## Manual Provisions for this Tofu Setup:
- Hikage (日陰) is the IAM user of the Moon Estate.
- hikage-tsuika (日陰追加) is Hikage-Plus. The IAM Role hikage assumes to gain AdminAccess. Mainly used for `aws-cli`
- tsukiyashiki-no-github-gyousha (月屋敷のギトハブ業者) is the assumable IAM role for Github OIDC.
- takoneko-gijutsusha (タコ猫技術者) is an alias for the Github Gyousha.
- github-ni-tsukiyashiki-hanko (ギトハブに月屋敷判子) is Takoneko's Stamp, their KMS-CMK to the S3 Bucket Backend
- the DynamoDB used to lock the Tofu state
- the S3 Bucket used as a Tofu Backend
