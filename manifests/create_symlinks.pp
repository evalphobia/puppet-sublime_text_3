# Public: Create Symlinks for Sublime Text 3 packages && installed packages.
#
# namevar - The name of the package.
# source_dir  - The actual directory where you saved the sublime text 3 configs
# dest_dir - The sublime text 3 config path 
# (default path is "/Users/$USER/Library/Application Support/Sublime Text 3")
#
# Examples
#
#   sublime_text_3::create_symlinks { '':
#     source_dir => '/Users/<your name>/Dropbox/configs/sublimetext3'
#   }
define sublime_text_3::create_symlinks($source_dir, $dest_dir = false) {
  require sublime_text_3::config

  if $dest_dir == false {
    $packages_dir = $sublime_text_3::config::packages_dir
    $installed_packages_dir = $sublime_text_3::config::installed_packages_dir
  }else{
    $packages_dir = "${dest_dir}/Packages"
    $installed_packages_dir = "${dest_dir}/Installed Packages"
  }

  sublime_text_3::create_symlinks::make_link {
    "Packages" :
      from => "$source_dir/Packages",
      to => $packages_dir;
    "Installed Packages" :
      from => "$source_dir/Installed Packages",
      to => $installed_packages_dir;
  }
}

define sublime_text_3::create_symlinks::make_link($from, $to){
  exec { "create symlink for ${to}" :
      command => "mv '${to}' \"${to}.backup.`date +'%Y%m%d-%H%M%S'`\" && ln -Fis '${from}' '${to}'",
      require => Package['SublimeText3'],
      onlyif => [             # when ${to} is a directory and is not a symlink
        "test -d '${to}'",    # assert if ${to} is a directory
        "test ! -L '${to}'",  # assert if ${to} isn't a symlink
      ]
  }
}