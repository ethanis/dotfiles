#!/usr/bin/env ruby
require 'erb'

puts "# Syncing to home folder...\n"

def command_found?(command)
  system("which #{command} > /dev/null 2>&1")
end

def link_file file
  if file =~ /.erb$/
    puts "generating ~/.#{file.sub('.erb', '')}"
    File.open(File.join(ENV['HOME'], ".#{file.sub('.erb', '')}"), 'w') do |new_file|
      new_file.write ERB.new(File.read(file)).result(binding)
    end
  else
    puts "linking ~/.#{file}"
    system %Q{ln -s "$PWD/#{file}" "$HOME/.#{file}"}
  end
end

def replace_file(file)
  system %Q{rm -rf "$HOME/.#{file.sub('.erb', '')}"}
  link_file(file)
end

def install
  replace_all = false

  [*Dir['*'], *Dir['config/*']].each do |file|
    next if %w[Readme.md LICENSE install.sh config].include? file

    if File.exist?(File.join(ENV['HOME'], ".#{file.sub('.erb', '')}"))
      if File.identical? file, File.join(ENV['HOME'], ".#{file.sub('.erb', '')}")
        puts "identical ~/.#{file.sub('.erb', '')}"
      elsif replace_all
        replace_file(file)
      else
        print "overwrite ~/.#{file.sub('.erb', '')}? [ynaq] "
        case $stdin.gets.chomp
        when 'a'
          replace_all = true
          replace_file(file)
        when 'y'
          replace_file(file)
        when 'q'
          exit
        else
          puts "skipping ~/.#{file.sub('.erb', '')}"
        end
      end
    else
      link_file(file)
    end
  end
end

if command_found?("starship")
  puts "Installing starship"

  # system %Q{sh -c "$(curl -fsSL https://starship.rs/install.sh)"}
  system "mkdir #{ENV['HOME']}/.config/zsh"
  # zsh-syntax-highlighting
  system "git clone --depth 1 'https://github.com/zsh-users/zsh-syntax-highlighting.git' \"#{ENV['HOME']}/.config/zsh/zsh-syntax-highlighting\""
  # zsh-autosuggestions
  system "git clone --depth 1 'https://github.com/zsh-users/zsh-autosuggestions.git' \"#{ENV['HOME']}/.config/zsh/zsh-autosuggestions\""
  # zsh-history-substring-search
  system "git clone --depth 1 'https://github.com/zsh-users/zsh-history-substring-search.git' \"#{ENV['HOME']}/.config/zsh/zsh-history-substring-search\""
end 

puts "Syncing dotfiles"
install

puts ""
puts "All done!"