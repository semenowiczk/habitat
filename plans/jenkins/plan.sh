pkg_name=jenkins
pkg_origin=kris
pkg_version="2.150.2"
pkg_maintainer=""
pkg_license=('The GNU General Public Licence, Version 2')
pkg_description="Jenkins is an open source automation server written in Java. Jenkins helps to automate the non-human part of the software development process, with continuous integration and facilitating technical aspects of continuous delivery."
pkg_upstream_url="https://jenkins.io/"
pkg_source=http://repo.jenkins-ci.org/public/org/jenkins-ci/main/${pkg_name}/${pkg_version}/${pkg_name}-${pkg_version}.war
pkg_shasum="d8ed5a7033be57aa9a84a5342b355ef9f2ba6cdb490db042a6d03efb23ca1e83"
pkg_plugins_source=https://updates.jenkins-ci.org/download/plugins
pkg_filename=${pkg_name}-${pkg_version}.war
pkg_deps=(
    # Required packages
    core/jre8
    # Additional packages
    core/curl
    core/git
    core/aws-cli
    core/terraform
)
pkg_exports=(
  [port]=jenkins.http.port
)
pkg_exposes=(port)
pkg_svc_user="root"
pkg_plugins=(
    # Additional plugins
    ace-editor:1.1
    ansicolor:0.6.1
    antisamy-markup-formatter:1.5
    apache-httpcomponents-client-4-api:4.5.5-3.0
    authentication-tokens:1.3
    aws-credentials:1.24
    aws-java-sdk:1.11.457
    blueocean-autofavorite:1.2.2
    blueocean-bitbucket-pipeline:1.10.1
    blueocean-commons:1.10.1
    blueocean-config:1.10.1
    blueocean-core-js:1.10.1
    blueocean-dashboard:1.10.1
    blueocean-display-url:2.2.0
    blueocean-events:1.10.1
    blueocean-git-pipeline:1.10.1
    blueocean-github-pipeline:1.10.1
    blueocean-i18n:1.10.1
    blueocean-jira:1.10.1
    blueocean-jwt:1.10.1
    blueocean-personalization:1.10.1
    blueocean-pipeline-api-impl:1.10.1
    blueocean-pipeline-editor:1.10.1
    blueocean-pipeline-scm-api:1.10.1
    blueocean-rest-impl:1.10.1
    blueocean-rest:1.10.1
    blueocean-web:1.10.1
    blueocean:1.10.1
    bouncycastle-api:2.17
    branch-api:2.1.2
    cloudbees-bitbucket-branch-source:2.4.0
    cloudbees-folder:6.7
    command-launcher:1.3
    copyartifact:1.41
    credentials-binding:1.17
    credentials:2.1.18
    display-url-api:2.3.0
    docker-commons:1.13
    docker-workflow:1.17
    durable-task:1.28
    ec2:1.42
    envinject-api:1.5
    extended-choice-parameter:0.76
    external-monitor-job:1.7
    favorite:2.3.2
    git-client:2.7.6
    git-server:1.7
    git:3.9.1
    github-api:1.95
    github-branch-source:2.4.2
    github:1.29.3
    gitlab-plugin:1.5.11
    greenballs:1.15
    handlebars:1.1.1
    handy-uri-templates-2-api:2.1.6-1.0
    hashicorp-vault-pipeline:1.2
    hashicorp-vault-plugin:2.2.0
    htmlpublisher:1.18
    jackson2-api:2.9.8
    javadoc:1.4
    jdk-tool:1.2
    jenkins-design-language:1.10.1
    jira:3.0.5
    jobConfigHistory:2.19
    jquery-detached:1.2.1
    jquery:1.12.4-0
    jsch:0.1.55
    junit:1.26.1
    ldap:1.20
    lockable-resources:2.4
    mailer:1.23
    matrix-auth:2.3
    matrix-project:1.13
    maven-plugin:3.2
    mercurial:2.4
    momentjs:1.1.1
    node-iterator-api:1.5.0
    pam-auth:1.4
    pipeline-build-step:2.7
    pipeline-graph-analysis:1.9
    pipeline-input-step:2.9
    pipeline-milestone-step:1.3.1
    pipeline-model-api:1.3.4.1
    pipeline-model-declarative-agent:1.1.1
    pipeline-model-definition:1.3.4.1
    pipeline-model-extensions:1.3.4.1
    pipeline-rest-api:2.10
    pipeline-stage-step:2.3
    pipeline-stage-tags-metadata:1.3.4.1
    pipeline-stage-view:2.10
    plain-credentials:1.5
    pubsub-light:1.12
    rebuild:1.29
    resource-disposer:0.12
    scm-api:2.3.0
    script-security:1.50
    sse-gateway:1.17
    ssh-agent:1.17
    ssh-credentials:1.14
    structs:1.17
    token-macro:2.5
    uno-choice:2.1
    variant:1.1
    windows-slaves:1.4
    workflow-aggregator:2.6
    workflow-api:2.33
    workflow-basic-steps:2.14
    workflow-cps-global-lib:2.12
    workflow-cps:2.62
    workflow-durable-task-step:2.28
    workflow-job:2.31
    workflow-multibranch:2.20
    workflow-scm-step:2.7
    workflow-step-api:2.18
    workflow-support:3.1
    ws-cleanup:0.37
)

do_download() {
  build_line "Downloading pkg"
  wget -O $HAB_CACHE_SRC_PATH/$pkg_filename $pkg_source
  build_line "Downloading plugins"
  mkdir -p $HAB_CACHE_SRC_PATH/plugins
  for plugin in "${pkg_plugins[@]}" ; do
    wget -O $HAB_CACHE_SRC_PATH/plugins/"${plugin%%:*}".hpi $pkg_plugins_source/"${plugin%%:*}"/"${plugin##*:}"/"${plugin%%:*}".hpi
  done
}

do_verify() {
    return 0
}

do_unpack() {
    return 0
}

do_build() {
    return 0
}

do_install() {
  build_line "Copying war file"
  cp $HAB_CACHE_SRC_PATH/$pkg_filename $pkg_prefix
  mv -f $pkg_prefix/$pkg_filename $pkg_prefix/jenkins.war
  build_line "Copying plugins directory"
  mv -f $HAB_CACHE_SRC_PATH/plugins $pkg_prefix/
}
