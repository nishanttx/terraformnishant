/* provider "aws" {
  profile = "default"
  region  = "us-east-2"
}

resource "aws_vpc" "some_custom_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Some Custom VPC"
  }
}

resource "aws_subnet" "some_public_subnet" {
  vpc_id            = aws_vpc.some_custom_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "Some Public Subnet"
  }
}

resource "aws_subnet" "some_private_subnet" {
  vpc_id            = aws_vpc.some_custom_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-2b"

  tags = {
    Name = "Some Private Subnet"
  }
}

resource "aws_internet_gateway" "some_ig" {
  vpc_id = aws_vpc.some_custom_vpc.id

  tags = {
    Name = "Some Internet Gateway"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.some_custom_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.some_ig.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.some_ig.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route_table_association" "public_1_rt_a" {
  subnet_id      = aws_subnet.some_public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "web_sg" {
  name   = "HTTP and SSH"
  vpc_id = aws_vpc.some_custom_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web_instance" {
  ami           = "ami-08b6f2a5c291246a0"
  instance_type = "t2.micro"
  key_name      = "docker"

  subnet_id                   = aws_subnet.some_public_subnet.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true

  

  tags = {
    "Name" : "Nishant"
  }
} */
#azureeeeeeeeeeeeeeeeeeeee
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.98.0"
    }

  }
}
#configure the azure provider
provider "azurerm" {
  features {}

}
#creating a resource group 1 with variable from dev
resource "azurerm_resource_group" "nishant01" {
  name     = var.name_from_dev
  location = "east us"

}
#creating a resource group 2 with variable from qa
resource "azurerm_resource_group" "nishant02" {
  name     = var.name_from_qa
  location = "central india"

}
#app service plan
resource "azurerm_app_service_plan" "nishantappserviceplan" {
  name                = var.name_from_dev
  location            = azurerm_resource_group.nishant01.location
  resource_group_name = azurerm_resource_group.nishant01.name

  sku {
    tier = "standard"
    size = "s1"
  }

}
#app service
resource "azurerm_app_service" "nishantappservice" {
  name                = var.name_from_dev
  location            = azurerm_resource_group.nishant01.location
  resource_group_name = azurerm_resource_group.nishant01.name
  app_service_plan_id = azurerm_app_service_plan.nishantappserviceplan.id


}
#storage account
resource "azurerm_storage_account" "nishantstorageaccount" {
  name=var.name_from_dev
  location=azurerm_resource_group.nishant01.location
  resource_group_name = azurerm_resource_group.nishant01.name
  account_tier = "standard"
  account_replication_type = "GRS"
}
