# Circle CI setup walkthrough

## 1 - Homepage
Click on Sign Up.

![Circle CI Homepage](https://github.com/SBats/tns-circleci-example/blob/master/circle-ci-setup/001-circleci-home.png?raw=true)

## 2 - Sign-up page
Use either your github or git bucket account to sign-up.

![Circle CI Sign-up page](https://github.com/SBats/tns-circleci-example/blob/master/circle-ci-setup/002-circleci-signup.png?raw=true)

## 3 - Dashboard
Welcome to your new dashboard, click on add a project to start.

![Circle CI Dashboard](https://github.com/SBats/tns-circleci-example/blob/master/circle-ci-setup/003-circleci-board.png?raw=true)

## 4 - Add a project
Select the project you want to plug with circle CI in your list (stay on a Linux machine for now).

![Circle CI Add a project](https://github.com/SBats/tns-circleci-example/blob/master/circle-ci-setup/004-circleci-add-project.png?raw=true)

## 5 - Configure a project
In this new page, switch the machine to MacOS and select `Other` for Language.

![Circle CI Configure a project](https://github.com/SBats/tns-circleci-example/blob/master/circle-ci-setup/005-circleci-configure-project.png?raw=true)

## 6 - Build a project
Configure your `.circleci/config.yml` then click on `Start Building`.

![Circle CI Build a project](https://github.com/SBats/tns-circleci-example/blob/master/circle-ci-setup/006-circleci-build-project.png?raw=true)

## 7 - Wrong config
If your config is wrong, you'll see a `Needs Setup` text on your current build. Click on it to see details.

![Circle CI Wrong config](https://github.com/SBats/tns-circleci-example/blob/master/circle-ci-setup/007-circleci-wrong-config.png?raw=true)

## 8 - Wrong config details
You have a bit of a detail in the yellow alert panel to guide you through debugging your config file.
(In the screenshot, my job build used in my main workflow was written as an object with child values but there was none. I needed to remove the `:` at the end of the line).

![Circle CI Wrong config details](https://github.com/SBats/tns-circleci-example/blob/master/circle-ci-setup/008-circleci-wrong-config-details.png?raw=true)

## 9 - Activate plan
Once your config file is okay, if you haven't activated your plan yet, you'll havea yellow alert panel telling you to do it. Click on it to be redirected to the plan page and enable your free trial to begin with.

![Circle CI Activate plan](https://github.com/SBats/tns-circleci-example/blob/master/circle-ci-setup/009-circleci-plan-not-activated.png?raw=true)

## 10 - Workflow fail
If a workflow fail, you can go in the workflow section of your board and see which job did fail. Click on the job to have the logs and details of the job session.

![Circle CI Workflow fail](https://github.com/SBats/tns-circleci-example/blob/master/circle-ci-setup/010-circleci-workflow-fail.png?raw=true)

## 11 - Workflow success
If your workflow is a success all will be green! You can still click on a job to see the details, and eventually improve things like caching form what you learn.

![Circle CI Workflow success](https://github.com/SBats/tns-circleci-example/blob/master/circle-ci-setup/011-circleci-workflow-success.png?raw=true)
