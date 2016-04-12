# MrMime

## Installation

MrMime supports Rails 4+. Add the gem to your Gemfile:

```ruby
gem 'mr_mime'
```

Run the bundle command to install it.

After adding and installing the gem, run the installation generator:

```console
rails generate mr_mime:install
```

The generator will create an initializer which describes MrMime's configuration options.

Once the generator has run, add the following to your application.css file,
to include MrMime's default styles:

```css
/*
*= require 'mr_mime/mr_mime'
*/
```

Alternatively, if you are using sass, include the following in your application.scss file:

```scss
@import 'mr_mime/mr_mime';
```

## Usage

To begin using MrMime, add the following line to your ApplicationController:

```ruby
include MrMime::ImpersonationBehavior
```

This will give you access to the following helper methods in your controllers and views:
- `current_impersonator`
- `impersonator?`
- `impersonator_id`
- `button_to_impersonate`

### Starting Impersonation

Use the `button_to_impersonate` helper to add an impersonation button to your view:

```erb
<%= button_to_impersonate user.id %>
```

This method requires the id of the user that will be impersonated as it's first argument.
It also accepts the following options:
- `:button_text` sets the text inside the button. Defaults to "Impersonate User".
- `:button_class` sets the class of the button element.

Clicking this button will begin an impersonation session, during which the
impersonated user will be treated as the current user.

### Impersonation Warning

To include a warning to the bottom of the screen whenever an impersonation is in
effect, add the following to the bottom of your layout:

```erb
<%= render 'mr_mime/impersonation_warning' %>
```

You can also leave out this built-in warning, and create your own custom
impersonation warning, utilizing the helper methods listed above.

## About Foraker Labs

![Foraker Logo](http://assets.foraker.com/attribution_logo.png)

Foraker Labs builds exciting web and mobile apps in Boulder, CO. Our work powers a wide variety of businesses with many different needs. We love open source software, and we're proud to contribute where we can. Interested to learn more? [Contact us today](https://www.foraker.com/contact-us).

This project is maintained by Foraker Labs. The names and logos of Foraker Labs are fully owned and copyright Foraker Design, LLC.
