require 'rake/clean'
require 'rake/testtask'
require 'fileutils'
require 'date'

class String
    def red; colorize(self, "\e[1m\e[31m"); end
    def green; colorize(self, "\e[1m\e[32m"); end
    def dark_green; colorize(self, "\e[32m"); end
    def yellow; colorize(self, "\e[1m\e[33m"); end
    def blue; colorize(self, "\e[1m\e[34m"); end
    def dark_blue; colorize(self, "\e[34m"); end
    def pur; colorize(self, "\e[1m\e[35m"); end
    def colorize(text, color_code)  "#{color_code}#{text}\e[0m" end
end

def symlink(target, link)
    puts "Linking #{link} => #{target}".green
    if File.symlink?(link)
        File.unlink(link)
    elsif File.exist?(link)
        puts "File exists: #{link}".red
        return
    end
    File.symlink(target, link)
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
    puts "Copying files to home".green
    home = ENV['HOME'] || '~'
    dir = "#{home}/Dotfiles"

    sh "cp -r #{dir} #{dir}_bak_#{Date.today.to_s}"

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
