require 'rake'
require 'erb'

desc "install the dot files into user's home directory"
task :install do
  replace_all = false
  install_homebrew
  install_homebrew_utils
  install_node
  install_npm_packages

  Dir['*'].each do |file|
    next if %w[Rakefile README.rdoc LICENSE].include? file
    
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

def install_homebrew
  puts "Installing homebrew"

  system('/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"', out: STDOUT) unless command_found?("brew")
end

def install_homebrew_utils
  puts "Installing rbenv"
  system('brew install rbenv', out: STDOUT) unless command_found?("rbenv")
  puts "Installing thefuck"
  system('brew install thefuck', out: STDOUT) unless command_found?("thefuck")
end

def install_node
  puts "Installing nvm"
  system('curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash', out: STDOUT) unless command_found?("nvm")
  puts "Installing node"
  system('nvm install node', out: STDOUT) unless command_found?("node")
end

def install_npm_packages
  puts "Installing spaceship-prompt"
  system('npm install -g spaceship-prompt', out: STDOUT)
end

def command_found?(command)
  system("which #{command} > /dev/null 2>&1")
end

def replace_file(file)
  system %Q{rm -rf "$HOME/.#{file.sub('.erb', '')}"}
  link_file(file)
end

def link_file(file)
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
