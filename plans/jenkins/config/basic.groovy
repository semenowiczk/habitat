#!groovy
import hudson.security.*
import jenkins.model.*
import jenkins.install.InstallState
import jenkins.security.s2m.AdminWhitelistRule

def instance = Jenkins.getInstance()
def hudsonRealm = new HudsonPrivateSecurityRealm(false)
def users = hudsonRealm.getAllUsers()
users_s = users.collect { it.toString() }

// Create the admin user account if it doesn't already exist.
if ("{{cfg.jenkins.jenkins_admin_username}}" in users_s) {
    println "Admin user already exists - updating password"

    def user = hudson.model.User.get('{{cfg.jenkins.jenkins_admin_username}}');
    def password = hudson.security.HudsonPrivateSecurityRealm.Details.fromPlainPassword('{{cfg.jenkins.jenkins_admin_password}}')
    user.addProperty(password)
    user.save()
}
else {
    println "--> creating local admin user"

    hudsonRealm.createAccount('{{cfg.jenkins.jenkins_admin_username}}', '{{cfg.jenkins.jenkins_admin_password}}')
    instance.setSecurityRealm(hudsonRealm)

    def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
    strategy.setAllowAnonymousRead(false)
    instance.setAuthorizationStrategy(strategy)
    instance.save()
}

if (!instance.installState.isSetupComplete()) {
    println '--> Setting Number of Executors'
    Jenkins.instance.setNumExecutors({{cfg.jenkins.NumExecutors}})
    println '--> Neutering SetupWizard'
    InstallState.INITIAL_SETUP_COMPLETED.initializeState()
    Jenkins.instance.injector.getInstance(AdminWhitelistRule.class).setMasterKillSwitch(false);
    def jenkinsLocationConfiguration = JenkinsLocationConfiguration.get()
    jenkinsLocationConfiguration.setAdminAddress("{{cfg.jenkins.admin_email}}")
    jenkinsLocationConfiguration.setUrl("{{cfg.jenkins.url}}:{{cfg.jenkins.http.port}}")
    println "--> setting agent port for jnlp"
    instance.save()
    Jenkins.instance.doSafeRestart(null);
}
