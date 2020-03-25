println "Bare Environment\n" + "env".execute().text

println "buildNumber: " + currentBuild.getNumber()
println "projectName: " + currentBuild.getProjectName()
println "buildVariables: " + currentBuild.getBuildVariables() // When parameterized
println "previousBuiltBuild: " + currentBuild.getPreviousBuiltBuild().getNumber()
println "previousCompletedBuild: " + currentBuild.getPreviousCompletedBuild().getNumber()
println "previousNotFailedBuild: " + currentBuild.getPreviousNotFailedBuild().getNumber()
println "previousFailedBuild: " + currentBuild.getPreviousFailedBuild().getNumber()
println "previousSuccessfulBuild: " + currentBuild.getPreviousSuccessfulBuild().getNumber()

// object.each { println "$it.key = $it.value" }
currentBuild.class.methods.each {
  println "currentBuild methods: ${it.name}"
}

// //all job name
// jenkins.model.Jenkins.instance.items.each {
//   println "Job: ${it.name}"
// }

// //method list of Jenkins instance
// jenkins.model.Jenkins.instance.class.methods.each {
//   println "Jenkins method: ${it.name}"
// }

// //method list of Maven2job(hudson.maven.MavenModuleSet)
// hudson.maven.MavenModuleSet.class.methods.each {
//   println "Job method Maven: ${it.name}"
// }

// //method list of Free Style Project(hudson.model.FreeStyleProject)
// hudson.model.FreeStyleProject.class.methods.each {
//   println "Job method FreeStyle: ${it.name}"
// }

// // //workspace path of specified job - NOT WORKING
// // println(jenkins.model.Jenkins.instance.getJob(currentBuild.getProjectName()).getWorkspace())