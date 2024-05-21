let
  gustave = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDJrHUzjPX0v2FX5gJALCjEJaUJ4sbfkv8CBWc6zm0Oe";
  tower = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA9QGKzHJ5/PR/il8REaTxJKB4G2LEEts0BlcVz789lt";
  lisa = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO4kSscukEEoW/QiLgyZQluhsYK4wF+lFphlCakKYC2q";
  core-security = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICLnOINGYOFb+bLUUTV9sjwi2qbpwcaQlmGmWfy1PeGR";
  x2100 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG/zyse3NaSi9nxMSZ9ICYe4MMjUka+DewJ5M5N8cCBy";
  servers = [
    gustave
    tower
    lisa
    core-security
  ];
  all = servers ++ [ x2100 ];
in
{
  "deluge-webui-password.age".publicKeys = [ lisa ];
  "keycloak-db.age".publicKeys = [ core-security ];
  "github-oauth-secret.age".publicKeys = [ tower ];
  "github-webhook-secret.age".publicKeys = [ tower ];
  "github-token-secret.age".publicKeys = [ tower ];
  "buildbot-nix-worker-password.age".publicKeys = [ tower ];
  "buildbot-nix-workers.age".publicKeys = [ tower ];
  "ssh-lisa-pub.age".publicKeys = [ lisa ];
  "ssh-lisa-priv.age".publicKeys = [ lisa ];
  "git-gpg-private-key.age".publicKeys = servers ++ [ x2100 ];
  "user-julien-password.age".publicKeys = all;
  "user-root-password.age".publicKeys = all;
  "ens-mail-password.age".publicKeys = servers ++ [ x2100 ];
  "julien-malka-sh-mail-password.age".publicKeys = [ lisa ];
  "malka-ens-school-mail-password.age".publicKeys = [ lisa ];
  "mondon-ens-school-mail-password.age".publicKeys = [ lisa ];
}
