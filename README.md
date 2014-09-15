# DropboxSimpleOAuth

A quick and simple way to authenticate a Dropbox user in your iPhone or iPad app.

## Adding DropboxSimpleOAuth to your project

### Clone from Github

1.  Clone repository from github and copy files directly, or add it as a git submodule.
2.  Add all files from 'Source' directory to your project.

## Testing

* Prerequisites: [ruby](https://github.com/sstephenson/rbenv), [ruby gems](https://rubygems.org/pages/download), [bundler](http://bundler.io)

To use the included Rakefile to run expecta tests, run the setup.sh script to bundle required gems and cocoapods:

```bash
$ ./setup.sh
```

Then run rake to run the tests on the command line:

```bash
$ bundle exec rake
```

Additional rake tasks can be seen using rake -T:

```bash
$ rake -T
rake build  # Build DropboxSimpleOAuth
rake clean  # Clean
rake test   # Run Tests
```

## Suggestions, requests, and feedback

Thanks for checking out DropboxSimpleOAuth for your in-app Dropbox Authentication.  Any feedback can be
can be sent to: rbaumbach.github@gmail.com.
