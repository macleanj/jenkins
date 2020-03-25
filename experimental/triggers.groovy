pipeline {

// ******************************************************
  // ********************** Triggers **********************
  // Not working on multibranch
  triggers {
    pollSCM( (BRANCH_NAME == 'master' || BRANCH_NAME == 'develop') ? '* * * * *' : '') /* default: poll once a minute */
  }
  // triggers {
  //   pollSCM('* * * * *') /* default: poll once a minute */
  // }
  // // ********************** Triggers **********************
  // ******************************************************
}