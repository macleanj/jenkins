// jenkins-library needs to be loaded as cicd
@Library('cicd@develop') _cicd
// If this job should also run when the library got changes, set changelog=true
// @Library( value = "cicd@master", changelog = false ) _cicd

_testConditionalPipline(currentBuild.getNumber())