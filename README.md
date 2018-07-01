## Ketcherails

### Description

This gem provides the possibility to use Ketcher v1. editor with Rails and contains
server actions implementations.
Ketcher editor has been originally built by ![GGA Software](https://github.com/ggasoftware/ketcher) 


### Usage

This is a self-mountable Rails engine.

Add it to your app Gemfile
```ruby
gem 'ketcherails', git: 'https://github.com/ComPlat/ketcher-rails'
```

Inkscape should also be installed (`sudo apt-get install inkscape` for Linux). 


To take advantage of the molecule common template features, the app should have a user model for Warden based authentication.

The User model should have/expose a boolean attribute 'is_templates_moderator' to authorize the template editing.

Or bypass this by stubbing the current_user (see ![f9d14e5](https://github.com/ComPlat/ketcher-rails-test_app/commit/f9d14e5fd6e8925e1e484f667eaaef998c06a125) of a blank test app).

The user custom template feature also relies on user Warden authentication.

You need to set the application active_job handler (eg with DelayedJob see ![f147743](https://github.com/ComPlat/ketcher-rails-test_app/commit/f147743e8ada73ebb28c6ce6356b982fde968abc))



Routes are mounted to /ketcher:

- full page editor: /ketcher

- client api demo editor: /ketcher/demo

- Template management pages: /ketcher/common_templates




Insert the ketcher into an iframe; Molfile setter/getter, and SVG getter functions are available :

```html
      <iframe width="80%" height="800" id="ifKetcher" src="/ketcher"></iframe>
      
      <script>
        function ketcher() {
          const ketcherFrame = document.getElementById('ifKetcher');
          if (ketcherFrame && ('contentDocument' in ketcherFrame)) {
            return ketcherFrame.contentWindow.ketcher;
          }
          return document.frames['ifKetcher'].window.ketcher;
        };
        function getSVG() {
          document.getElementById("result").innerHTML =  ketcher().getSVG();
        };
        function getMolfile() {
          document.getElementById("result").innerHTML = ketcher().getMolfile();
        };
        function setMolfile() {
          const molfile = "\n  Ketcher 06271817312D 1   1.00000     0.00000     0\n\n  3  3  0     0  0            999 V2000\n    1.0000    0.0000    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0\n    0.5000   -0.8660    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0\n    0.0000    0.0000    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0\n  1  2  1  0     0  0\n  2  3  1  0     0  0\n  1  3  1  0     0  0\nM  END\n$$$$\n"
          ketcher().setMolecule(molfile);
        };
      </script>

      <button onclick="getSVG()">get SVG</button>
      <button onclick="getMolfile()">get Molfile</button>
      <button onclick="setMolfile()">Draw cyclopropane</button>
```

(see app/view/ketcherails/ketcher/demo.html, or app/assets/javascripts/ketcher/demo.html, or go to 
ketcher/demo in your application)

### License

This project uses GPLv3 license.
