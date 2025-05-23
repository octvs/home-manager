{
  config,
  pkgs,
  options,
  lib,
  ...
}:

{
  services.screen-locker = {
    enable = true;
    inactiveInterval = 5;
    lockCmd = "${pkgs.i3lock}/bin/i3lock -n -c AA0000";
    lockCmdEnv = [
      "DISPLAY=:0"
      "XAUTHORITY=/custom/path/.Xauthority"
    ];
    xssLockExtraOptions = [ "-test" ];
    xautolockExtraOptions = [ "-test" ];
    enableDetectSleep = true;
  };

  # Use the same verification script as the basic configuration. The result
  # with the old options should be identical.
  nmt.script = (import ./basic-configuration.nix { inherit config pkgs; }).nmt.script;

  test.asserts.warnings.expected =
    let
      renamed = {
        xssLockExtraOptions = "xss-lock.extraOptions";
        xautolockExtraOptions = "xautolock.extraOptions";
        enableDetectSleep = "xautolock.detectSleep";
      };
    in
    lib.mapAttrsToList (
      old: new:
      builtins.replaceStrings [ "\n" ] [ " " ] ''
        The option `services.screen-locker.${old}' defined in
        ${lib.showFiles options.services.screen-locker.${old}.files}
        has been renamed to `services.screen-locker.${new}'.''
    ) renamed;
}
