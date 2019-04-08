# OpenStax::Cnx

This gem provides a Ruby interface to OpenStax book content.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'openstax_cnx'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install openstax_cnx

## Usage

Books are made up of BookParts and Pages.  Every Book as a single top-level "root" BookPart.  BookParts can contain other BookParts and Pages.  Many OpenStax books are organized as pages within chapters.  For these books the Ruby objects hierarchy looks like:

```
Book
  BookPart (the "root")
    Page (the "Preface")
    BookPart (Chapter 1)
      Page (Introduction)
      Page (Section 1.1)
      etc...
    BookPart (Chapter 2)
      Page (Introduction)
      etc...
    etc...
```

Some OpenStax books organized chapters into units.  The units are BookParts like the chapters are:

```
Book
  BookPart (the "root")
    Page (the "Preface")
    BookPart (Unit 1)
      Page (Unit Introduction)
      BookPart (Chapter 1)
        Page (Introduction)
        Page (Section 1.1)
        etc...
      BookPart (Chapter 2)
        Page (Introduction)
        etc...
      etc...
    BookPart (Unit 2)
      etc ...
```

This gem gives you Ruby objects to navigate this hierarchy and access the metadata and content at each level.  You start by creating a `Book` object given that book's UUID.

```ruby
book = OpenStax::Cnx::V1.book(id: "031da8d3-b525-429c-80cf-6c8ed997733a")
```

Books have some metadata you can read out:

```ruby
book.title # => "College Physics"
book.baked # => "2019-03-20T14:24:26.164476-05:00"
book.url   # => "https://archive.cnx.org/contents/031da8d3-b525-429c-80cf-6c8ed997733a"
```

To get all pages in a book:

```ruby
book.root_book_part.pages.count   # => 460
```

To dig deeper, get the `root_book_part` and then is `parts`

```ruby
book.root_book_part.is_root # => true
book.root_book_part.parts.count # => 40
book.root_book_part.parts.first.class # => OpenStax::Cnx::V1::Page
book.root_book_part.parts.first.title # => "Preface"
book.root_book_part.parts[2].class # => OpenStax::Cnx::V1::BookPart
book.root_book_part.parts[2].title # => "Kinematics"
book.root_book_part.parts[2].is_chapter? # => true
book.root_book_part.parts[2].parts.count # => 13
book.root_book_part.parts[2].parts[6].class # => OpenStax::Cnx::V1::Page
book.root_book_part.parts[2].parts[6].title # => "Problem-Solving Basics for One-Dimensional Kinematics"
book.root_book_part.parts[2].parts[6].baked_book_location # => ["2", "6"]
book.root_book_part.parts[2].parts[6].parsed_title # => {:text=>"Problem-Solving Basics for One-Dimensional Kinematics", :book_location=>["2", "6"]}
```

Note that a BookPart's parts array can contain both Pages and BookParts.  The baked book location is the section number, e.g. above we see section 2.6.

You can run the above commands using the `bin/console` command in the gem directory.

### Configuration

You can override default gem configurations with the following:

```ruby
OpenStax::Cnx::V1.configure do |config|
  # where to get the book content
  config.archive_url_base = "https://someurl.com" # default is "https://archive.cnx.org"
  # whether to ignore the book version history
  config.ignore_history = false # default is true
  # a logger
  config.logger = Rails.logger # default is a null logger
end
```

You can temporarily override the Archive URL with:

```ruby
OpenStax::Cnx::V1.with_archive_url("https://archive-staging.cnx.org") do
  # your code here, will see the archive-staging url
end
# the original archive URL will be reset by this point
```

This is useful in tests where the content may not be on the production system.

### What is `V1`?

The versions in this gem (e.g. the `V1` in `OpenStax::Cnx::V1::Book`) are not versions of the CNX API, but rather just different ways of building models to access the CNX API.  We made a `V1` so that we could wildly change our mind later and add a `V2` without impact `V1` clients.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/openstax_cnx. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the OpenstaxCnx project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/openstax_cnx/blob/master/CODE_OF_CONDUCT.md).
