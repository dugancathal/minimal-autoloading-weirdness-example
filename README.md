# minimal-autoloading-weirdness-example

Note that running the `controllers/v1/users_controller_spec.rb` should
_not_ work because the actual controller isn't in the `Groups` namespace.
However, due to ActiveSupport's autoloading functionality, it _does_
pass.

The path goes something like this:
- run `rspec <file>`
- rspec loads the spec helper
- rspec runs `<file>`
- `<file>` mentions `V1` which isn't defined yet
- ActiveSupport looks in autoload paths for `v1` and finds `app/controllers/v1/`
  - because there's no `v1` module defined, but there is a directory, ActiveSupport creates one on the fly
- `<file>` mentions `V1::Groups` which isn't defined yet
- ActiveSupport looks in autoload paths for `v1/groups` and finds `app/controllers/v1/groups`
  - because there's no `v1/groups` module defined, but there is a directory, ActiveSupport creates one on the fly
- `<file>` mentions `V1::Groups::UsersController` which isn't defined yet
- ActiveSupport looks in autoload paths for `v1/groups/users_controller` but doesn't find anything
- The autoload mechanism then looks in parent namespaces for a `users_controller` file
  - it finds `v1/users_controller`
 
To be clear, this is a bug and was fixed in ActiveSupport 5.2.0 with the new autoloading code.
[This section of the ActiveSupport 5.0 docs] is helpful for walking through the above. And this
[stackoverflow post] points you to the upgrade as the fix

[This section of the ActiveSupport 5.0 docs]: https://guides.rubyonrails.org/v5.0/autoloading_and_reloading_constants.html#autoloading-algorithms-qualified-referencesk
[stackoverflow post]: https://stackoverflow.com/questions/64548442/unable-to-autoload-constant-bug-in-rails-5-2-0/64601195#64601195
