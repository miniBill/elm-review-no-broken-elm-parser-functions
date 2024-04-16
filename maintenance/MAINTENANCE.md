### 4. (Can be done later) Create the project on GitHub

You can do this step at a later time if you prefer.
When you do, consider to

-   Adding the `elm-review` tag, so that your project appears in [this list](https://github.com/topics/elm-review).
-   [Adding a code of conduct](https://docs.github.com/en/github/building-a-strong-community/adding-a-code-of-conduct-to-your-project)
-   [Adding issue and pull request templates](https://docs.github.com/en/github/building-a-strong-community/using-templates-to-encourage-useful-issues-and-pull-requests)
-   [Setting guidelines for repository contributors](https://docs.github.com/en/github/building-a-strong-community/setting-guidelines-for-repository-contributors)

## Publishing

### Initial release

The initial release has to be done manually. I recommend running the following script:

```bash
# Make sure your tests pass. Fix them if necessary
npm test

# Generate the example configurations
node maintenance/update-examples-from-preview.js
git add --all
git commit --message '1.0.0'

# Commit
git tag 1.0.0
git push --tags origin $(git_main_branch)
elm publish
```

### Successive releases

Contrary to the initial release, the CI will automatically try to publish a new version of the package when the version in the `elm.json` is bumped. There is **no need** to add the Git tag or to run `elm publish` yourself! More details [here](https://github.com/dillonkearns/elm-publish-action).

Here is a script that you can run to publish your package, which will help you avoid errors showing up at the CI stage.

```bash
npm run elm-bump

# Commit it all
git add --all
git commit # You'll need to specify a message
git push origin HEAD

# Now wait for CI to finish and check that it succeeded
```
