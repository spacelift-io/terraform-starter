# So you want to take Spacelift for a spin?

This repository is designed just for this purpose. Click the _Use this template_ button to create your own repository in a GitHub account you manage (either your private account or an organization you have admin rights on), and let's get started. **Make sure not to change the repository's name when creating your copy.**

In this tutorial, you will not be using any cloud providers. You won't need any extra credentials. The only resources you will create are those managed by [Spacelift's own Terraform provider](https://github.com/spacelift-io/terraform-provider-spacelift/).

## Step 1: Setup Your Spacelift Account

1. On the [Spacelift home page](https://www.spacelift.io/), click on the "Get Started" button.

![Spacelift home page](pics/homepage.png)

2. Sign Up with Google, GitLab or GitHub

![Spacelift sign up page](pics/signup.png)

3. You will be prompted to start a demo of the Spacelift platform. Feel free to do the demo, or you can skip it as well and follow this more in-depth guide.

## Step 2: Connecting with GitHub

> In this guide, we will be using GitHub to host our repositories. You can find more information about other supported VCS providers [here](https://docs.spacelift.io/integrations/source-control).

> The flow for connecting GitHub as a VCS provider is slightly different when using GitHub to sign in compared to the other sign-in options (GitLab, Google). Follow the section that is applicable to you.

### GitHub was used as a sign-in option:

1. [Install the Spacelift GitHub App](https://github.com/apps/spacelift-io/installations/new) if you not already installed it.
2. At this point, it's up to you to decide whether to give Spacelift access to all your repositories or a defined subset.

![Installing Spacelift for all repositories](pics/01-installing-all-min.png)

**Note**: don't agonize over this choice - you can always change it later.

3. Installing the application takes you to your first Spacelift screen, where you can create your first stack.

### Google or GitLab was used as a sign-in option:

1. After signing up, you should have arrived on the Spacelift console.
2. Follow the guide for [setting up the GitHub integration](https://docs.spacelift.io/integrations/source-control/github#setting-up-the-integration).
3. Make sure that you allow the Spacelift GitHub App installation access to the forked repository.

## Step 3: Creating your first stack

[Stacks](https://docs.spacelift.io/concepts/stack) are probably the most important concept in Spacelift. They connect your code and your infra, with some configuration in-between. To keep things short, a Spacelift stack maps directly to a single Terraform state file.

So without further ado, let's click on the _Add stack_ button and go through the stack creation process step by step.

### VCS integration

First, we need to tell Spacelift where the project code lives - this is the _Integrate VCS_ step.

Make sure that the provider is _GitHub_, the repository is the one you just created, and lastly, the _main_ branch is selected. These should be the default values.

![Integrating VCS](pics/03-integrate-vcs-min.png)

### Configure Backend

In the next step, we will choose the backend for this stack.

Spacelift can work with Terraform remote state providers, but it also provides its own state management. However, beyond convenience, there are no benefits to using it.

We don't have an existing state to import, so the most convenient thing is to continue with the defaults.

![Configuring backend](pics/04-configure-backend-min.png)

### Stack behavior

In the next step, you will configure this stack's behavior.

Since this is meant to be a quick and easy-to-follow tutorial, we won't go into the details, but you can read more about them [here](https://docs.spacelift.io/concepts/stack).

For now, the only tweak we need to do here is to mark the stack as [administrative](https://docs.spacelift.io/concepts/stack/stack-settings#administrative). Why? Because only administrative stacks can manage Spacelift resources, and that's what we'll be creating as part of this lab.

![Defining behavior](pics/05-define-behavior-min.png)

### Naming the stack

As they say, "_there are two hard problems in computer science: cache invalidation, naming things, and off-by-1 errors_". We'll make it easy this time: we've come up with a good name for your first stack, so feel free to copy it.

For now we won't care about [labels](https://docs.spacelift.io/concepts/stack#labels) or description (yes, we support Markdown), though you can read up on them when you're done with this lab.

![Naming stack](pics/06-name-stack-min.png)

Congratulations, you just created your first stack!

## Step 4: Triggering a run

Your new stack does not show any tracked runs (AKA deployments) yet. Let's trigger the first one.


![Trigger run](pics/07-trigger-run-min.png)

We can do that by clicking the _Trigger_ button in the upper right-hand corner of the screen. The trigger button will create a Spacelift job that will check out your code, run the usual Terraform commands against it, and present you with the choice of applying them or not.

![Confirm or discard](pics/08-confirm-or-discard-min.png)

You can always refer to the logs directly to see is planned to be changed. In this case, we're creating 25 Spacelift resources, and they all look good. So let's click on the _Confirm_ button and see what happens next.

![Changes applied](pics/09-changes-applied-min.png)

Wow, 10 seconds? That was quick! Let's go back to our stacks list to see what we've just done. Clicking on the Spacelift logo on the top left will take you there.

## Step 5: Exploring created resources

What we just did in Step 3 was create a bunch of very useful Spacelift resources. Looking at the main screen, we can quickly notice two things - our _Terraform starter_ stack turned green (always a good sign!), and there's another Stack we haven't seen before, called _Managed stack_.

![New stack](pics/10-new-stack-min.png)

It's red but don't worry, this is expected - one of the exercises here is to fix it.

### Environment

Now, where did _that_ come from? In fact, we declared it using Terraform just [here](./stack.tf). The same file defines many things related to the environment, so let's click on the name of the new stack to be taken to its screen.

Since it doesn't contain anything interesting just yet, let's quickly navigate to the _Environment_ screen. It is a very busy screen, so let's focus on the first section.

![Environment](pics/11-environment-min.png)

We see are [environment variables](https://docs.spacelift.io/concepts/environment#environment-variables) and [mounted files](https://docs.spacelift.io/concepts/environment#environment-variables) - [some public and some secret](https://docs.spacelift.io/concepts/environment#a-note-on-visibility) - that we indeed saw defined in the [`stack.tf`](./stack.tf) file we just looked at. But there are others - see the ones with the blue label to their right? Where did they come from? They're actually defined [here](./context.tf) and belong to a context attached to the new Stack.

But before we move on to the context, click the _Edit_ button in the upper right-hand corner of the screen and play around with environment variables and mounted files.

### Context

[Contexts](https://docs.spacelift.io/concepts/configuration/context) are how Spacelift does configuration reuse. Rather than having to copy and paste a bunch of configuration variables, Spacelift allows you to encapsulate them as a package and [attach](https://docs.spacelift.io/concepts/configuration/context#attaching-and-detaching) them to as many stacks as you want.

So if you navigate back to the main screen (hint: click on the logo) and then go to the Contexts screen, selecting it from the hamburger menu next to your name, that's what you're going to see.

![Contexts](pics/12-contexts-min.png)

Clicking on the context name takes you to the context screen, where you can see that it currently contains two environment variables (one plaintext and one secret) and two mounted files, one plaintext and one secret:

![Context](pics/13-context-min.png)

Note that you can edit the context just as you can edit the stack's own environment. That _Edit_ button is there for a reason, so go wild before we move on to [policies](https://docs.spacelift.io/concepts/policy), which are the second most important topic in Spacelift.

### Policies

When you navigate to the Policies screen, you will see that we've created six different policies.

![Policies](pics/14-policies-min.png)

All these policies are defined and explained in the [`policies.tf`](./policies.tf) file, but let's go through them one by one:

- _DevOps are admins_ is a [login policy](https://docs.spacelift.io/concepts/policy/login-policy) that would make anyone who's a member of the _DevOps_ team in your GitHub organization log in as a Spacelift administrator as opposed to the default situation where only GitHub admin users are automatically Spacelift admins. Note: this changes if you're [using SSO](https://docs.spacelift.io/integrations/single-sign-on) instead of GitHub to authenticate;

- _All of Engineering gets read access_ is an [access policy](https://docs.spacelift.io/concepts/policy/stack-access-policy) that gives any member of the _Engineering_ GitHub team read access to every stack it's attached to;

- _Ignore commits outside the project root_ is a [Git push policy](https://docs.spacelift.io/concepts/policy/git-push-policy) that ignores push notifications which do not affect any files outside of the project root of the stack it's attached to;

- _Enforce password strength_ is a [plan policy](https://docs.spacelift.io/concepts/policy/terraform-plan-policy) that prevents you from creating weak passwords using [`random_password`](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) resource type - we'll see this one in action shortly;

- _Allow only safe commands_ is a [task policy](https://docs.spacelift.io/concepts/policy/task-run-policy) that limits commands that can be run as [tasks](https://docs.spacelift.io/concepts/run/task). This is another one that we're going to try hands-on;

- _Trigger stacks that declare an explicit dependency_ is a [trigger policy](https://docs.spacelift.io/concepts/policy/trigger-policy) that will cause every stack that declares dependency to be triggered when the current one is updated - while this one is probably beyond the scope of the basic tutorial, we wanted to show you that Spacelift is [Turing-complete](https://en.wikipedia.org/wiki/Turing_completeness). Also, a trigger policy is what triggered a failing run on the newly created stack.

### Policies in practice

While it's worth mentioning that we're using an [open-source language](https://www.openpolicyagent.org/) for our policies, authoring policies is outside of the scope of this tutorial.

Instead, we'd like to show you the power of policies hands-on. Let's navigate to our new stack (_Managed stack_) and try to figure out why the run created by the trigger policy failed. Looks like a resource we're trying to create does not comply with our policy.

![Plan policy failing a run](pics/15-failed-commit-min.png)

Don't worry for now about fixing it, we will do that in the next step. Instead, let's navigate to our new Stack's Tasks screen and try to run something. How about `terraform output`? Nope, it didn't work either.

![Task failed](pics/16-task-failed-min.png)

Now, try running `ls -la`. This will succeed. The reason is that the `ls -la` command is authorized by the _Allow only safe commands_ policy while `terraform output` is not.

## Step 6: Tests and pull requests

In this step, we'll try to fix the problem reported by the plan policy, and while doing that, we'll see how Spacelift deals with testing your changes and handling Pull Requests.

Let's edit the [`managed-stack/main.tf`](./managed-stack/main.tf) file to make the random password we're trying to create in this new stack just a little bit longer - let's say 24 characters. Do not push that change to the `main` branch but create a separate branch and open a Pull Request.

![Open Pull Request](pics/17-open-pull-request-min.png)

And here's the exact change we're making:

![Pull Request changes](pics/18-pull-request-changes-min.png)

That little change causes two runs to be executed since this repository is now connected to two stacks - one that you created manually and one that is managed programmatically. It's the latter stack we've made changes to, so you will see that there are no changes to the former, but one resource would be created for the latter. 

![Pull Request feedback](pics/19-pull-request-feedback-min.png)

Clicking on the _Details_ link next to the commit status check takes you to the test run for the affected stack. 

![PR details](pics/20-pull-request-preview-min.png)

Let's click on _View more details on spacelift.io_ and see the details of the proposed run for the  PR. [Proposed runs](https://docs.spacelift.io/concepts/run/proposed) are previews of changes that would be applied to your infrastructure if the new code was merged into a tracked branch, which we will do in a minute.

![PR details](pics/21-pull-request-run-min.png)

Now that the push policy is happy with the new length of your password, you can merge the Pull Request to the `main` branch.

A run will be created automatically in the _Runs_ tab of your _Managed stack_ which should automatically apply the changes  (see the `autoapply` setting in [`stack.tf`](./stack.tf)).

![Run from a merged PR](pics/22-merged-pull-request-min.png)

## Congratulations! 👏🏻 

You're a Spacelift expert now! If you like what you've seen so far, here are some suggestions:

- [learn more about policies](https://docs.spacelift.io/concepts/policy) and create one from scratch;
- create some resources on a public cloud;
- [connect your Slack workspace](https://docs.spacelift.io/integrations/slack);
- learn about our native [cloud integrations](https://docs.spacelift.io/integrations/cloud-providers);
- set up [SSO for your organization](https://docs.spacelift.io/integrations/single-sign-on);
- start a [Spacelift agent](https://docs.spacelift.io/concepts/worker-pools) in your own infrastructure (yes, it will run on your laptop, too).
