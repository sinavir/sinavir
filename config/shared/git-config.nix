{...}: {
  programs.git = {
    enable = true;
    config = {
      user = {
        name = "sinavir";
        email = "sinavir@sinavir.fr";
      };
      rerere.enable = true;
      column.ui = "auto";
      alias = {
        co = "checkout";
        ci = "commit";
        br = "branch --all -v";
        st = "status";
        lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all";
      };
      sendemail = {
	smtpserver = "mail.sinavir.fr";
	smtpuser = "sinavir@sinavir.fr";
	smtpencryption = "ssl";
        smtpserverport = 465;
      };
    };
  };
}
