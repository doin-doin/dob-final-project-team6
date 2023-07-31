resource "aws_resourcegroups_group" "Prod" {
  name        = "Prod"
  description = "Prod Resource Group"

  resource_query {
    query = jsonencode({
      "ResourceTypeFilters": ["AWS::AllSupported"],
      "TagFilters": [
        {
          "Key":   "Env",
          "Values": ["Prod"]
        }
      ]
    })
  }
}
