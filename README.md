# WhiteTail

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/white_tail`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem "white_tail"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install white_tail

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Reference Guide

Parse Time - When ruby reads the user projects and build all user classes. The output is a hierarchy of classes and scripts that describe how to scrape a certain project.

Run Time - Taking a project tree and running all scripts on the nodes, so we get a scrapped content.

Classes/Modules:

* Project - a class that describes a scrapping project.
* Page - a class that describes a page in the web.
* Section - a class that describes a piece of a page.
* Text - a class that describes a string that appears on a page/section
* Script - a list of commands that need to be run in sequence to scrape a Project/Page/Section/Text. It's a variable that get defined on parse time and stored on the relevant class - Projects/Pages/Sections/Text.
* ScriptBuilder - a module that mixed in Project/Page/Section/Text classes, and manages the Script instance stored on these classes.

## Q&A

Q: Why user defined objects like project, page etc. are inherited from classes?

A: Because they are named objects (like `:wikipedia`), and we can leverage Ruby global namespace to host their names. Since all user objects are described in a tree hierarchy, we can nest them all under `WhiteTail::Projects`. For example `WhiteTail::Projects::Wikipedia::DefinitionPage::TitleText` will describe the title in the definition page of the wikipedia project. Another advantage, is that the user can define methods on these objects, because they are just like any other class in the system.

Q: So why classes and not modules?

A: Because it make sense to have instances of these classes: they're the actual scrapping results.

Q: So we have a page class. What is the difference to page command?

A: Page is just declaration of how the page does look. A command is part of the script, and it tells when and where to look for that page - for example at the 3st command of the script, at url "http://example.com". Page, that is the class object, includes a @script variable that holds list of commands to run on this page when it get scrapped. In particular, a page can hold a command to open another page (that may be declared/described elsewhere).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/white_tail.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
