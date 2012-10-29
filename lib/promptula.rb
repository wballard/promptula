require "promptula/version"
require "rainbow"
module Promptula
  SEPARATOR = "\u25B6"
  SEPARATOR_THIN = "\u276F"
  PATH_SEPARATOR = "\u22F0"
  PATH_SEPARATOR = '/'
  BACKGROUND = "3a3a3a"

  def self.pre(color)
    SEPARATOR.background(color).foreground(BACKGROUND)
  end

  def self.post(color)
    SEPARATOR.foreground(color)
  end

  def self.cwd()
    current = Dir.pwd
    home = ENV['HOME']
    ret = ''
    current.sub(home, '~').split('/').each do |segment|
      ret += PATH_SEPARATOR.foreground("808080").background BACKGROUND if segment != '~'
      ret += "#{segment}".foreground(:default).background BACKGROUND
    end
    ret + ' '.background(BACKGROUND)
  end

  def self.git()
    branch = '<unknown>'
    `git branch`.split("\n").each do |line|
      puts line
      if line[0] == '*'
        branch = line.sub('*', '').chomp
      end
    end
    status = `git status --porcelain`
    untracked = status.match('\?\?').size > 0 ? '+' : ''
    dirty = status.size > 0
    background = dirty ? :red : :green
    pre(background) +
    "#{branch}#{untracked} ".background(dirty ? :red : :green).bright +
    post(background)
  end

  def self.prompt()
    Sickill::Rainbow.enabled = true
    cwd() + git()
  end
end
