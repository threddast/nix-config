{ lib, ... }:
{
  # Enable acme for usage with nginx vhosts
  security.acme = {
    defaults.email = "acme@egiorg.is";
    acceptTerms = true;
  };

  environment.persistence = {
    "/persist" = {
      directories = [
        "/var/lib/acme"
      ];
    };
  };
}
