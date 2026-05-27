{ config, pkgs, ... }:

{
  services.openvpn.servers = {
    xddVPN = {
      config = '' config /etc/nixos/secrets/vpn/xdd-vpn-profile.ovpn '';
      autoStart = false;
      updateResolvConf = true;
    };
  };
}
