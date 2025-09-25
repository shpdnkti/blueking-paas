variable "STACK_BUILDER_IMAGE_NAME" {
  default = "mirrors.tencent.com/bkpaas/build-heroku-noble"
}

variable "STACK_BUILDER_TAG" {
  default = "latest"
}

variable "STACK_RUNNER_IMAGE_NAME" {
  default = "mirrors.tencent.com/bkpaas/run-heroku-noble"
}

variable "STACK_RUNNER_TAG" {
  default = "latest"
}

variable "APT_SOURCES" {
  default = <<EOF
  deb http://mirrors.cloud.tencent.com/ubuntu/ noble main restricted universe multiverse
  deb http://mirrors.cloud.tencent.com/ubuntu/ noble-security main restricted universe multiverse
  deb http://mirrors.cloud.tencent.com/ubuntu/ noble-updates main restricted universe multiverse
  EOF
}

variable "BASE_PACKAGES" {
  default = <<EOF
  openssl-devel glibc-devel mysql-devel git
  EOF
}

variable "BASE_IMAGE" {
  default = "tencentos/tencentos4-minimal"
}

variable "BASE_TAG" {
  default = "latest"
}

target "heroku-build-noble" {
  dockerfile = "build.Dockerfile"
  args = {
    TAG = BASE_TAG
    IMAGE = BASE_IMAGE
    STACK_ID = "heroku-24"
    packages = "${BASE_PACKAGES}"
  }
  tags = ["${STACK_BUILDER_IMAGE_NAME}:${STACK_BUILDER_TAG}"]
  platforms = ["linux"]
}

target "heroku-run-noble" {
  dockerfile = "run.Dockerfile"
  args = {
    TAG = BASE_TAG
    IMAGE = BASE_IMAGE
    STACK_ID = "heroku-24"
    packages = "${BASE_PACKAGES}"
  }
  tags = ["${STACK_RUNNER_IMAGE_NAME}:${STACK_RUNNER_TAG}"]
  platforms = ["linux"]
}
