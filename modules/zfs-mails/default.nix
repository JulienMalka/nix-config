{ pkgs, config, lib, ... }:
let
  cfg = config.luj.zfs-mails;
  emailTo = "julien.malka@me.com";
  emailFrom = "newton@newton.fr";
  msmtpAccount = {
    auth = "plain";
    host = "smtp-relay.sendinblue.com";
    port = "587";
    user = "julien.malka@me.com";
    passwordeval = "cat /run/secrets/sendinblue-mail-passwd";
    from = emailFrom;
  };



  customizeZfs = zfs:
    (zfs.override { enableMail = true; });

  hostName = cfg.name;
  sendEmailEvent = { event }: ''
    printf "Subject: ${hostName} ${event} ''$(${pkgs.coreutils}/bin/date --iso-8601=seconds)\n\nzpool status:\n\n''$(${pkgs.zfs}/bin/zpool status)" | ${pkgs.msmtp}/bin/msmtp -a default ${emailTo}
  '';

in
with lib;
{
  options.luj.zfs-mails = {
    enable = mkEnableOption "enable zfs status mails";
    name = mkOption {
      type = types.str;
    }; 
    smart.enable = mkEnableOption "enable smart deamon";
  };


  config = mkIf cfg.enable (mkMerge [{

    nixpkgs.config.packageOverrides = pkgs: {
      zfsStable = customizeZfs pkgs.zfsStable;
    };


    programs.msmtp = {
      enable = true;
      setSendmail = true;
      defaults = {
        aliases = builtins.toFile "aliases" ''
          default: ${emailTo}
        '';
      };
      accounts.default = msmtpAccount;
    };

    services.zfs.zed.enableMail = true;
    services.zfs.zed.settings = {
      ZED_EMAIL_ADDR = [ emailTo ];
      ZED_EMAIL_OPTS = "-a 'FROM:${emailFrom}' -s '@SUBJECT@' @ADDRESS@";
      ZED_NOTIFY_VERBOSE = true;
    };


    systemd.services."boot-mail-alert" = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "network-online.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = sendEmailEvent { event = "just booted"; };
    };
    systemd.services."shutdown-mail-alert" = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "network-online.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = "true";
      preStop = sendEmailEvent { event = "is shutting down"; };
    };
    systemd.services."weekly-mail-alert" = {
      serviceConfig.Type = "oneshot";
      script = sendEmailEvent { event = "is still alive"; };
    };
    systemd.timers."weekly-mail-alert" = {
      wantedBy = [ "timers.target" ];
      partOf = [ "weekly-mail-alert.service" ];
      timerConfig.OnCalendar = "weekly";
    };



  }

  (mkIf cfg.smart.enable {
    services.smartd.enable = true;
    services.smartd.notifications.mail.enable = true;
    services.smartd.notifications.mail.sender = emailFrom;
    services.smartd.notifications.mail.recipient = emailTo;


  })

]);

}


