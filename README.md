# Riggleman Lab Website

This git repository contains the source files necessary to generate the lab website found on [rrgroup.seas.upenn.edu](http://rrgroup.seas.upenn.edu/). The website is built using a [static site generator](https://davidwalsh.name/introduction-static-site-generators) called [Jekyll](http://jekyllrb.com/). Jekyll is a Ruby program, but don't worry...you won't have to do any coding in Ruby to make changes to this site. You will, however, need to download Ruby and a few Ruby packages. Just follow the steps below if you want to make changes.

## 1. Download Ruby

There are a couple different ways to do this, but [Ruby Version Manager](https://rvm.io/) (a.k.a RVM) worked for me. The RVM install steps can be found [here](https://rvm.io/rvm/install), but below is a good summary of what you'll have to do.

1. Check if you have GnuPG. Run `which gpg`, and if it prints a path, then skip to step 3.
2. If you don't have GnuPG, install it. On a Mac, do `brew install gnupg`.
3. Do `gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3`. If this command fails, go back to step 2 and do `brew install gnupg2`, then repeat the long command with `gpg2` instead of `gpg` at the beggining.
4. Do `\curl -sSL https://get.rvm.io | bash -s stable --ruby`. This installs the latest stable version of Ruby. This takes a while.

## 2. Install Bundler

[Bundler](http://bundler.io/) is a Ruby package that helps maintain consistent environments in Ruby projects. Install it using `gem install bundler`.

## 3. Get the website source files

Run `git clone https://github.com/benlindsay/lab_site` wherever you want the repo to go.

## 4. Download the Gems (Ruby packages) you need

Do `cd lab_site`, then `bundle install`. This looks at `Gemfile`, which lists the gems you need, and installs them.

## 5. Build and View Site

If everything above worked properly, then you should be able to build the site locally and see the results. If you type `jekyll serve`, you should get the following output:

```
$ jekyll serve
Configuration file: /Users/lindsb/Dropbox/lab_site/_config.yml
            Source: /Users/lindsb/Dropbox/lab_site
       Destination: /Users/lindsb/Dropbox/lab_site/_site
 Incremental build: disabled. Enable with --incremental
      Generating...
                    done in 11.536 seconds.
 Auto-regeneration: enabled for '/Users/lindsb/Dropbox/lab_site'
Configuration file: /Users/lindsb/Dropbox/lab_site/_config.yml
    Server address: http://127.0.0.1:4000/
  Server running... press ctrl-c to stop.
```

This command generates all the website files, which go into the `_site` directory, and starts a local server so you can preview the website. Now, if you copy and paste the server address, `http://127.0.0.1:4000/`, or simply `localhost:4000` into your browser, you should see a local version of the website. If you make and save changes to a file, you should see output like the following:

```
       Regenerating: 1 file(s) changed at 2016-12-12 13:10:15 ...done in 5.934402 seconds.
```

Now if you refresh the page, changes you make should be reflected in your browser. You can stop the local server when you're done using <kb>CTRL</kb>+<kb>C</kb>.

## 6. Make the changes you want

Here are some instructions on how to make changes:

### Change Profile Picture

To change your profile picture, find `images/members/your-name.jpg` and replace it with your new image. Please make sure your picture is exactly square.

### Change Profile Content

If you want to update anything that shows up on your profile page, simply find your file, something like `members/_posts/2000-01-01-your-name.md`, open it, and make your changes. If you, for example, see a LinkedIn link on someone's profile and you want one too, just look at their file in `members/_posts/` and make your file look like theirs.

### Add a Publication

The publication data is all stored in files in `publications/_posts/`. To add a new publication, just create a new file in there and follow the format of other files.

## 7. Ask me for write priveleges

Shoot me an email and ask for write priveleges and I'll add you as a contributor.

## 8. Commit your changes

```
git add .
git commit -m "explanation of the change I just made"
git push origin master
```

## 9. Wait for me to use the updated source code to update the official lab website.
