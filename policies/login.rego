package spacelift

admins  := { "root@oolessence.io", "sudo@oolessence.io", "quinn@oolessence.io" }
login   := input.session.login

admin { admins[login] }
allow { endswith(input.session.login, "@oolessence.io") }
deny  { not admin; not allow }