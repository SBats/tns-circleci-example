# Integrate NS with CircleCI

Preface: CircleCI is a tool allowing automation and cloud building. It's not the only one available but we were working with it for our web stack.
Like Travis, both have free plans for open-source projects.
MacOS machines start with a 2 weeks trial but you can access the smaller plan for free if your code is in a public Github or Bitbucket repository.

Considerations regarding CI:
Even though you use distant machines and don't really care about the time it will take to build/test/deploy compared to doing this on your local machine, you need to keep in mind longer time will translate to more expensive plans and longer wait for the dev team to have feedbacks on potential issues.
That's why it's important to consider proper caching strategies.
You want to balance between keeping in cache things and being sure to use fresh dependencies/codebase.

CircleCI flow:
It uses `jobs` and `workflows`. Workflows will be high level tasks which use `jobs` in a certain order. Jobs can be concurrent if they don't rely on each other, and you can re-run failed jobs independently, which gives a lot of flexibility on how you want to deal with errors, testing and deploying. Each will be a different "machine"/environment instance and can have it's own coniguration.

![CircleCI flow scheme](https://circleci.com/blog/media/Diagram-v3--Default.png)

Caching with CircleCI:
CircleCI offer 3 types of cache:
- Wrokspaces: share data bewteen jobs
- Cache: share data between the same job in multiple workflows
- Artifacts: persist data after a workflow is done and gone

Steps:
- Having a project which build and run properly (preferably with some tests)
- If you want to deploy with the CI, you'll need to have access to your keysstores and provisioning profiles for signing.

- Setting up project on CircleCI (V2)
  * Need to chose Linux platform and chang to MacOS afterward (It must search for some specific ios and Mac files which we don't version)
  * Create a `.circleci` folder at the rooth of the project
  * Inside the `.circleci` folder, create a file `config.yml`
  * Default config given is:
  ``` yml
    version: 2
    jobs:
      build:
        docker:
          - image: debian:stretch
        steps:
          - checkout
          - run:
              name: Greeting
              command: echo Hello, world.
          - run:
              name: Print the Current Time
              command: date

  ```
  As for now, the project isn't properly configured for Nativescript, but if you try to build CircleCI should simply echo the two statements above

Here are the steps we'll have in our files:

Workflow Init
- Fetch CocoaPods repository (Custom repo of CircleCI for speed)
- Setup system dependencies
    Update Brew
    Install android-sdk (brew)
    Install android tools
    Install Nativescript
    Disable tns cli reports
- Restore CircleCI NPM Cache
- Install node dependencies
- Save CircleCI NPM cache
- Rebuild Node SASS bindings (due to node update through brew)
- Pre-launch iOS Simulator (prevent tests timeouts)
- Precompile SASS Files (To check if deprecated)
- Prepare ios
- Prepare Android
- Build ipa for iOS and apk for Android (signed or not depending on branch)

Workflow Unit tests
- Run unit tests

Workflow e2e tests
- Run e2e tests

Workflow deploy QA
- Deploy QA (DIAWI)

Workflow deploy production
- Deploy Prod

- Configure the project
We now need to complete the `config.yml` file with what needed (help in [this doc](https://circleci.com/docs/2.0/testing-ios/))
Note that those machines were deigned for Native Apps and not exactly for hybrid ones, so we need a bit more of dependencies installation.
  * XCODE: CircleCI offer various machine configured with XCode fron `8.3.3` up to the last version
  * Environment variables: ANDROID_HOME: "/usr/local/share/android-sdk"
  * Use cache efficiently to prevent redownload of same dependencies through differents runs
  * CircleCI allow to persist folders and their content between jobs. For example build once and reuse the API/APK through tests and deploy process.

- Debug config issues
Use the official [local CLI](https://circleci.com/docs/2.0/local-cli/) tool provided by CircleCI

- Add secret env var to the CI machine:
  Examples:
  * `KEYSTORE_PWD`
  * `KEYSTORE_ALIAS`
  * `KEYSTORE_ALIAS_PWD`
  * `QA_EMAIL`
  * `QA_PASSWORD`


# FASTLANE and automation around mobile apps

Most of the standard issues regarding mobile-apps ecosystem don't come up if you are a one man team and have a single app released. Passed this point, you'll sooner or later encounter questions like:
- `maintaining signing files and identities`
- `releasing multiple apps simultaneously or in a small time period`
- `Taking screenshots`

A lot of  can be automated through [fastlane](https://docs.fastlane.tools).

At Chronogolf we currently use the following tools:
- `produce`: generate iOS bundle ids and enable features like push-notifications
  ```
  fastlane produce -a org.nativescript.circleciint --skip_itc`
  ```

- `match`: generate and maintain iOS provisioning profiles for signing apps
    ```
    desc "Fetch and update prod profiles"
    lane :prod_certificates do
      match(git_url: "https://github.com/chronogolf/mobile-ios-keystores.git",
            type: "appstore",
            username: "myUserName",
            app_identifier: [
              "org.nativescript.circleciint",
              "org.nativescript.circleci2"
            ])
    end
    ```

- `pem`: generate iOS push notifications profiles
  ```
  fastlane pem -a org.nativescript.circleciint
  ```

## Release
At chronogolf we started with manually releasing apps as we only had a few, but their number grows, we need to automate this as well.

We could keep using `tns publish` for iOS and the API provided by the Google Play platform for Android.
*Google Play API details*:
This API ask to work with the concept of `Edit` which is a series of changes you stock, then apply when a final ending call is made.
Example:
- Creating a new `Edit` for the desired app
- Upload a new APK
- Assign APK to the release track
- Update the store listing
- Add descriptions about the update
- Validate

From therer, if everything went smooth without error, the new APK will go live with all the things specified in the steps.


Even though it's not that complicated, it exists tool that simplify this process and it seems logical to use only one tool to do both Android and iOS.

At the moment we've considered 2 tools at Chronogolf:
- Custom scripts wrapping `tns publish` and the Google play API
- Fastlane

- Custom scripts, clearly, will be hard to scale, maintain and update
- Fastlane is a tool dedicated to the very issue of automating things around mobile app creation. It's owned by Google, and will probably never become a paid solution as it's not in their interest.

*note* We thought about using Nativescript cloud tooling (Used in Sidekick), but were not sure if the rates limits apply if you only publish apps built locally.

Fastlane provide:
- [deliver](https://docs.fastlane.tools/actions/deliver/) for iOS
- [supply](https://docs.fastlane.tools/actions/supply/) for Android

Basically, both tool work the same way:
- init a release
- fetch/modify existing metadatas, screenshots, etc...
- run a command to push on the store

*Deliver*
`fastlane deliver --ipa "./my-app.ipa" --submit_for_review`
The option `submit_for_review` will automatically ask for the review.

*Supply*
`fastlane supply --apk path/app.apk --track release`

It's a breeze to use, and as you've already built your IPA and APK, you can just provide them!
