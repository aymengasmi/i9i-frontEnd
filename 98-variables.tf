variable "bucket" {
  description = "Nom du bucket, ce nom doit etre unique au niveau mondial (Si le nom n'est pas fourni il sera automatiquement généré via les tags fournies)."
  type        = string
  default     = "bckt-agasmi-front"
}

variable "aws_region" {
  description = "Région dans laquelle le bucket sera créé."
  type        = string
  default     = "eu-west-3"
}

variable "versioning" {
  description = "Boolean d'activation du versionning au niveau du bucket."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Mapping des tags a assigner aux ressources, les régles de nomenclature sont présentes ici "
  type = object({
    Environment = string
    Owner       = string
    Description = string
  })
  default = {
    Environment = "dev"
    Owner       = "aymengasmi"
    Description = ""
  }

}


variable "name" {
  description = "full name"
  type        = string
  default     = "agasmi-test"

}

#variable "certificate_arn" {
#  description = "ARN of the certificate"
#  type        = string
#}

#variable "dns" {
#  description = "DNS record of the application"
#  type        = list(string)
#}
