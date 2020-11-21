#jenkins

this docker contains of a jenkins and a plugins manager
https://github.com/jenkinsci/plugin-installation-manager-tool

get a list of plugins from a running jenkins

Jenkins.instance.pluginManager.plugins.each{
  plugin -> 
    println ("${plugin.getDisplayName()} (${plugin.getShortName()}): ${plugin.getVersion()}")
}

#check
curl --unix-socket /var/run/docker.sock http:/v1.24/containers/json

println "curl --unix-socket /var/run/docker.sock http:/v1.24/containers/json".execute().text
