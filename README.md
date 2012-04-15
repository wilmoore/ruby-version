ruby-version: stupid simple Ruby version management
===================================================


**ruby-version** exposes a single command `ruby-version` allowing developers to switch between multiple versions of Ruby.

**ruby-version** is conceptually similar to [rbenv](https://github.com/sstephenson/rbenv); however, **much** `simpler`.

**ruby-version** consists of a single shell function and an accompanying shell completion script.

**ruby-version** lives in a single file (including shell completion) which can be sourced via your shell profile.

**ruby-version** considers leaky abstractions to be a huge flailing `fail`.


Who is it for?
----------------------------

**ruby-version** is primarily for developers that compile multiple versions of Ruby on Linux or Mac.

**ruby-version** gets out of the way so you can work with `ruby` the same as if you only had a single version installed.


Who is it _NOT_ for?
----------------------------

If you are a super neck-beard academic, you are likely already doing this as `a matter of fact` as part of your normal workflow;
in which case, **ruby-version** is likely not going to be very interesting to you. I respect that :)


Rationale
----------------------------

**ruby-version** attempts to stick to the classic UNIX notion that tools should do one thing well.

>   While there are [smart](https://github.com/sstephenson/rbenv) [alternative](http://beginrescueend.com/)
>   [tools](https://github.com/hmans/rbfu) that attempt to [solve](https://github.com/vertiginous/pik)
>   this problem, [none](http://www.zenspider.com/ZSS/Products/ZenTest/) of the tools I've found were simple enough for me.


**ruby-version** is excellent for automated testing of applications against multiple Ruby versions on a single machine.


Features
----------------------------

-   keeps it simple...no magic
-   promotes multiple, per-user Ruby installs
-   shell completion (e.g. ruby-version jruby-[PRESS-TAB-NOW])
-   provides access to the manpages of the current version by updating your `$MANPATH` environment variable
-   defers to native shell commands where possible (e.g. `man irb`)
-   unobtrusive install/uninstall (we won't leave files and symlinks all over the place)


Non-Features
----------------------------

-   does not rely on symlinks or sub-shells
-   does not compile/install Ruby. This is left up to you or you can use something like (ruby-build)[https://github.com/sstephenson/ruby-build]


Usage Examples
----------------------------

**Switch to a specific Ruby version**

    % ruby-version <version>

**List installed Ruby version(s)**

    % ls $RUBY_VERSIONS

**List the active Ruby version**

    % echo $RUBY_VERSION

**Identify full path to:**

    % which erb

    % which gem

    % which irb

    % which rake

    % which rdoc

    % which ri

    % which ruby

    % which testrb

**View manual pages**

    % man erb

    % man irb

    % man rake

    % man ri

    % man ruby


Download and Installation
----------------------------

**Git/Github**

    % cd $HOME/local
    % git clone https://github.com/wilmoore/ruby-version.git

**cURL**

    % mkdir -p $HOME/local/ruby-version
    % cd !$
    % curl -# -L https://github.com/wilmoore/ruby-version/tarball/master | tar -xz --strip 1

**homebrew**

    % brew install https://raw.github.com/gist/2341171/ruby-version.rb
    % source $(brew --prefix ruby-version)/ruby-version.sh


Activate Default Ruby version
-----------------------------

**In `$HOME/.bashrc` or `$HOME/.bash_profile` or your shell's equivalent**

Configuration for standard installs

    ########################################################################################
    # ruby-version (activate default Ruby version and autocompletion)
    # export RUBY_VERSIONS                  => reflects location of compiled Ruby versions
    # export RUBYVERSION_DISABLE_COMPLETE=1 => to disable shell completion
    ########################################################################################
    export RUBY_VERSIONS=${HOME}/local/ruby/versions
    source $HOME/local/ruby-version/ruby-version.sh && ruby-version 1.9.3-rc1 >/dev/null

**NOTE**: the comment block is optional

Configuration for Homebrew installs

    ########################################################################################
    # ruby-version (activate default Ruby version and autocompletion)
    # export RUBY_VERSIONS                  => reflects location of compiled Ruby versions
    # export RUBYVERSION_DISABLE_COMPLETE=1 => to disable shell completion
    ########################################################################################
    export RUBY_VERSIONS=${HOME}/local/ruby/versions
    source $(brew --prefix ruby-version)/ruby-version.sh && ruby-version 1.9.3-rc1 >/dev/null

**NOTE**: the comment block is optional

Deactivate / Uninstall
----------------------------

**Remove Configuration**

From your `$HOME/.bash_profile` or equivalent; remove the call to `ruby-version`, `source ruby-version.sh`,
and the `RUBY_VERSIONS` environment variable (of course, keep the variable if used for other purposes):

**Remove Files**

    % rm -rf /path-to/ruby-version # or (brew uninstall ruby-version)


Switching Versions
-----------------------------

**Call it like this in your terminal**

    % ruby-version 1.9.3-rc1

**Bash Completion**

    % ruby-version 1.[PRESS-TAB-NOW]


Building Ruby from Source
-----------------------------

**ruby-version** doesn't care how you've obtained your Ruby versions; it only cares that you've stored them neatly
under a common directory structure. You may build multiple Ruby versions manually by typing:

    $ ./configure --prefix=... && make && make install

or via a tool such as [ruby-build](https://github.com/sstephenson/ruby-build).

**The following directory structure or equivalent is recommended (but not required):**

    % mkdir -p $HOME/local/ruby/download/
    % mkdir -p $HOME/local/ruby/versions/{1.9.2,1.9.3-rc1}/src

The following `configure`, `make`, and `make install` commands are the bare minimum for building on MAC OSX:

    % ./configure --prefix=${RUBY_VERSIONS}/1.9.3-rc1 --with-opt-dir=$(brew --prefix libyaml) --with-gcc=clang
    % make && make install

**NOTE**: drop the `--with-gcc=clang` if you don't have clang. If you are on MAC OSX Lion, you probably want to keep the flag
`--with-gcc=clang`; however, if you are on Linux and you've never heard of clang or know you didn't opt-into it, this option
is likely not for you. In that case, your `configure` line would be:

    % ./configure --prefix=${RUBY_VERSIONS}/1.9.3-rc1 --with-opt-dir=$(brew --prefix libyaml)
    % make && make install

**NOTE**: Ruby expects that you've installed a Yaml library such as `libyaml`. You may install `libyaml` manually or you can
use homebrew:

    % brew install libyaml

At this point, when you compile Ruby, you need to pass to the flag `--with-opt-dir=` you `libyaml` install directory.


FAQ
----------------------------

**What if my Ruby versions are not stored neatly under a single directory like `$HOME/local/ruby/versions`?**


    % RUBY_VERSIONS=/usr/local/Cellar/ruby ruby-version 1.9.3-rc1

    SWITCHED RUBY VERSION TO: 1.9.3-rc1
    NEW RUBY ROOT DIRECTORY : /usr/local/Cellar/ruby/1.9.3-rc1

    % which ruby

    /usr/local/Cellar/ruby/1.9.3-rc1/bin/ruby


Troubleshooting
----------------------------

**Sorry, but ruby-version requires that \$RUBY_VERSIONS is set and points to an existing directory.**

The $RUBY_VERSIONS environment variable was not set...you can export it via your shell profile or you can set it on the fly as in the following:

    % RUBY_VERSIONS=$HOME/local/ruby/versions ruby-version 1.9.3-rc1

**Sorry, but ruby-version requires that the environment variable \$RUBY_VERSIONS is set in order to initialize bash completion.**

The $RUBY_VERSIONS environment variable was not set...you can export it via your shell profile or you can set it on the fly as in the following:

    % RUBY_VERSIONS=$HOME/local/ruby/versions ruby-version 1.9.3-rc1

**Sorry, but ruby-version was unable to find directory '1.9.3-rc1' under '/home/your-user/local/ruby/versions'.**

The version was entered incorrectly **(i.e. "ruby-version 1.9.i" instead of "ruby-version 1.9.3-rc1")** or you haven't yet compiled the given version.


Resources
----------------------------

-   [Command Line Tools For Xcode](https://developer.apple.com/downloads)


Alternatives
----------------------------

-   [rbenv](https://github.com/sstephenson/rbenv)
-   [rvm](http://beginrescueend.com/)
-   [rbfu](https://github.com/hmans/rbfu)
-   [multiruby](http://www.zenspider.com/ZSS/Products/ZenTest/)
-   [pik](https://github.com/vertiginous/pik)
-   [GNU Stow](http://www.gnu.org/s/stow/)
-   [Encap](http://www.encap.org/)


Inspiration
----------------------------

-   [rbenv](https://github.com/sstephenson/rbenv)
-   [php-version](https://github.com/wilmoore/php-version)

