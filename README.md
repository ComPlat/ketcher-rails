## Ketcherails

### Description

This gem provides the possibility to use Ketcher editor with Rails and contains
server actions implementations.

### Usage

Add it to Gemfile
```ruby
gem 'ketcherails', '0.0.1'
```
This is a self-mountable Rails engine. Routes are mounted to /ketcherails
and API routes to /api/<version>/ketcher.

To use Ketcher editor, make an iframe like this:
```html
<div>
  <iframe id="ifKetcher" src="/ketcher"></iframe>
</div>
```

### License

This project uses GPLv3 license.
