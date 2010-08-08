require 'rake/clean'
require 'rake/testtask'
require 'fileutils'
require 'date'
require 'git'

def stop_error(message)
    puts "ERROR: #{message}"
    exit(1)
end

def symlink(target, link)
    puts "Linking #{link} => #{target}"
    if File.symlink?(link)
        puts " * deleting existing symlink #{link}"
        File.unlink(link)
    elsif File.exist?(link)
        stop_error("File exists: #{link}")
    end
    File.symlink(target, link)
    puts
end

desc "Install all dotfiles"
task :install do
    home = ENV['HOME']
    pwd = File.dirname(__FILE__)

    FileList['.*'].exclude(/^(\.{1,2}|.git)$/).each do |file|
        symlink("#{pwd}/#{file}", "#{home}/#{file}")
    end
end

desc "Copy to home directory (windows)"
task :copy do
    puts "Copying files to home"
    home = ENV['HOME'] || '~'
    dir = "#{home}/Dotfiles"

    sh "mv #{dir} #{dir}_bak_#{Date.today.to_s}"

    sh <<-SH
        rsync \
        --exclude=.git \
        --exclude=custom \
        --exclude=history \
        --delete \
        --copy-links \
        -ruv \
        . \
        #{dir}
    SH

    sh "rsync --delete -ruv #{dir}/.vim/ #{home}/.vim"
    sh "cp #{dir}/.vimrc #{home}/.vimrc"
end
